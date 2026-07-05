# frozen_string_literal: true

module Docs
  module Examples
    module NativeSelect
      class Groups < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::NativeSelect.new(name: "ns-groups", aria: { label: "Select a timezone" }) do
              render PhlexKit::NativeSelectGroup.new(label: "North America") do
                render PhlexKit::NativeSelectOption.new(value: "est") { "Eastern Standard Time (EST)" }
                render PhlexKit::NativeSelectOption.new(value: "pst") { "Pacific Standard Time (PST)" }
              end
              render PhlexKit::NativeSelectGroup.new(label: "Europe & Africa") do
                render PhlexKit::NativeSelectOption.new(value: "gmt") { "Greenwich Mean Time (GMT)" }
                render PhlexKit::NativeSelectOption.new(value: "cet") { "Central European Time (CET)" }
              end
            end
          end
        end
      end
    end
  end
end
