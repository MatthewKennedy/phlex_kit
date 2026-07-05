# frozen_string_literal: true

module Docs
  module Examples
    module InputOtp
      class Invalid < Phlex::HTML
        def view_template
          render PhlexKit::InputOtp.new(length: 6, name: "code-invalid") do
            render PhlexKit::InputOtpGroup.new do
              6.times { render PhlexKit::InputOtpSlot.new(aria: { invalid: "true" }) }
            end
          end
        end
      end
    end
  end
end
