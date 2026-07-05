# frozen_string_literal: true

module Docs
  module Pages
    class InputGroup < Docs::BasePage
      self.description = "An input with attached addons that focus as one control."

      def demos
        demo Docs::Examples::InputGroup::InlineStart, title: "inline-start"
        demo Docs::Examples::InputGroup::InlineEnd, title: "inline-end"
        demo Docs::Examples::InputGroup::BlockStart, title: "block-start"
        demo Docs::Examples::InputGroup::BlockEnd, title: "block-end"
        demo Docs::Examples::InputGroup::WithIcon, title: "Icon"
        demo Docs::Examples::InputGroup::WithText, title: "Text"
        demo Docs::Examples::InputGroup::WithButton, title: "Button"
        demo Docs::Examples::InputGroup::WithKbd, title: "Kbd"
        demo Docs::Examples::InputGroup::WithDropdown, title: "Dropdown"
        demo Docs::Examples::InputGroup::WithSpinner, title: "Spinner"
        demo Docs::Examples::InputGroup::WithTextarea, title: "Textarea"
      end
    end
  end
end
