# frozen_string_literal: true

module Docs
  module Pages
    class DataTable < Docs::BasePage
      self.description = "Server-driven table with selection, sorting, filtering, column visibility and pagination."
      def demos
        demo Docs::Examples::DataTable::Full, title: "Full example"
      end
    end
  end
end
