module PhlexKit
  # One character cell of an InputOtp. See input_otp.rb.
  class InputOtpSlot < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      base = { type: :text, class: "pk-input-otp-slot" }
      # Defaults only when the caller didn't supply their own — `mix` fuses
      # (e.g. inputmode: "text" for alphanumeric codes).
      base[:inputmode] = "numeric" unless attr_set?(:inputmode)
      base[:autocomplete] = "one-time-code" unless attr_set?(:autocomplete)
      base[:maxlength] = "1" unless attr_set?(:maxlength)
      input(**mix(base, {
        data: {
          phlex_kit__input_otp_target: "slot",
          action: [
            "input->phlex-kit--input-otp#onInput",
            "keydown->phlex-kit--input-otp#onKeydown",
            "paste->phlex-kit--input-otp#onPaste",
            "focus->phlex-kit--input-otp#onFocus"
          ].join(" ")
        }
      }, @attrs))
    end
  end
end
