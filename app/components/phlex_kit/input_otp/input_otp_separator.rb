module PhlexKit
  # Divider between OTP groups. See input_otp.rb.
  class InputOtpSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template = div(**mix({ class: "pk-input-otp-separator", role: "separator" }, @attrs)) { "-" }
  end
end
