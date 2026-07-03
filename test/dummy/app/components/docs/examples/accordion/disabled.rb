# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class Disabled < Phlex::HTML
        def view_template
          div(class: "w-lg") do
            render PhlexKit::Accordion.new do
              render PhlexKit::AccordionItem.new(open: true) do
                render PhlexKit::AccordionDefaultTrigger.new { "Can I access my account history?" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Yes — the full history lives under Settings → Activity." }
                end
              end
              render PhlexKit::AccordionItem.new(disabled: true) do
                render PhlexKit::AccordionDefaultTrigger.new { "Premium feature information" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Available on the Professional plan." }
                end
              end
              render PhlexKit::AccordionItem.new do
                render PhlexKit::AccordionDefaultTrigger.new { "How do I update my email address?" }
                render PhlexKit::AccordionContent.new do
                  render PhlexKit::AccordionDefaultContent.new { "Under Settings → Account → Email." }
                end
              end
            end
          end
        end
      end
    end
  end
end
