module PhlexKit
  # Windowed page navigation built on the kit's Pagination parts. Feed it a
  # paginated collection via one of the adapters — `pagy:`, `kaminari:`, plain
  # `page:`/`per_page:`/`total_count:`, or any `with:` object responding to
  # current_page/total_pages. Renders nothing for a single page.
  # See data_table.rb.
  class DataTablePagination < BaseComponent
    def initialize(with: nil, pagy: nil, kaminari: nil, page: nil, per_page: nil, total_count: nil, page_param: "page", path: "", query: {}, window: 1, prev_label: "<", next_label: ">", **attrs)
      @adapter = resolve_adapter(with:, pagy:, kaminari:, page:, per_page:, total_count:)
      @page_param = page_param
      @path = path
      @query = query.to_h.transform_keys(&:to_s)
      @window = window
      @prev_label = prev_label
      @next_label = next_label
      @attrs = attrs
    end

    def view_template
      return if total <= 1

      render Pagination.new(**mix({ class: "pk-data-table-pagination" }, @attrs)) do
        render PaginationContent.new do
          prev_item
          number_items
          next_item
        end
      end
    end

    private

    def resolve_adapter(with:, pagy:, kaminari:, page:, per_page:, total_count:)
      return with if with
      return DataTablePagyAdapter.new(pagy) if pagy
      return DataTableKaminariAdapter.new(kaminari) if kaminari
      if page && per_page && total_count
        return DataTableManualAdapter.new(page:, per_page:, total_count:)
      end
      raise ArgumentError, "DataTablePagination requires one of: with:, pagy:, kaminari:, or page:+per_page:+total_count:"
    end

    def current = @adapter.current_page

    def total = @adapter.total_pages

    def page_href(p)
      qs = build_query(@query.merge(@page_param => p.to_s))
      qs.empty? ? @path : "#{@path}?#{qs}"
    end

    def build_query(hash)
      hash.flat_map { |k, v|
        Array(v).map { |val| "#{CGI.escape(k.to_s)}=#{CGI.escape(val.to_s)}" }
      }.join("&")
    end

    def prev_item
      edge_item(disabled: current <= 1, href: page_href(current - 1),
        label: @prev_label, name: "Go to previous page")
    end

    def next_item
      edge_item(disabled: current >= total, href: page_href(current + 1),
        label: @next_label, name: "Go to next page")
    end

    # The default labels are bare glyphs ("<"/">") — give AT a real name, and
    # announce the disabled edge instead of rendering an anonymous span.
    def edge_item(disabled:, href:, label:, name:)
      if disabled
        li do
          span(class: "pk-data-table-page-disabled", aria: { disabled: "true", label: name }) { label }
        end
      else
        render PaginationItem.new(href: href, aria: { label: name }) { label }
      end
    end

    def number_items
      windowed_pages.each do |p|
        if p == :gap
          render PaginationEllipsis.new
        else
          render PaginationItem.new(href: page_href(p), active: p == current) { plain p.to_s }
        end
      end
    end

    def windowed_pages
      return (1..total).to_a if total <= 7
      pages = [ 1 ]
      pages << :gap if current - @window > 2
      ((current - @window)..(current + @window)).each { |p| pages << p if p > 1 && p < total }
      pages << :gap if current + @window < total - 1
      pages << total
      pages
    end
  end
end
