# frozen_string_literal: true

module Docs
  # Ordered map of docs pages: slug => { title:, page: }. Derived from the
  # files under docs/pages/ (filesystem, not loaded constants — Zeitwerk is
  # lazy in dev). Drives the sidebar menu and /docs/:id routing.
  class Registry
    def self.all
      @all ||= Dir.glob(Rails.root.join("app/components/docs/pages/*.rb")).sort.each_with_object({}) do |file, acc|
        page = "Docs::Pages::#{File.basename(file, ".rb").camelize}".constantize
        acc[page.slug] = { title: page.title, page: page }
      end
    end
  end
end
