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
      base = {
        type: :button,
        class: "pk-combobox-clear-button pk-hidden",
        data: {
          phlex_kit__combobox_target: "clearButton",
          action: "phlex-kit--combobox#clearAll"
        }
      }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:aria] = { label: "Clear selection" } unless aria_labelled?
      button(**mix(base, @attrs)) do
        render Icon.new(:x, size: 24)
      end
    end
  end
end
