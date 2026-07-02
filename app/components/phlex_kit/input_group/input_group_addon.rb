module PhlexKit
  # Leading/trailing addon inside an InputGroup — icons, text or small buttons.
  # See input_group.rb.
  class InputGroupAddon < BaseComponent
    ALIGNS = { start: "start", end: "end" }.freeze

    def initialize(align: :start, **attrs)
      @align = align.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-input-group-addon #{ALIGNS.fetch(@align)}" }, @attrs), &)
    end
  end
end
