module PhlexKit
  # A header cell (<th>) in a PhlexKit::TableHeader row. See table.rb.
  class TableHead < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      # scope="col" is the common case (header cells sit in a TableHeader row);
      # a generated default, not a merged attr — `mix` would fuse a caller's
      # `scope: "row"` into "col row" — so skip it when the caller sets scope.
      base = { class: "pk-table-head" }
      base[:scope] = "col" unless attr_set?(:scope)
      th(**mix(base, @attrs), &block)
    end
  end
end
