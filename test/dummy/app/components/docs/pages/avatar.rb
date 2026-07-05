# frozen_string_literal: true

module Docs
  module Pages
    class Avatar < Docs::BasePage
      self.description = "An image element with a fallback for representing the user."

      def demos
        demo Docs::Examples::Avatar::Basic, title: "Basic"
        demo Docs::Examples::Avatar::Badge, title: "Badge"
        demo Docs::Examples::Avatar::BadgeIcon, title: "Badge with Icon"
        demo Docs::Examples::Avatar::Group, title: "Avatar Group"
        demo Docs::Examples::Avatar::GroupCount, title: "Avatar Group Count"
        demo Docs::Examples::Avatar::GroupCountIcon, title: "Avatar Group with Icon"
        demo Docs::Examples::Avatar::Sizes, title: "Sizes"
        demo Docs::Examples::Avatar::Dropdown, title: "Dropdown"
      end
    end
  end
end
