# frozen_string_literal: true

module Docs
  module Pages
    class ToggleGroup < Docs::BasePage
      self.description = "A set of two-state buttons that can be toggled on or off."

      def demos
        demo Docs::Examples::ToggleGroup::Default, title: "Default"
        demo Docs::Examples::ToggleGroup::Outline, title: "Outline"
        demo Docs::Examples::ToggleGroup::Sizes, title: "Size"
        demo Docs::Examples::ToggleGroup::Spacing, title: "Spacing"
        demo Docs::Examples::ToggleGroup::Vertical, title: "Vertical"
        demo Docs::Examples::ToggleGroup::Disabled, title: "Disabled"
      end
    end
  end
end
