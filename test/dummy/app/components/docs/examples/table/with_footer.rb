# frozen_string_literal: true

module Docs
  module Examples
    module Table
      class WithFooter < Phlex::HTML
        ROWS = [
          [ "INV001", "Paid", "Credit Card", "$250.00" ],
          [ "INV002", "Pending", "PayPal", "$150.00" ],
          [ "INV003", "Unpaid", "Bank Transfer", "$350.00" ],
          [ "INV004", "Paid", "Credit Card", "$450.00" ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Table.new do
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new { "Invoice" }
                  render PhlexKit::TableHead.new { "Status" }
                  render PhlexKit::TableHead.new { "Method" }
                  render PhlexKit::TableHead.new(style: "text-align: right") { "Amount" }
                end
              end
              render PhlexKit::TableBody.new do
                ROWS.each do |invoice, status, method, amount|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new(style: "font-weight: 500") { invoice }
                    render PhlexKit::TableCell.new { status }
                    render PhlexKit::TableCell.new { method }
                    render PhlexKit::TableCell.new(style: "text-align: right") { amount }
                  end
                end
              end
              render PhlexKit::TableFooter.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableCell.new(colspan: 3) { "Total" }
                  render PhlexKit::TableCell.new(style: "text-align: right") { "$1,200.00" }
                end
              end
            end
          end
        end
      end
    end
  end
end
