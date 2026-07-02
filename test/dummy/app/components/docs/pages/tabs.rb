# frozen_string_literal: true

module Docs
  module Pages
    class Tabs < Docs::BasePage
      self.description = "A set of layered sections of content displayed one at a time."
      def demos
        demo Docs::Examples::Tabs::Default, title: "Default"
      end
    end
  end
end
