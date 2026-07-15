# frozen_string_literal: true

# Helper for the browser suite (rake test:system). Deliberately separate from
# test/test_helper.rb: the unit suite must stay Rails-free, while this one
# boots the test/dummy app and drives it with Capybara + Cuprite (headless
# Chrome over CDP — no selenium/webdriver).
ENV["RAILS_ENV"] = "test"

require "minitest/autorun"
require_relative "../dummy/config/environment"
require "capybara/minitest"
require "capybara/cuprite"

Capybara.register_driver(:pk_cuprite) do |app|
  Capybara::Cuprite::Driver.new(
    app,
    window_size: [ 1400, 900 ],
    headless: ENV["HEADLESS"] != "0", # HEADLESS=0 to watch the browser
    timeout: 15,
    process_timeout: 15,
    browser_options: { "disable-gpu": nil, "no-sandbox": nil }
  )
end

Capybara.default_driver = :pk_cuprite
Capybara.javascript_driver = :pk_cuprite
Capybara.app = Rails.application
Capybara.default_max_wait_time = 5
Capybara.disable_animation = true
Capybara.server = :puma, { Silent: true }

class SystemTestCase < Minitest::Test
  include Capybara::DSL
  include Capybara::Minitest::Assertions

  def teardown
    # Fail the test on any uncaught JS error the page produced. The dummy
    # gallery also surfaces these in a red banner; this catches docs pages too.
    errors = page.driver.browser.options.js_errors ? [] : console_errors
    Capybara.reset_sessions!
    flunk("JS console errors:\n#{errors.join("\n")}") if errors.any?
  end

  private

  # Cuprite tracks console messages per page; collect error-level ones.
  # returnByValue is required — without it Runtime.evaluate returns a remote
  # object REFERENCE for arrays ("value" always nil), and the trap silently
  # never flunked anything (audit round 6).
  def console_errors
    logs = page.driver.browser.page.command(
      "Runtime.evaluate", expression: "window.__pkJsErrors || []", returnByValue: true
    )
    Array(logs.dig("result", "value"))
  rescue StandardError
    []
  end

  # Every page visit installs an error trap before any interaction.
  def visit(path)
    super
    page.execute_script(<<~JS)
      window.__pkJsErrors ||= [];
      window.addEventListener("error", (e) => window.__pkJsErrors.push(String(e.message)));
      window.addEventListener("unhandledrejection", (e) => window.__pkJsErrors.push(String(e.reason)));
      // Stimulus catches action-handler exceptions and reports them via
      // console.error — they never reach window.onerror, so hook it too.
      if (!console.error.__pkTrapped) {
        const original = console.error.bind(console);
        console.error = (...args) => {
          window.__pkJsErrors.push(args.map(String).join(" "));
          original(...args);
        };
        console.error.__pkTrapped = true;
      }
    JS
  end

  # The Stimulus application is pinned by the dummy app's importmap; waiting
  # for a controller-stamped attribute beats sleeping.
  def assert_controller_connected(selector)
    assert_selector(selector, visible: :all)
  end
end
