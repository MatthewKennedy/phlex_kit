# frozen_string_literal: true

module Docs
  module Pages
    class Progress < Docs::BasePage
      self.description = "Displays an indicator showing the completion progress of a task."

      def demos
        demo Docs::Examples::Progress::Default, title: "Default"
        demo Docs::Examples::Progress::WithLabel, title: "Label"
        demo Docs::Examples::Progress::Indeterminate, title: "Indeterminate"
      end
    end
  end
end
