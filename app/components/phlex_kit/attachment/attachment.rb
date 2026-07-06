module PhlexKit
  # File chip, ported from shadcn/ui's Attachment: media (icon or image),
  # name + metadata, optional actions, upload state and a full-card trigger.
  # `state:` drives styling — :uploading/:processing shimmer the title, :error
  # goes destructive; `size:` (:default/:sm/:xs) and `orientation:`
  # (:horizontal/:vertical) shape the card. Lay several out in an
  # AttachmentGroup (scrollable, snapping, edge-faded row).
  # `.pk-attachment*` (attachment.css).
  class Attachment < BaseComponent
    STATES = { idle: "idle", uploading: "uploading", processing: "processing", error: "error", done: "done" }.freeze
    SIZES = { default: nil, sm: "sm", xs: "xs" }.freeze
    ORIENTATIONS = { horizontal: nil, vertical: "vertical" }.freeze

    def initialize(state: :done, size: :default, orientation: :horizontal, **attrs)
      @state = state.to_sym
      @size = size.to_sym
      @orientation = orientation.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: [ "pk-attachment", fetch_option(SIZES, @size, :size), fetch_option(ORIENTATIONS, @orientation, :orientation) ].compact.join(" "),
        data: { state: fetch_option(STATES, @state, :state) }
      }, @attrs), &)
    end
  end
end
