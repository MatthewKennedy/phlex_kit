# frozen_string_literal: true

module Docs
  module Pages
    class InputOtp < Docs::BasePage
      self.title = "Input OTP"
      self.description = "Accessible one-time password input — auto-advance, backspace, paste distribution."

      def demos
        demo Docs::Examples::InputOtp::Default, title: "Default"
        demo Docs::Examples::InputOtp::Separator, title: "Separator"
        demo Docs::Examples::InputOtp::Disabled, title: "Disabled"
        demo Docs::Examples::InputOtp::Invalid, title: "Invalid"
        demo Docs::Examples::InputOtp::FourDigits, title: "Four Digits"
        demo Docs::Examples::InputOtp::Alphanumeric, title: "Alphanumeric"
      end
    end
  end
end
