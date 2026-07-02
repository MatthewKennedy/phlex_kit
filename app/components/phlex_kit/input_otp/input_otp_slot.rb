module PhlexKit
  # One character cell of an InputOtp. See input_otp.rb.
  class InputOtpSlot < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :text,
        inputmode: "numeric",
        autocomplete: "one-time-code",
        maxlength: "1",
        class: "pk-input-otp-slot",
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
