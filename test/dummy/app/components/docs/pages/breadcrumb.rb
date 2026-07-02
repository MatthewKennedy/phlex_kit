# frozen_string_literal: true

module Docs
  module Pages
    class Breadcrumb < Docs::BasePage
      self.description = "Displays the path to the current resource using a hierarchy of links."
      def demos
        demo Docs::Examples::Breadcrumb::Default, title: "With ellipsis"
      end
    end
  end
end
