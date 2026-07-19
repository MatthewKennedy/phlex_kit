module PhlexKit
  class ClipboardPopover < BaseComponent
    TARGETS = { success: "successPopover", error: "errorPopover" }.freeze
    def initialize(type:, **attrs)
      @type = type.to_sym
      @attrs = attrs
    end
    def view_template(&block)
      # Visual-only now (aria-hidden): the announcement rides Clipboard's
      # persistent sr-only role="status" live region — toggling display:none
      # on this element never announced, since AT ignores content that was
      # already present when a region re-enters the tree.
      div(class: "pk-clipboard-popover pk-hidden", aria: { hidden: "true" }, data: { phlex_kit__clipboard_target: fetch_option(TARGETS, @type, :target) }) do
        div(**mix({ class: "pk-clipboard-popover-inner" }, @attrs), &block)
      end
    end
  end
end
