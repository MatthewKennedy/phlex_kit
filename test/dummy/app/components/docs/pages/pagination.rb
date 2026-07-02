# frozen_string_literal: true

module Docs
  module Pages
    class Pagination < Docs::BasePage
      self.description = "Pagination with page navigation, next and previous links."
      def demos
        demo Docs::Examples::Pagination::Default, title: "Default"
      end
    end
  end
end
