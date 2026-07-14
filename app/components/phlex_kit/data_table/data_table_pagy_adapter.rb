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

    # Pagy 9 renamed #items to #limit (and removed #items) — support both.
    def per_page = @pagy.respond_to?(:limit) ? @pagy.limit : @pagy.items
  end
end
