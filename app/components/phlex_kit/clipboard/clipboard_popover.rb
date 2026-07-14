module PhlexKit
  class ClipboardPopover < BaseComponent
    TARGETS = { success: "successPopover", error: "errorPopover" }.freeze
    def initialize(type:, **attrs)
      @type = type.to_sym
      @attrs = attrs
    end
    def view_template(&block)
      # role="status": the shown/hidden confirmation is a live region, so
      # screen readers announce "Copied!" instead of a silent visual flash.
      div(class: "pk-clipboard-popover pk-hidden", role: "status", data: { phlex_kit__clipboard_target: fetch_option(TARGETS, @type, :target) }) do
        div(**mix({ class: "pk-clipboard-popover-inner" }, @attrs), &block)
      end
    end
  end
end
