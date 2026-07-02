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
      case current_direction
      when "asc"
        sort_svg(icon_class) { |s| s.polyline(points: "18 15 12 9 6 15") }
      when "desc"
        sort_svg(icon_class) { |s| s.polyline(points: "6 9 12 15 18 9") }
      else
        sort_svg(icon_class) do |s|
          s.polyline(points: "8 15 12 19 16 15")
          s.polyline(points: "8 9 12 5 16 9")
        end
      end
    end

    def sort_svg(icon_class, &)
      svg(
        xmlns: "http://www.w3.org/2000/svg",
        width: "12",
        height: "12",
        viewbox: "0 0 24 24",
        fill: "none",
        stroke: "currentColor",
        "stroke-width": "2",
        "stroke-linecap": "round",
        "stroke-linejoin": "round",
        class: icon_class,
        "aria-hidden": "true",
        &
      )
    end
  end
end
