module PhlexKit
  # Chevron button toggling a row-detail element (pass its id as `controls:`);
  # the chevron rotates via [aria-expanded] CSS. See data_table.rb.
  class DataTableExpandToggle < BaseComponent
    def initialize(controls:, expanded: false, label: "Toggle row details", **attrs)
      @controls = controls
      @expanded = expanded
      @label = label
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-data-table-expand-toggle",
        aria: { expanded: @expanded.to_s, controls: @controls, label: @label },
        data: { action: "click->phlex-kit--data-table#toggleRowDetail" }
      }, @attrs)) do
        icon
      end
    end

    private

    def icon
      render Icon.new(:chevron_right)
    end
  end
end
