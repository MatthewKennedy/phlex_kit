module PhlexKit
  # Copy-to-clipboard with success/error confirmation popovers (CSS-positioned,
  # no @floating-ui). Ported from ruby_ui's RubyUI::Clipboard. Compose Clipboard >
  # (ClipboardSource + ClipboardTrigger). phlex-kit--clipboard.
  class Clipboard < BaseComponent
    def initialize(success: "Copied!", error: "Copy failed!", **attrs)
      @success = success
      @error = error
      @attrs = attrs
    end
    def view_template(&block)
      div(**mix({ class: "pk-clipboard", data: { controller: "phlex-kit--clipboard", action: "click@window->phlex-kit--clipboard#onClickOutside" } }, @attrs)) do
        div(&block)
        render PhlexKit::ClipboardPopover.new(type: :success) { @success }
        render PhlexKit::ClipboardPopover.new(type: :error) { @error }
        # A persistent (never display:none) sr-only live region: the visual
        # popovers are shown by removing display:none, which re-inserts them
        # into the a11y tree with pre-existing content — a change AT does not
        # announce. This region stays in the tree; the controller writes the
        # confirmation text into it on copy, and THAT mutation announces.
        div(class: "pk-sr-only", role: "status", aria: { live: "polite" },
            data: { phlex_kit__clipboard_target: "liveRegion" })
      end
    end
  end
end
