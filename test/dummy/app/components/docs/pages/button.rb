# frozen_string_literal: true

module Docs
  module Pages
    class Button < Docs::BasePage
      self.description = "Displays a button or a component that looks like a button."

      def demos
        demo Docs::Examples::Button::Size, title: "Size"
        demo Docs::Examples::Button::Default, title: "Default"
        demo Docs::Examples::Button::Outline, title: "Outline"
        demo Docs::Examples::Button::Secondary, title: "Secondary"
        demo Docs::Examples::Button::Ghost, title: "Ghost"
        demo Docs::Examples::Button::Destructive, title: "Destructive"
        demo Docs::Examples::Button::Link, title: "Link"
        demo Docs::Examples::Button::Icon, title: "Icon"
        demo Docs::Examples::Button::WithIcon, title: "With Icon"
        demo Docs::Examples::Button::Rounded, title: "Rounded"
        demo Docs::Examples::Button::SpinnerDemo, title: "Spinner"
        demo Docs::Examples::Button::AsChild, title: "As Child"
      end
    end
  end
end
