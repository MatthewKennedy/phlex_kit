# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class ChoiceCard < Phlex::HTML
        OPTIONS = [
          [ "kubernetes", "Kubernetes", "Run GPU workloads on a K8s cluster.", true ],
          [ "vm", "Virtual Machine", "Access a cluster to run GPU workloads.", false ]
        ].freeze

        def view_template
          # A FieldLabel wrapping a whole Field becomes a choice card — it
          # grows a border and highlights while its control is checked.
          render PhlexKit::FieldGroup.new(class: "w-sm") do
            render PhlexKit::FieldSet.new do
              render PhlexKit::FieldLegend.new(variant: :label) { "Compute Environment" }
              render PhlexKit::FieldDescription.new { "Select the compute environment for your cluster." }
              render PhlexKit::RadioGroup.new do
                OPTIONS.each do |value, title, description, checked|
                  render PhlexKit::FieldLabel.new(for: "fld-env-#{value}") do
                    render PhlexKit::Field.new(orientation: :horizontal) do
                      render PhlexKit::FieldContent.new do
                        render PhlexKit::FieldTitle.new { title }
                        render PhlexKit::FieldDescription.new { description }
                      end
                      render PhlexKit::RadioButton.new(id: "fld-env-#{value}", name: "fld-env", value: value, checked: checked)
                    end
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
