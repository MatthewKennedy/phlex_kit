# frozen_string_literal: true

module Docs
  module Examples
    module Codeblock
      class Default < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Codeblock.new(<<~RUBY, syntax: :ruby)
              render PhlexKit::Button.new(variant: :primary) { "Approve" }
            RUBY
          end
        end
      end
    end
  end
end
