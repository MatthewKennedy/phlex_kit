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
      end
    end
  end
end
