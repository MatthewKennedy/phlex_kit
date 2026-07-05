# frozen_string_literal: true

module Docs
  module Pages
    class Calendar < Docs::BasePage
      self.description = "A date field component that allows users to select dates."

      def demos
        demo Docs::Examples::Calendar::Basic, title: "Basic"
        demo Docs::Examples::Calendar::Range, title: "Range Calendar"
        demo Docs::Examples::Calendar::Multiple, title: "Multiple"
        demo Docs::Examples::Calendar::MonthYearSelector, title: "Month and Year Selector"
        demo Docs::Examples::Calendar::BookedDates, title: "Booked dates"
        demo Docs::Examples::Calendar::WeekNumbers, title: "Week Numbers"
        demo Docs::Examples::Calendar::CustomCellSize, title: "Custom Cell Size"
        demo Docs::Examples::Calendar::DateAndTime, title: "Date and Time Picker"
        demo Docs::Examples::Calendar::MinDate, title: "Disabled past dates"
      end
    end
  end
end
