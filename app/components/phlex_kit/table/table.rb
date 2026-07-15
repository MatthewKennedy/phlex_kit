module PhlexKit
  # Data table, ported from ruby_ui's RubyUI::Table. Presentational, no JS.
  # Multi-part, like PhlexKit::Card — the lead Table wraps a <table> in an overflow
  # container; the rest map 1:1 onto the table elements:
  #
  #   render PhlexKit::Table.new do
  #     render PhlexKit::TableHeader.new do
  #       render PhlexKit::TableRow.new do
  #         render PhlexKit::TableHead.new { "Name" }
  #         render PhlexKit::TableHead.new { "Email" }
  #       end
  #     end
  #     render PhlexKit::TableBody.new do
  #       @users.each do |u|
  #         render PhlexKit::TableRow.new do
  #           render PhlexKit::TableCell.new { u.name }
  #           render PhlexKit::TableCell.new { u.email }
  #         end
  #       end
  #     end
  #   end
  #
  # Tailwind → vanilla `.pk-table-*` (table.css), palette from the global tokens.
  class Table < BaseComponent
    def initialize(wrapper: {}, **attrs)
      @wrapper = wrapper
      @attrs = attrs
    end

    def view_template(&block)
      # Caller attrs land on the <table>; wrapper: reaches the scroll
      # container (e.g. to cap its height) — same escape hatch as Switch.
      div(**mix({ class: "pk-table-wrapper" }, @wrapper)) do
        table(**mix({ class: "pk-table" }, @attrs), &block)
      end
    end
  end
end
