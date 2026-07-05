# frozen_string_literal: true

module Docs
  module Examples
    module Field
      class WithSelect < Phlex::HTML
        DEPARTMENTS = %w[Engineering Design Marketing Sales Support Finance Operations].freeze

        def view_template
          render PhlexKit::Field.new(class: "w-sm") do
            render PhlexKit::FieldLabel.new { "Department" }
            render PhlexKit::Select.new do
              render PhlexKit::SelectInput.new(name: "fld-department")
              render PhlexKit::SelectTrigger.new do
                render PhlexKit::SelectValue.new(placeholder: "Choose department")
              end
              render PhlexKit::SelectContent.new do
                render PhlexKit::SelectGroup.new do
                  DEPARTMENTS.each do |dept|
                    render PhlexKit::SelectItem.new(value: dept.downcase) { dept }
                  end
                end
              end
            end
            render PhlexKit::FieldDescription.new { "Select your department or area of work." }
          end
        end
      end
    end
  end
end
