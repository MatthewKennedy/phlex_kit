# frozen_string_literal: true

module Docs
  module Examples
    module InputOtp
      class FourDigits < Phlex::HTML
        def view_template
          render PhlexKit::InputOtp.new(length: 4, name: "code-four") do
            render PhlexKit::InputOtpGroup.new do
              4.times { render PhlexKit::InputOtpSlot.new }
            end
          end
        end
      end
    end
  end
end
