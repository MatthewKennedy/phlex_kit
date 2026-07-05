# frozen_string_literal: true

module Docs
  module Examples
    module Pagination
      class Simple < Phlex::HTML
        def view_template
          render PhlexKit::Pagination.new do
            render PhlexKit::PaginationContent.new do
              render PhlexKit::PaginationLink.new(href: "#") { "1" }
              render PhlexKit::PaginationLink.new(href: "#", active: true) { "2" }
              render PhlexKit::PaginationLink.new(href: "#") { "3" }
              render PhlexKit::PaginationLink.new(href: "#") { "4" }
              render PhlexKit::PaginationLink.new(href: "#") { "5" }
            end
          end
        end
      end
    end
  end
end
