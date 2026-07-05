# frozen_string_literal: true

module Docs
  module Pages
    class Table < Docs::BasePage
      self.description = "A responsive table component."

      def demos
        demo Docs::Examples::Table::Invoices, title: "Default"
        demo Docs::Examples::Table::WithFooter, title: "Footer"
        demo Docs::Examples::Table::WithActions, title: "Actions"
      end
    end
  end
end
