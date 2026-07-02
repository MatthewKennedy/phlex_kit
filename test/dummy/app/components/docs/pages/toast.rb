# frozen_string_literal: true

module Docs
  module Pages
    class Toast < Docs::BasePage
      self.description = "Sonner-style stacked notifications: server flash or window.PhlexKit.toast."
      def demos
        demo Docs::Examples::Toast::Default, title: "Spawning toasts"
      end
    end
  end
end
