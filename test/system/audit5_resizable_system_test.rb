# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Round-5 audit: keyboard resizes (Home/End/arrows) and drags must respect a
# panel's min_size:/max_size: percentages — Home used to collapse a panel to
# literal 0. Unconstrained panels must keep the old collapse-to-zero behavior.
class Audit5ResizableSystemTest < SystemTestCase
  include InteractionHelpers

  def test_keyboard_resize_clamps_to_min_and_max_size
    visit "/docs/resizable"
    section = demo("Min and max sizes")
    handle = section.find(".pk-resizable-handle")
    bounded = section.first(".pk-resizable-panel")

    page.execute_script("arguments[0].focus()", handle)

    # Home tries to collapse the leading panel; min_size: 20 (of a 100-grow
    # group) must floor its flex-grow at 20 instead of 0.
    press(:home)
    wait_until("Home did not clamp to min_size") { grow_of(bounded) == 20.0 }
    5.times { press(:left) }
    wait_until("arrows pushed the panel below min_size") { grow_of(bounded) == 20.0 }

    # End tries to take the whole pair; max_size: 60 must cap it.
    press(:end)
    wait_until("End did not clamp to max_size") { grow_of(bounded) == 60.0 }
    5.times { press(:right) }
    wait_until("arrows pushed the panel above max_size") { grow_of(bounded) == 60.0 }

    # The neighbour always absorbs the remainder of the pair's grow (100).
    assert_equal 40.0, grow_of(section.all(".pk-resizable-panel")[1])
    # aria-valuenow reflects the clamped share of the pair.
    assert_equal "60", handle["aria-valuenow"]
  end

  def test_unbounded_panels_keep_collapse_to_zero_behavior
    visit "/docs/resizable"
    section = demo("Default")
    handle = section.first(".pk-resizable-handle")
    panel = section.first(".pk-resizable-panel")

    page.execute_script("arguments[0].focus()", handle)
    press(:home)
    wait_until("Home no longer collapses an unbounded panel") { grow_of(panel) == 0.0 }
  end

  private

  def grow_of(element)
    page.evaluate_script("parseFloat(getComputedStyle(arguments[0]).flexGrow)", element)
  end
end
