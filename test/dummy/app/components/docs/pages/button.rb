# frozen_string_literal: true

module Docs
  module Pages
    class Button < Docs::BasePage
      self.description = "Displays a button or a component that looks like a button."

      def demos
        demo Docs::Examples::Button::Variants, title: "Variants"
        demo Docs::Examples::Button::Sizes, title: "Sizes"
        demo Docs::Examples::Button::Icon, title: "Icon"
        demo Docs::Examples::Button::WithIcon, title: "With icon"
        demo Docs::Examples::Button::Loading, title: "Loading"
        demo Docs::Examples::Button::AsLink, title: "As link"
      end
    end
  end
end
