module PhlexKit
  # Sortable <th>: a link cycling asc → desc → unsorted, preserving the rest of
  # the query string (page resets). See data_table.rb.
  class DataTableSortHead < BaseComponent
    def initialize(column_key:, label:, sort: nil, direction: nil, sort_param: "sort", direction_param: "direction", page_param: "page", path: "", query: {}, **attrs)
      @column_key = column_key
      @label = label
      @sort = sort
      @direction = direction
      @sort_param = sort_param
      @direction_param = direction_param
      @page_param = page_param
      @path = path
      @query = query.to_h.transform_keys(&:to_s)
      @attrs = attrs
    end

    def view_template
      render TableHead.new(**mix({ class: "pk-data-table-sort-head" }, @attrs)) do
        a(href: sort_href, class: "pk-data-table-sort-link") do
          plain @label
          sort_icon
        end
      end
    end

    private

    def current_direction
      (@sort.to_s == @column_key.to_s) ? @direction : nil
    end

    def next_params
      next_dir = { nil => "asc", "asc" => "desc", "desc" => nil }[current_direction]
      base = @query.except(@sort_param, @direction_param, @page_param)
      next_dir ? base.merge(@sort_param => @column_key.to_s, @direction_param => next_dir) : base
    end

    def sort_href
      qs = build_query(next_params)
      qs.empty? ? @path : "#{@path}?#{qs}"
    end

    def build_query(hash)
      hash.flat_map { |k, v|
        Array(v).map { |val| "#{CGI.escape(k.to_s)}=#{CGI.escape(val.to_s)}" }
      }.join("&")
    end

    def sort_icon
      icon_class = [ "pk-data-table-sort-icon", (current_direction ? nil : "unsorted") ].compact.join(" ")
      glyph = { "asc" => :chevron_up, "desc" => :chevron_down }.fetch(current_direction, :chevrons_up_down)
      render Icon.new(glyph, size: 12, class: icon_class)
    end
  end
end
