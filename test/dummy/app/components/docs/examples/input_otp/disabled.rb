# frozen_string_literal: true

module Docs
  module Examples
    module InputOtp
      class Disabled < Phlex::HTML
        def view_template
          render PhlexKit::InputOtp.new(length: 6, name: "code-disabled") do
            render PhlexKit::InputOtpGroup.new do
              6.times { render PhlexKit::InputOtpSlot.new(disabled: true) }
            end
          end
        end
      end
    end
  end
end
