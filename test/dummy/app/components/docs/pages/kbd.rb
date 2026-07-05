# frozen_string_literal: true

module Docs
  module Pages
    class Kbd < Docs::BasePage
      self.description = "Displays keyboard input or shortcuts."

      def demos
        demo Docs::Examples::Kbd::Default, title: "Default"
        demo Docs::Examples::Kbd::Group, title: "Group"
        demo Docs::Examples::Kbd::InButton, title: "Button"
        demo Docs::Examples::Kbd::InTooltip, title: "Tooltip"
        demo Docs::Examples::Kbd::InInputGroup, title: "Input Group"
      end
    end
  end
end
