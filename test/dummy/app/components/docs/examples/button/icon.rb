# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Icon < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, icon: true, aria: { label: "Next" }) { "→" }
          render PhlexKit::Button.new(variant: :secondary, icon: true, size: :sm, aria: { label: "Settings" }) { "⚙" }
        end
      end
    end
  end
end
