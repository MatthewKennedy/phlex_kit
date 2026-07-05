# frozen_string_literal: true

module Docs
  module Pages
    class Breadcrumb < Docs::BasePage
      self.description = "Displays the path to the current resource using a hierarchy of links."

      def demos
        demo Docs::Examples::Breadcrumb::Basic, title: "Basic"
        demo Docs::Examples::Breadcrumb::CustomSeparator, title: "Custom separator"
        demo Docs::Examples::Breadcrumb::Dropdown, title: "Dropdown"
        demo Docs::Examples::Breadcrumb::Collapsed, title: "Collapsed"
      end
    end
  end
end
