# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5 (input/scroller batch): masked_input IME commits and
# full-width digits; message_scroller viewport-less prepend safety, middle
# insert classification, and history-prepend position preservation.
class Audit5InputScrollerSystemTest < SystemTestCase
  include InteractionHelpers

  # Safari fires the final input event with isComposing still true, so the
  # input listener skips it — the compositionend listener must mask the
  # committed text instead.
  def test_masked_input_masks_ime_committed_text_on_compositionend
    visit "/docs/masked-input"
    field = find("input[placeholder='Date: ##/##/####']")
    page.execute_script(<<~JS, field)
      const el = arguments[0]
      el.focus()
      el.value = "12311999"
      el.dispatchEvent(new CompositionEvent("compositionend", { bubbles: true, data: "12311999" }))
    JS
    wait_until("compositionend did not apply the mask") { field.value == "12/31/1999" }
  end

  # Full-width digits (１２３… — common IME numeric output) must be
  # transliterated to ASCII, not silently discarded by the charset filter.
  def test_masked_input_transliterates_full_width_digits
    visit "/docs/masked-input"
    field = find("input[placeholder='Date: ##/##/####']")
    page.execute_script(<<~JS, field)
      const el = arguments[0]
      el.focus()
      el.value = "１２３１１９９９"
      el.dispatchEvent(new CompositionEvent("compositionend", { bubbles: true, data: "１２３１１９９９" }))
    JS
    wait_until("full-width digits were not transliterated into the mask") { field.value == "12/31/1999" }
  end

  # A scroller marked up without a viewport target must survive a history
  # prepend — the unguarded viewportTarget getter used to throw inside the
  # MutationObserver callback (caught by this suite's JS-error trap).
  def test_message_scroller_prepend_without_viewport_target_does_not_throw
    visit "/docs/message-scroller"
    page.execute_script(<<~JS)
      const el = document.createElement("div")
      el.id = "ms-audit5-no-viewport"
      el.dataset.controller = "phlex-kit--message-scroller"
      el.innerHTML = '<div data-phlex-kit--message-scroller-target="content"><div>row 1</div><div>row 2</div></div>'
      document.body.appendChild(el)
    JS
    wait_until("controller did not connect") do
      page.evaluate_script(<<~JS)
        !!window.Stimulus.getControllerForElementAndIdentifier(
          document.getElementById("ms-audit5-no-viewport"), "phlex-kit--message-scroller")
      JS
    end
    page.execute_script(<<~JS)
      const content = document.querySelector('#ms-audit5-no-viewport [data-phlex-kit--message-scroller-target="content"]')
      const row = document.createElement("div")
      row.textContent = "older row"
      content.prepend(row)
    JS
    # The MutationObserver callback runs as a microtask; poll until the row
    # landed, then confirm the error trap stayed empty (teardown also flunks).
    wait_until("prepended row never appeared") do
      page.evaluate_script(<<~JS) == 3
        document.querySelector('#ms-audit5-no-viewport [data-phlex-kit--message-scroller-target="content"]').children.length
      JS
    end
    assert_empty page.evaluate_script("window.__pkJsErrors || []")
  end

  # A row inserted BETWEEN existing rows is neither history nor a new turn:
  # it must not trigger scrollToEnd while the reader is following. A true
  # append still must.
  def test_message_scroller_middle_insert_is_not_treated_as_append
    visit "/docs/message-scroller"
    page.execute_script(<<~JS)
      const el = document.getElementById("ms-history")
      const c = window.Stimulus.getControllerForElementAndIdentifier(el, "phlex-kit--message-scroller")
      // Isolate the MutationObserver path — content growth would otherwise
      // legitimately re-pin via the ResizeObserver and muddy the count.
      c.resizeObserver.disconnect()
      c.__endCalls = 0
      const orig = c.scrollToEnd.bind(c)
      c.scrollToEnd = (...a) => { c.__endCalls++; return orig(...a) }
      const content = el.querySelector('[data-phlex-kit--message-scroller-target="content"]')
      const mid = document.createElement("div")
      mid.textContent = "edited into the middle"
      content.insertBefore(mid, content.children[4])
    JS
    wait_until("middle insert never landed") do
      page.evaluate_script(%(document.querySelector('#ms-history [data-phlex-kit--message-scroller-target="content"]').children.length)) == 9
    end
    assert_equal 0, page.evaluate_script(<<~JS), "middle insert must not scrollToEnd"
      window.Stimulus.getControllerForElementAndIdentifier(
        document.getElementById("ms-history"), "phlex-kit--message-scroller").__endCalls
    JS

    page.execute_script(<<~JS)
      const content = document.querySelector('#ms-history [data-phlex-kit--message-scroller-target="content"]')
      const row = document.createElement("div")
      row.textContent = "a genuinely new turn"
      content.appendChild(row)
    JS
    wait_until("true append should still scrollToEnd") do
      page.evaluate_script(<<~JS).positive?
        window.Stimulus.getControllerForElementAndIdentifier(
          document.getElementById("ms-history"), "phlex-kit--message-scroller").__endCalls
      JS
    end
  end

  # Happy path of the guarded prepend adjustment: with a viewport target
  # present, loading history must keep the visible row exactly where it was.
  def test_message_scroller_history_prepend_preserves_the_visible_row
    visit "/docs/message-scroller"
    # Measure relative to the scroller's own viewport — window-relative rects
    # shift when click_button scrolls the page to reach the demo button.
    row_offset = <<~JS
      (() => {
        const bubbles = document.querySelectorAll('#ms-history .pk-bubble-content')
        const viewport = document.querySelector('#ms-history [data-phlex-kit--message-scroller-target="viewport"]')
        return [...bubbles].at(-1).getBoundingClientRect().top - viewport.getBoundingClientRect().top
      })()
    JS
    # The controller applies its opening scroll-to-end in a rAF — sample the
    # baseline only after it settles at the live edge.
    at_end = <<~JS
      (() => {
        const v = document.querySelector('#ms-history [data-phlex-kit--message-scroller-target="viewport"]')
        return v.scrollTop > 0 && v.scrollHeight - (v.scrollTop + v.clientHeight) < 1
      })()
    JS
    wait_until("scroller never settled at the end") { page.evaluate_script(at_end) }
    before = page.evaluate_script(row_offset)

    click_button "Load older messages"
    wait_until("prepended history never landed") do
      page.evaluate_script(%(document.querySelector('#ms-history [data-phlex-kit--message-scroller-target="content"]').children.length)) == 11
    end
    wait_until("visible row drifted after history prepend") do
      (page.evaluate_script(row_offset) - before).abs < 2
    end
  end
end
