module PhlexKit
  # Horizontally scrollable, snapping row of Attachments with an edge fade
  # (the phlex-kit--scroll-fade controller in horizontal mode).
  # See attachment.rb.
  class AttachmentGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-attachment-group",
        role: "group",
        data: {
          controller: "phlex-kit--scroll-fade",
          phlex_kit__scroll_fade_axis_value: "x"
        }
      }, @attrs), &)
    end
  end
end
