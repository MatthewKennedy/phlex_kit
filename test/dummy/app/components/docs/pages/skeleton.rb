# frozen_string_literal: true

module Docs
  module Pages
    class Skeleton < Docs::BasePage
      self.description = "Use to show a placeholder while content is loading."
      def demos
        demo Docs::Examples::Skeleton::Default, title: "Default"
      end
    end
  end
end
