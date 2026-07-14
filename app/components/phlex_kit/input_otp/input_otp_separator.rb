module PhlexKit
  # Divider between OTP groups. See input_otp.rb. Purely decorative — the dash
  # is aria-hidden (no separator role) so AT doesn't announce a stray "-"
  # between the digit fields.
  class InputOtpSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template = div(**mix({ class: "pk-input-otp-separator", aria_hidden: "true" }, @attrs)) { "-" }
  end
end
