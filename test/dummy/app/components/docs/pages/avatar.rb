# frozen_string_literal: true

module Docs
  module Pages
    class Avatar < Docs::BasePage
      self.description = "An image element with a fallback for representing the user."

      def demos
        demo Docs::Examples::Avatar::Default, title: "Default"
        demo Docs::Examples::Avatar::Group, title: "Group"
      end
    end
  end
end
