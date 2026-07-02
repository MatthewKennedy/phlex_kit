module PhlexKit
  # Modal dialog built on the native <dialog> element (showModal). Ported from
  # ruby_ui's RubyUI::Dialog. Compose Dialog > (DialogTrigger + DialogContent >
  # DialogHeader/Title/Description/Middle/Footer). phlex-kit--dialog.
  class Dialog < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ data: { controller: "phlex-kit--dialog", phlex_kit__dialog_open_value: @open } }, @attrs), &)
    end
  end
end
