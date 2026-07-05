# frozen_string_literal: true

module Docs
  module Pages
    class DataTable < Docs::BasePage
      self.title = "Data Table"
      self.description = "Server-driven table with selection, sorting, filtering, column visibility and pagination — the shadcn tanstack tutorial's end state on kit parts."

      def demos
        demo Docs::Examples::DataTable::Full, title: "Payments"
      end
    end
  end
end
