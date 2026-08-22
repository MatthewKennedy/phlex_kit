# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# The last two RTL exemptions, closed in 0.16.0:
#   1. Resizable's pointer drag assumed LTR — clientX grows toward the
#      trailing panel, which is the LEADING panel in RTL, so a drag moved the
#      divider the wrong way (its keyboard arrows were already direction-aware).
#   2. Sidebar was physically left-pinned; it now sits on the reading-start
#      side and takes side: :start/:end.
class RtlPointerSystemTest < SystemTestCase
  include InteractionHelpers

  def force_rtl
    page.execute_script(%(document.documentElement.dir = "rtl"))
  end

  def teardown
    page.execute_script(%(document.documentElement.dir = "ltr"))
    super
  end

  # Drag the divider toward the visual RIGHT. The divider must follow the
  # pointer in both directions. In RTL the panels run right-to-left, so the
  # FIRST panel is the rightmost one and its inline-start edge IS the handle:
  # moving the handle right must SHRINK it. The LTR assumption did the
  # opposite, growing it and driving the divider away from the pointer.
  def drag_first_handle_right_by(pixels)
    page.execute_script(<<~JS)
      const handle = document.querySelector(".pk-resizable-handle");
      const r = handle.getBoundingClientRect();
      const x0 = r.left + r.width / 2, y0 = r.top + r.height / 2;
      handle.dispatchEvent(new PointerEvent("pointerdown", { bubbles: true, clientX: x0, clientY: y0, pointerId: 1, detail: 1, isPrimary: true, button: 0 }));
      handle.dispatchEvent(new PointerEvent("pointermove", { bubbles: true, clientX: x0 + #{pixels}, clientY: y0, pointerId: 1, detail: 1, isPrimary: true, button: 0 }));
      handle.dispatchEvent(new PointerEvent("pointerup", { bubbles: true, clientX: x0 + #{pixels}, clientY: y0, pointerId: 1, detail: 1, isPrimary: true, button: 0 }));
    JS
  end

  def first_panel_grow
    page.evaluate_script(%(parseFloat(getComputedStyle(document.querySelector(".pk-resizable-panel")).flexGrow)))
  end

  def test_rtl_drag_grows_the_panel_the_pointer_moves_toward
    visit "/docs/resizable"
    force_rtl
    before = first_panel_grow
    drag_first_handle_right_by(120)
    assert_operator first_panel_grow, :<, before,
      "a rightward drag in RTL must shrink the right-hand (first) panel — the divider follows the pointer"
  end

  def test_ltr_drag_direction_is_unchanged
    visit "/docs/resizable"
    before = first_panel_grow
    drag_first_handle_right_by(120)
    assert_operator first_panel_grow, :>, before,
      "a rightward drag in LTR must still grow the left-hand (first) panel"
  end

  # --- Sidebar side: -------------------------------------------------------

  # Which half of its own wrapper does the sidebar panel sit in?
  def sidebar_on_right?(frame_id)
    page.evaluate_script(<<~JS)
      (() => {
        const wrap = document.querySelector("##{frame_id} .pk-sidebar-wrapper");
        const panel = wrap.querySelector(".pk-sidebar");
        const w = wrap.getBoundingClientRect(), p = panel.getBoundingClientRect();
        return (p.left + p.width / 2) > (w.left + w.width / 2);
      })()
    JS
  end

  def test_default_sidebar_sits_on_the_left_in_ltr
    visit "/gallery"
    refute sidebar_on_right?("pk-sidebar-default"), "side: :start must be the left edge in LTR"
  end

  # The exemption that's being closed: a bare sidebar used to stay physically
  # left even in an RTL document. :start means READING-start.
  def test_default_sidebar_sits_on_the_right_in_rtl
    visit "/gallery"
    force_rtl
    assert sidebar_on_right?("pk-sidebar-default"), "side: :start must be the right edge in RTL"
  end

  def test_side_end_sits_on_the_right_in_ltr
    visit "/gallery"
    assert sidebar_on_right?("pk-sidebar-side-end"), "side: :end must be the right edge in LTR"
  end

  def test_side_end_sits_on_the_left_in_rtl
    visit "/gallery"
    force_rtl
    refute sidebar_on_right?("pk-sidebar-side-end"), "side: :end must be the left edge in RTL"
  end

  # Placement alone was never the whole exemption: the wrapper is a flex row,
  # so RTL already reversed the panel to the right. The physical border-right
  # did NOT flip, leaving the divider drawn against the viewport edge instead
  # of the content. This is the assertion the logical rewrite actually buys.
  def test_default_sidebar_border_faces_the_content_in_rtl
    visit "/gallery"
    force_rtl
    styles = page.evaluate_script(<<~JS)
      (() => {
        const p = document.querySelector("#pk-sidebar-default .pk-sidebar");
        const s = getComputedStyle(p);
        return [s.borderLeftWidth, s.borderRightWidth];
      })()
    JS
    assert_equal "1px", styles[0], "in RTL the start-side sidebar must border on its LEFT (inline-end)"
    assert_equal "0px", styles[1], "the old physical border-right drew against the viewport edge"
  end

  # The panel's border must face the content, not the viewport edge.
  def test_side_end_border_faces_the_content
    visit "/gallery"
    styles = page.evaluate_script(<<~JS)
      (() => {
        const p = document.querySelector("#pk-sidebar-side-end .pk-sidebar");
        const s = getComputedStyle(p);
        return [s.borderLeftWidth, s.borderRightWidth];
      })()
    JS
    assert_equal "1px", styles[0], "side: :end must border on its inline-start (left in LTR)"
    assert_equal "0px", styles[1]
  end
end
