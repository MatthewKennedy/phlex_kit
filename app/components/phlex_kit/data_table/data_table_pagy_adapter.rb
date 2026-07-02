module PhlexKit
  # Adapter exposing a Pagy object to PhlexKit::DataTablePagination (the gem is
  # the host's dependency, not ours). Ported from ruby_ui.
  class DataTablePagyAdapter
    def initialize(pagy)
      @pagy = pagy
    end

    def current_page = @pagy.page

    def total_pages = @pagy.pages

    def total_count = @pagy.count

    def per_page = @pagy.items
  end
end
