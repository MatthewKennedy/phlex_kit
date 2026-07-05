# frozen_string_literal: true

module Docs
  module Pages
    class DatePicker < Docs::BasePage
      self.title = "Date Picker"
      self.description = "A calendar in a popover bound to an input."

      def demos
        demo Docs::Examples::DatePicker::Default, title: "Basic"
        demo Docs::Examples::DatePicker::RangePicker, title: "Range Picker"
        demo Docs::Examples::DatePicker::DateOfBirth, title: "Date of Birth"
        demo Docs::Examples::DatePicker::WithTime, title: "Time Picker"
      end
    end
  end
end
