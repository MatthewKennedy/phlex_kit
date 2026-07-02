# frozen_string_literal: true

module Docs
  module Examples
    module Table
      class Invoices < Phlex::HTML
        INVOICES = [
          [ "INV001", "Paid", "Credit Card", "$250.00" ],
          [ "INV002", "Pending", "PayPal", "$150.00" ],
          [ "INV003", "Unpaid", "Bank Transfer", "$350.00" ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Table.new do
              render PhlexKit::TableCaption.new { "A list of your recent invoices." }
              render PhlexKit::TableHeader.new do
                render PhlexKit::TableRow.new do
                  render PhlexKit::TableHead.new { "Invoice" }
                  render PhlexKit::TableHead.new { "Status" }
                  render PhlexKit::TableHead.new { "Method" }
                  render PhlexKit::TableHead.new { "Amount" }
                end
              end
              render PhlexKit::TableBody.new do
                INVOICES.each do |invoice, status, method, amount|
                  render PhlexKit::TableRow.new do
                    render PhlexKit::TableCell.new { invoice }
                    render PhlexKit::TableCell.new { status }
                    render PhlexKit::TableCell.new { method }
                    render PhlexKit::TableCell.new { amount }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
