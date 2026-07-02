# frozen_string_literal: true

module Docs
  module Pages
    class Combobox < Docs::BasePage
      self.description = "Autocomplete input and command palette with a list of suggestions."
      def demos
        demo Docs::Examples::Combobox::ButtonTrigger, title: "Multi-select with search"
        demo Docs::Examples::Combobox::InputTrigger, title: "Input trigger (autocomplete)"
        demo Docs::Examples::Combobox::BadgeTrigger, title: "Badge trigger (chips)"
      end
    end
  end
end
