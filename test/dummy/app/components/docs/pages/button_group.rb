# frozen_string_literal: true

module Docs
  module Pages
    class ButtonGroup < Docs::BasePage
      self.description = "Joins related buttons into one segmented control."

      def demos
        demo Docs::Examples::ButtonGroup::Orientation, title: "Orientation"
        demo Docs::Examples::ButtonGroup::Size, title: "Size"
        demo Docs::Examples::ButtonGroup::Nested, title: "Nested"
        demo Docs::Examples::ButtonGroup::Separator, title: "Separator"
        demo Docs::Examples::ButtonGroup::Split, title: "Split"
        demo Docs::Examples::ButtonGroup::WithInput, title: "Input"
        demo Docs::Examples::ButtonGroup::Dropdown, title: "Dropdown Menu"
        demo Docs::Examples::ButtonGroup::WithSelect, title: "Select"
        demo Docs::Examples::ButtonGroup::WithPopover, title: "Popover"
      end
    end
  end
end
