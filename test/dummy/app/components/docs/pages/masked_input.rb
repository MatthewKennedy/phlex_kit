# frozen_string_literal: true

module Docs
  module Pages
    class MaskedInput < Docs::BasePage
      self.description = "Text input with an inline mask (# digit, A letter, * any) — no maska dependency."
      def demos
        demo Docs::Examples::MaskedInput::Default, title: "Masks"
      end
    end
  end
end
