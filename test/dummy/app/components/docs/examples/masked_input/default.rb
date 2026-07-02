# frozen_string_literal: true

module Docs
  module Examples
    module MaskedInput
      class Default < Phlex::HTML
        def view_template
          div(class: "stack w-sm") do
            render PhlexKit::MaskedInput.new(placeholder: "Card: #### #### #### ####", data: { mask: "#### #### #### ####" })
            render PhlexKit::MaskedInput.new(placeholder: "Date: ##/##/####", data: { mask: "##/##/####" })
            render PhlexKit::MaskedInput.new(placeholder: "Postcode: AA# #AA", data: { mask: "AA# #AA" })
          end
        end
      end
    end
  end
end
