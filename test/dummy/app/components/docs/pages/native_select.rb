# frozen_string_literal: true

module Docs
  module Pages
    class NativeSelect < Docs::BasePage
      self.description = "A styled native <select> — mobile-friendly, with grouped options."
      def demos
        demo Docs::Examples::NativeSelect::Default, title: "Default"
      end
    end
  end
end
