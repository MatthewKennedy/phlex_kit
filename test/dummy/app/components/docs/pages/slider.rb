# frozen_string_literal: true

module Docs
  module Pages
    class Slider < Docs::BasePage
      self.description = "An input where the user selects a value from within a given range."
      def demos
        demo Docs::Examples::Slider::Default, title: "Default"
      end
    end
  end
end
