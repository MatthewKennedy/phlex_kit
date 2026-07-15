# frozen_string_literal: true

# Shared driving helpers for the interaction suites. Cuprite has no
# page-level send_keys, so keyboard input always goes through the element
# that currently holds focus — which is also what a real user does.
module InteractionHelpers
  # The element currently holding focus, as a Capybara node.
  def active_element
    page.evaluate_script("document.activeElement")
  end

  # Pure keyboard input to whatever holds focus. NOT element#send_keys:
  # Cuprite clicks the node before typing, which would activate focused menu
  # items / dialog buttons. Ferrum key symbols: :tab, :escape, :enter, :home,
  # :end, :down/:up/:left/:right — or plain strings for characters.
  def press(*keys)
    page.driver.browser.keyboard.type(*keys)
  end

  # Real CDP mouse click at viewport coordinates (for backdrop/padding hits
  # that Capybara's element-centred click can't express).
  def click_at(x, y)
    page.driver.browser.mouse.click(x: x, y: y)
  end

  # Poll a condition with Capybara's waiting machinery — no bare sleeps.
  def wait_until(message = "condition not met within wait time")
    page.document.synchronize(Capybara.default_max_wait_time, errors: [ Capybara::ExpectationNotMet ]) do
      raise Capybara::ExpectationNotMet, message unless yield
    end
    assert true # synchronize either returned or raised
  end

  # Bounding client rect of a Capybara element as a Hash of floats.
  def rect_of(element)
    page.evaluate_script("arguments[0].getBoundingClientRect().toJSON()", element)
  end

  # One docs demo section — DemoFrame stamps the parameterized demo title as
  # the h2 id, so "Month and Year Selector" → #month-and-year-selector.
  def demo(title)
    find("section.docs-demo:has(h2##{title.parameterize})")
  end

  # True when every non-modal top-level body child is inert (the modal clone
  # is identified as the child containing `panel_selector`).
  def background_inert?(panel_selector)
    page.evaluate_script(<<~JS)
      (() => {
        const others = [...document.body.children].filter((el) =>
          !["SCRIPT", "STYLE", "LINK", "TEMPLATE"].includes(el.tagName) &&
          !el.querySelector(#{panel_selector.to_json}));
        return others.length > 0 && others.every((el) => el.inert);
      })()
    JS
  end

  # True when no top-level body child is inert any more.
  def background_inert_cleared?
    page.evaluate_script("[...document.body.children].every((el) => !el.inert)")
  end
end
