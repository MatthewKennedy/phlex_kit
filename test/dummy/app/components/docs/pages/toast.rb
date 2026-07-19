# frozen_string_literal: true

module Docs
  module Pages
    class Toast < Docs::BasePage
      self.description = "An opinionated toast stack — sonner's API on Stimulus."

      def demos
        demo Docs::Examples::Toast::Default, title: "Default"
        demo Docs::Examples::Toast::Types, title: "Types"
        demo Docs::Examples::Toast::Description, title: "Description"
        demo Docs::Examples::Toast::Position, title: "Position"
        demo Docs::Examples::Toast::CloseButton, title: "Close Button"
      end
    end
  end
end
