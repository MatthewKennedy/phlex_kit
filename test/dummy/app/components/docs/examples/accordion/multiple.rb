# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class Multiple < Phlex::HTML
        # type :multiple lets several items stay open at once.
        SECTIONS = [
          [ "Notification Settings", "Manage how you receive notifications — email alerts, push, and digests.", true ],
          [ "Privacy & Security", "Two-factor authentication, sessions, and connected devices.", false ],
          [ "Billing & Subscription", "Invoices, payment methods, and plan changes.", false ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Accordion.new(type: :multiple) do
              SECTIONS.each do |title, body, open|
                render PhlexKit::AccordionItem.new(open: open) do
                  render PhlexKit::AccordionDefaultTrigger.new { title }
                  render PhlexKit::AccordionContent.new(open: open) do
                    render PhlexKit::AccordionDefaultContent.new { body }
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
