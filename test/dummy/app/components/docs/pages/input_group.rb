# frozen_string_literal: true

module Docs
  module Pages
    class InputGroup < Docs::BasePage
      self.description = "An input with attached addons that focus as one control."
      def demos
        demo Docs::Examples::InputGroup::Default, title: "Prefix and suffix"
      end
    end
  end
end
