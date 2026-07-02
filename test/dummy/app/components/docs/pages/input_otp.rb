# frozen_string_literal: true

module Docs
  module Pages
    class InputOtp < Docs::BasePage
      self.title = "Input OTP"
      self.description = "Accessible one-time password input — auto-advance, backspace, paste distribution."
      def demos
        demo Docs::Examples::InputOtp::Default, title: "Default"
      end
    end
  end
end
