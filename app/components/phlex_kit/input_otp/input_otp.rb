module PhlexKit
  # One-time-code input, ported from shadcn/ui's InputOTP (the input-otp npm
  # lib is replaced by the phlex-kit--input-otp controller: per-slot typing with
  # auto-advance, backspace retreat, paste distribution, arrow movement). The
  # hidden input carries the joined value under `name:`. Compose InputOtp >
  # InputOtpGroup(InputOtpSlot…) [+ InputOtpSeparator + more groups]; slot
  # count must total `length:`. `.pk-input-otp*` (input_otp.css).
  class InputOtp < BaseComponent
    def initialize(length: 6, name: nil, value: nil, **attrs)
      @length = length
      @name = name
      @value = value
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-input-otp",
        data: {
          controller: "phlex-kit--input-otp",
          phlex_kit__input_otp_length_value: @length
        }
      }, @attrs)) do
        input(type: :hidden, name: @name, value: @value, data: { phlex_kit__input_otp_target: "value" }) if @name
        yield if block
      end
    end
  end
end
