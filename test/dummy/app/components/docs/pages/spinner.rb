# frozen_string_literal: true

module Docs
  module Pages
    class Spinner < Docs::BasePage
      self.description = "An indicator that content is loading."
      def demos
        demo Docs::Examples::Spinner::Default, title: "Sizes & composition"
      end
    end
  end
end
