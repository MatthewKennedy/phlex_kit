# frozen_string_literal: true

module Docs
  module Pages
    class Dialog < Docs::BasePage
      self.description = "A modal dialog built on the native <dialog> element."

      def demos
        demo Docs::Examples::Dialog::EditProfile, title: "Default"
        demo Docs::Examples::Dialog::CloseButton, title: "Custom Close Button"
        demo Docs::Examples::Dialog::NoCloseButton, title: "No Close Button"
        demo Docs::Examples::Dialog::StickyFooter, title: "Sticky Footer"
        demo Docs::Examples::Dialog::ScrollableContent, title: "Scrollable Content"
      end
    end
  end
end
