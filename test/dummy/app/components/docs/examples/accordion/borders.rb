# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class Borders < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Accordion.new(class: "bordered") do
              render PhlexKit::AccordionItem.new(open: true) do
                render PhlexKit::AccordionDefaultTrigger.new { "How does billing work?" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Monthly and annual plans, charged at the start of each cycle. Cancel anytime." }
                end
              end
              render PhlexKit::AccordionItem.new do
                render PhlexKit::AccordionDefaultTrigger.new { "Is my data secure?" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Encrypted at rest and in transit, with automatic backups." }
                end
              end
              render PhlexKit::AccordionItem.new do
                render PhlexKit::AccordionDefaultTrigger.new { "What integrations do you support?" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Slack, GitHub, Linear and a REST API." }
                end
              end
            end
          end
        end
      end
    end
  end
end
