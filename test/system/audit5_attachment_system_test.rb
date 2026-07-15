# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 5: the attachment group rests at scrollLeft ~2 in LTR
# (scroll-snap + ring padding), so a `<= 1` at-start threshold never fires
# and the start-edge fade never clears at the resting position.
class Audit5AttachmentSystemTest < SystemTestCase
  include InteractionHelpers

  def test_attachment_group_is_at_start_at_rest
    visit "/docs/attachment"
    group = demo("Group").find(".pk-attachment-group")
    wait_until("group never reported data-at-start at its resting position") do
      group[:"data-at-start"]
    end
  end
end
