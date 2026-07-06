module PhlexKit
  # Multi-select input inside a PhlexKit::ComboboxItem. A real checkbox (pass
  # `name:`/`value:`/`checked:`), so the selection submits with the form.
  # See combobox.rb.
  class ComboboxCheckbox < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :checkbox,
        # The option label is the interactive surface (ARIA option); the real
        # input must not be a second tab stop inside it.
        tabindex: "-1",
        class: "pk-combobox-checkbox",
        data: {
          phlex_kit__combobox_target: "input",
          action: "phlex-kit--combobox#inputChanged"
        }
      }, @attrs))
    end
  end
end
