# frozen_string_literal: true

module Docs
  module Pages
    class Dialog < Docs::BasePage
      self.description = "A modal dialog built on the native <dialog> element."
      def demos
        demo Docs::Examples::Dialog::EditProfile, title: "Edit profile"
      end
    end
  end
end
