module PhlexKit
  # "Columns" dropdown of checkboxes toggling cells that carry a matching
  # data-column attribute. `columns:` is an array of { key:, label: } hashes.
  # See data_table.rb.
  class DataTableColumnToggle < BaseComponent
    def initialize(columns:, **attrs)
      @columns = columns
      @attrs = attrs
    end

    def view_template
      div(**mix({
        class: "pk-data-table-column-toggle",
        data: { controller: "phlex-kit--data-table-column-visibility" }
      }, @attrs)) do
        render DropdownMenu.new do
          render DropdownMenuTrigger.new do
            render Button.new(variant: :outline, size: :sm) do
              plain "Columns"
              chevron_icon
            end
          end
          render DropdownMenuContent.new do
            @columns.each do |col|
              label(class: "pk-data-table-column-option") do
                input(
                  type: :checkbox,
                  checked: true,
                  class: "pk-checkbox",
                  data: {
                    column_key: col[:key].to_s,
                    action: "change->phlex-kit--data-table-column-visibility#toggle"
                  }
                )
                span { plain col[:label] }
              end
            end
          end
        end
      end
    end

    private

    def chevron_icon
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
        class: "pk-data-table-column-toggle-icon",
        "aria-hidden": "true"
      ) { |s| s.polyline(points: "6 9 12 15 18 9") }
    end
  end
end
