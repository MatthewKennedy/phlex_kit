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
      # No role: shadcn puts role="group" on its addon, but an unnamed group
      # nested inside the InputGroup's own group is noise for AT — a text or
      # icon addon needs no role, and interactive addon children (buttons)
      # carry their own semantics.
      div(**mix({ class: "pk-input-group-addon #{fetch_option(ALIGNS, @align, :align)}" }, @attrs), &)
    end
  end
end
