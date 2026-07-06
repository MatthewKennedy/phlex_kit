module PhlexKit
  # The floating panel of a PhlexKit::Popover — a native [popover=auto]
  # element (top layer, browser light dismiss) anchor-positioned to the
  # trigger with viewport-edge flipping (popover.css). `align: :end` flips it
  # to the trigger's end edge (their align prop). See popover.rb.
  class PopoverContent < BaseComponent
    ALIGNS = { start: nil, end: "end" }.freeze

    def initialize(align: :start, **attrs)
      @align = align.to_sym
      @attrs = attrs
    end

    def view_template(&)
      classes = [ "pk-popover-content", fetch_option(ALIGNS, @align, :align) ].compact.join(" ")
      div(**mix({ class: classes, popover: "auto", data: { phlex_kit__popover_target: "content", state: "closed" } }, @attrs), &)
    end
  end
end
