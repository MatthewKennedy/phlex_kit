# frozen_string_literal: true

module Docs
  module Examples
    module Button
      class Link < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :link) { "Link" }
        end
      end
    end
  end
end
