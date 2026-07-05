# frozen_string_literal: true

module Docs
  module Examples
    module Pagination
      class IconsOnly < Phlex::HTML
        def view_template
          div(style: "display: flex; align-items: center; justify-content: space-between; gap: 1rem; width: 100%; max-width: 28rem;") do
            div(class: "row") do
              render PhlexKit::Label.new(for: "select-rows-per-page") { "Rows per page" }
              render PhlexKit::Select.new do
                render PhlexKit::SelectTrigger.new(id: "select-rows-per-page", style: "width: 5rem") do
                  render PhlexKit::SelectValue.new { "25" }
                end
                render PhlexKit::SelectContent.new do
                  render PhlexKit::SelectGroup.new do
                    %w[10 25 50 100].each do |n|
                      render PhlexKit::SelectItem.new(value: n, selected: n == "25") { n }
                    end
                  end
                end
              end
            end
            render PhlexKit::Pagination.new(style: "margin: 0; width: auto;") do
              render PhlexKit::PaginationContent.new do
                render PhlexKit::PaginationPrevious.new(href: "#", label: "")
                render PhlexKit::PaginationNext.new(href: "#", label: "")
              end
            end
          end
        end
      end
    end
  end
end
