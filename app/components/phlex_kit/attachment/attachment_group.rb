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
        # at-start + at-end = no edge fades. Server-rendered so a group that
        # FITS shows no false "more content" fade pre-hydration / with JS off;
        # the controller's first update() removes them when there's overflow.
        data: {
          controller: "phlex-kit--scroll-fade",
          phlex_kit__scroll_fade_axis_value: "x",
          at_start: "",
          at_end: ""
        }
      }, @attrs), &)
    end
  end
end
