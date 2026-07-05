# frozen_string_literal: true

module Docs
  module Pages
    class RadioGroup < Docs::BasePage
      self.description = "A set of checkable buttons where only one can be checked at a time."

      def demos
        demo Docs::Examples::RadioGroup::Default, title: "Default"
        demo Docs::Examples::RadioGroup::Description, title: "Description"
        demo Docs::Examples::RadioGroup::ChoiceCard, title: "Choice Card"
        demo Docs::Examples::RadioGroup::Fieldset, title: "Fieldset"
        demo Docs::Examples::RadioGroup::Disabled, title: "Disabled"
        demo Docs::Examples::RadioGroup::Invalid, title: "Invalid"
      end
    end
  end
end
