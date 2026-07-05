# frozen_string_literal: true

module Docs
  module Examples
    module InputOtp
      class Alphanumeric < Phlex::HTML
        def view_template
          # inputmode: text lets letters through (digits-only is the default).
          render PhlexKit::InputOtp.new(length: 6, name: "code-alpha") do
            render PhlexKit::InputOtpGroup.new do
              6.times { render PhlexKit::InputOtpSlot.new(inputmode: "text") }
            end
          end
        end
      end
    end
  end
end
