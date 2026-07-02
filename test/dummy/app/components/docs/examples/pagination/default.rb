# frozen_string_literal: true

module Docs
  module Examples
    module Pagination
      class Default < Phlex::HTML
        def view_template
          render PhlexKit::Pagination.new do
            render PhlexKit::PaginationContent.new do
              render PhlexKit::PaginationItem.new(href: "#") { "‹ Previous" }
              render PhlexKit::PaginationItem.new(href: "#") { "1" }
              render PhlexKit::PaginationItem.new(href: "#", active: true) { "2" }
              render PhlexKit::PaginationItem.new(href: "#") { "3" }
              render PhlexKit::PaginationEllipsis.new
              render PhlexKit::PaginationItem.new(href: "#") { "Next ›" }
            end
          end
        end
      end
    end
  end
end
