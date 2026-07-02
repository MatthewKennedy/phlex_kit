module PhlexKit
  # Joined run of OTP slots. See input_otp.rb.
  class InputOtpGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-input-otp-group" }, @attrs), &)
  end
end
