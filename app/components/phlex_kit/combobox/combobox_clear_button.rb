module PhlexKit
  # × button clearing the whole combobox selection — hidden until something is
  # checked. Ported from ruby_ui's RubyUI::ComboboxClearButton; upstream
  # referenced a clearAll action its controller never defined, so the behaviour
  # is PhlexKit's completion of it. See combobox.rb.
  class ComboboxClearButton < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-combobox-clear-button pk-hidden",
        aria: { label: "Clear selection" },
        data: {
          phlex_kit__combobox_target: "clearButton",
          action: "phlex-kit--combobox#clearAll"
        }
      }, @attrs)) do
        render Icon.new(:x, size: 24)
      end
    end
  end
end
