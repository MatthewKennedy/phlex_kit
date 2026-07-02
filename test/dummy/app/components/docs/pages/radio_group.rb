# frozen_string_literal: true

module Docs
  module Pages
    class RadioGroup < Docs::BasePage
      self.description = "A set of checkable buttons where no more than one can be checked."
      def demos
        demo Docs::Examples::RadioGroup::Default, title: "Default"
      end
    end
  end
end
