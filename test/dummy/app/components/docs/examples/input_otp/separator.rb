# frozen_string_literal: true

module Docs
  module Examples
    module InputOtp
      class Separator < Phlex::HTML
        def view_template
          render PhlexKit::InputOtp.new(length: 6, name: "code-sep") do
            render PhlexKit::InputOtpGroup.new do
              3.times { render PhlexKit::InputOtpSlot.new }
            end
            render PhlexKit::InputOtpSeparator.new
            render PhlexKit::InputOtpGroup.new do
              3.times { render PhlexKit::InputOtpSlot.new }
            end
          end
        end
      end
    end
  end
end
