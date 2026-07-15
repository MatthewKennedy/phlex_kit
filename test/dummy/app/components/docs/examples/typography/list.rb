# frozen_string_literal: true

module Docs
  module Examples
    module Typography
      class List < Phlex::HTML
        def view_template
          render PhlexKit::List.new(class: "w-md") do
            li { "1st level of puns: 5 gold coins" }
            li { "2nd level of jokes: 10 gold coins" }
            li { "3rd level of one-liners: 20 gold coins" }
          end
        end
      end
    end
  end
end
