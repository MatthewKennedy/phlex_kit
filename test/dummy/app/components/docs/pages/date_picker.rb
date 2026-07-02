# frozen_string_literal: true

module Docs
  module Pages
    class DatePicker < Docs::BasePage
      self.description = "A calendar in a popover bound to an input."
      def demos
        demo Docs::Examples::DatePicker::Default, title: "Default"
      end
    end
  end
end
