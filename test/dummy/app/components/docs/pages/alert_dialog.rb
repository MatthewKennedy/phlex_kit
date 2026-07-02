# frozen_string_literal: true

module Docs
  module Pages
    class AlertDialog < Docs::BasePage
      self.description = "A modal dialog that interrupts the user with important content and expects a response."
      def demos
        demo Docs::Examples::AlertDialog::Default, title: "Default"
      end
    end
  end
end
