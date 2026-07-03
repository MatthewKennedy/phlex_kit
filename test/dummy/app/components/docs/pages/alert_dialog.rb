# frozen_string_literal: true

module Docs
  module Pages
    class AlertDialog < Docs::BasePage
      self.description = "A modal dialog that interrupts the user with important content and expects a response."
      def demos
        demo Docs::Examples::AlertDialog::Default, title: "Basic"
        demo Docs::Examples::AlertDialog::Small, title: "Small"
        demo Docs::Examples::AlertDialog::Media, title: "Media"
        demo Docs::Examples::AlertDialog::SmallWithMedia, title: "Small with media"
        demo Docs::Examples::AlertDialog::Destructive, title: "Destructive"
      end
    end
  end
end
