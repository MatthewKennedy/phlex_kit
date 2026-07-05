module PhlexKit
  # Addon inside an InputGroup — icons, text or small buttons. `align:` places
  # it: :start / :end inline beside the control (shadcn's inline-start/-end),
  # :block_start / :block_end as full-width header/footer rows (the group
  # stacks into a column). See input_group.rb.
  class InputGroupAddon < BaseComponent
    ALIGNS = {
      start: "start",
      end: "end",
      block_start: "block-start",
      block_end: "block-end"
    }.freeze

    def initialize(align: :start, **attrs)
      @align = align.to_sym
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-input-group-addon #{ALIGNS.fetch(@align)}", role: "group" }, @attrs), &)
    end
  end
end
