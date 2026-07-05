# frozen_string_literal: true

module Docs
  module Pages
    class Field < Docs::BasePage
      self.description = "Combine labels, controls, and help text to compose accessible form fields."

      def demos
        demo Docs::Examples::Field::WithInput, title: "Input"
        demo Docs::Examples::Field::WithTextarea, title: "Textarea"
        demo Docs::Examples::Field::WithSelect, title: "Select"
        demo Docs::Examples::Field::WithSlider, title: "Slider"
        demo Docs::Examples::Field::Fieldset, title: "Fieldset"
        demo Docs::Examples::Field::WithCheckbox, title: "Checkbox"
        demo Docs::Examples::Field::WithRadio, title: "Radio"
        demo Docs::Examples::Field::WithSwitch, title: "Switch"
        demo Docs::Examples::Field::ChoiceCard, title: "Choice Card"
        demo Docs::Examples::Field::Group, title: "Field Group"
        demo Docs::Examples::Field::Responsive, title: "Responsive"
        demo Docs::Examples::Field::SeparatorDemo, title: "Separator"
        demo Docs::Examples::Field::WithError, title: "Validation and Errors"
      end
    end
  end
end
