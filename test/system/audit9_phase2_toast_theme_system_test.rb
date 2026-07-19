# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 9, phase 2 — toast region flash adoption on Turbo Drive visits,
# focus restore, duration inheritance, close-button dedup, and theme_toggle
# persistence/cross-tab correctness.
class Audit9Phase2ToastThemeSystemTest < SystemTestCase
  include InteractionHelpers

  # HIGH: the region is data-turbo-permanent, so Turbo keeps the OLD region and
  # discards the incoming page's — its server-rendered flash toasts must be
  # adopted into the permanent list on turbo:before-render, not dropped.
  def test_flash_toasts_are_adopted_from_the_incoming_turbo_body
    visit "/docs/toast"

    adopted = page.evaluate_script(<<~JS)
      (() => {
        const newBody = document.createElement("body");
        // An incoming page's toaster region with one server-rendered flash toast.
        newBody.innerHTML =
          '<div id="pk-toaster-region"><ol id="pk-toaster" class="pk-toast-list">' +
          '<li id="flash-notice" class="pk-toast" data-controller="phlex-kit--toast" ' +
          'data-phlex-kit--toaster-target="toast" role="status">Welcome back</li></ol></div>';
        document.dispatchEvent(new CustomEvent("turbo:before-render", { detail: { newBody } }));
        return !!document.querySelector("#pk-toaster #flash-notice");
      })()
    JS

    assert adopted, "incoming flash toast should be adopted into the permanent region"
    assert_selector "#pk-toaster .pk-toast", text: "Welcome back"
  end

  # Dismissing a FOCUSED toast hands focus to an adjacent toast, not <body>.
  def test_focus_moves_to_an_adjacent_toast_on_dismiss
    visit "/docs/toast"
    page.execute_script("PhlexKit.toast('First', { id: 'tf-1', duration: 0 })")
    page.execute_script("PhlexKit.toast('Second', { id: 'tf-2', duration: 0 })")
    assert_selector "#tf-1"
    assert_selector "#tf-2"

    page.execute_script("document.getElementById('tf-2').focus()")
    press(:escape) # dismiss the focused toast

    wait_until("focus should move to the remaining toast, not <body>") do
      page.evaluate_script("document.activeElement && document.activeElement.id") == "tf-1"
    end
  end

  # A block-rendered toast (no duration of its own) inherits the region's
  # duration instead of the controller's 4000ms default.
  def test_block_toast_inherits_region_duration
    visit "/docs/toast"
    region_duration = page.evaluate_script(
      "document.getElementById('pk-toaster-region').getAttribute('data-phlex-kit--toaster-duration-value')"
    )

    inherited = page.evaluate_script(<<~JS)
      (() => {
        const li = document.createElement("li");
        li.className = "pk-toast";
        li.setAttribute("data-controller", "phlex-kit--toast");
        li.setAttribute("data-phlex-kit--toaster-target", "toast");
        li.setAttribute("role", "status");
        li.textContent = "Block toast";
        document.getElementById("pk-toaster").appendChild(li);
        return li;
      })()
    JS

    wait_until("block toast should inherit the region's duration on connect") do
      page.evaluate_script(<<~JS) == region_duration
        (document.querySelector("#pk-toaster li.pk-toast:last-child") || {})
          .getAttribute && document.querySelector("#pk-toaster li.pk-toast:last-child")
          .getAttribute("data-phlex-kit--toast-duration-value")
      JS
    end
    assert inherited
  end

  # The docs layout mounts its shared region with close_button: true, so its
  # skeleton already bakes a × in. Spawning with closeButton: true must not
  # stack a second one.
  def test_no_double_close_button_when_skeleton_already_has_one
    visit "/docs/toast"
    page.execute_script("PhlexKit.toast('Dedup', { id: 'cb-toast', closeButton: true, duration: 0 })")
    assert_selector "#cb-toast"

    count = page.evaluate_script(
      "document.getElementById('cb-toast').querySelectorAll('[data-slot=\"close\"]').length"
    )
    assert_equal 1, count
  end

  # A host-code write to :root[data-theme] must NOT be persisted as a user toggle.
  def test_host_data_theme_write_is_not_persisted
    visit "/docs/theme-toggle"
    page.execute_script("try { localStorage.removeItem('theme') } catch (e) {}")

    # Simulate host code flipping the theme directly.
    page.execute_script("document.documentElement.setAttribute('data-theme', 'dark')")

    # The toggle's observer re-syncs, but nothing should have been persisted.
    stored = page.evaluate_script("(() => { try { return localStorage.theme || null } catch (e) { return null } })()")
    assert_nil stored, "a host data-theme write must not be written to localStorage"
  ensure
    page.execute_script("try { localStorage.removeItem('theme') } catch (e) {}; document.documentElement.setAttribute('data-theme', 'system')")
  end

  # A storage event from another tab re-applies the theme to this tab's root.
  def test_storage_event_syncs_theme_across_tabs
    visit "/docs/theme-toggle"
    page.execute_script(<<~JS)
      try { localStorage.theme = "dark" } catch (e) {}
      window.dispatchEvent(new StorageEvent("storage", { key: "theme", newValue: "dark" }));
    JS

    wait_until("the storage event should apply the new theme to :root") do
      page.evaluate_script("document.documentElement.getAttribute('data-theme')") == "dark"
    end
  ensure
    page.execute_script("try { localStorage.removeItem('theme') } catch (e) {}; document.documentElement.setAttribute('data-theme', 'system')")
  end
end
