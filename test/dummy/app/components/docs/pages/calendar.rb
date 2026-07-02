# frozen_string_literal: true

module Docs
  module Pages
    class Calendar < Docs::BasePage
      self.description = "A date field component that allows users to select dates."
      def demos
        demo Docs::Examples::Calendar::Default, title: "Default"
        demo Docs::Examples::Calendar::MinDate, title: "Disabled past dates"
      end
    end
  end
end
