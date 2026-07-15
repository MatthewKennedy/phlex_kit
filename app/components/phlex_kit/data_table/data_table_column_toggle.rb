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
              # A real menu row (role="menuitemcheckbox" + aria-checked, arrow-
              # navigable) — plain <label>s directly inside role="menu" are
              # invalid ARIA. The change event bubbles from the hidden checkbox
              # to this row, where our toggle action picks it up.
              render DropdownMenuCheckboxItem.new(
                # visible: false starts the menu row unchecked for a column
                # the host server-renders hidden (pk-hidden on its cells) —
                # checked: true hardcoded meant the two could never agree.
                checked: col.fetch(:visible, true),
                data: {
                  column_key: col[:key].to_s,
                  action: "change->phlex-kit--data-table-column-visibility#toggle"
                }
              ) { plain col[:label] }
            end
          end
        end
      end
    end

    private

    def chevron_icon
      render Icon.new(:chevron_down, class: "pk-data-table-column-toggle-icon")
    end
  end
end
