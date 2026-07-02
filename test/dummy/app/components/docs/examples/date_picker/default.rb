# frozen_string_literal: true

module Docs
  module Examples
    module DatePicker
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::DatePicker.new(id: "docs-date", name: "date", label: "Date of birth")
        end
      end
    end
  end
end
