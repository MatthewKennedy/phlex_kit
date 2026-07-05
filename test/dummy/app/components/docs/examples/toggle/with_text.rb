# frozen_string_literal: true

module Docs
  module Examples
    module Toggle
      class WithText < Phlex::HTML
        def view_template
          render PhlexKit::Toggle.new(aria: { label: "Toggle bookmark" }) do
            render PhlexKit::Icon.new(:bookmark, size: nil)
            plain "Bookmark"
          end
        end
      end
    end
  end
end
