# frozen_string_literal: true

module Docs
  module Pages
    class Table < Docs::BasePage
      self.description = "A responsive table component."
      def demos
        demo Docs::Examples::Table::Invoices, title: "Invoices"
      end
    end
  end
end
