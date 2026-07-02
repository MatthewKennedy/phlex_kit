module PhlexKit
  # Adapter exposing a Kaminari collection to PhlexKit::DataTablePagination (the
  # gem is the host's dependency, not ours). Ported from ruby_ui.
  class DataTableKaminariAdapter
    def initialize(collection)
      @collection = collection
    end

    def current_page = @collection.current_page

    def total_pages = @collection.total_pages

    def total_count = @collection.total_count

    def per_page = @collection.limit_value
  end
end
