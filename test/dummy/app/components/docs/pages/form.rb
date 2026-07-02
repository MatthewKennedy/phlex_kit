# frozen_string_literal: true

module Docs
  module Pages
    class Form < Docs::BasePage
      self.description = "Form shell + FormField live validation — errors fill client-side and clear as you type."
      def demos
        demo Docs::Examples::Form::Profile, title: "Profile form"
      end
    end
  end
end
