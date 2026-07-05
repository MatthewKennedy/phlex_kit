# frozen_string_literal: true

module Docs
  module Pages
    class Spinner < Docs::BasePage
      self.description = "An indicator that content is loading."

      def demos
        demo Docs::Examples::Spinner::Default, title: "Default"
        demo Docs::Examples::Spinner::Size, title: "Size"
        demo Docs::Examples::Spinner::InButton, title: "Button"
        demo Docs::Examples::Spinner::InBadge, title: "Badge"
      end
    end
  end
end
