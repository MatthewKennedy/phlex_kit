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
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        width: "16",
        height: "16",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        "aria-hidden": "true"
      ) { |s| s.polyline(points: "9 18 15 12 9 6") }
    end
  end
end
