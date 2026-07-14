# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class InCard < Phlex::HTML
        def view_template
          render PhlexKit::Card.new(class: "w-lg") do
            render PhlexKit::CardHeader.new do
              render PhlexKit::CardTitle.new { "Subscription & Billing" }
              render PhlexKit::CardDescription.new { "Common questions about your account, plans, payments and cancellations." }
            end
            render PhlexKit::CardContent.new do
              render PhlexKit::Accordion.new do
                render PhlexKit::AccordionItem.new(open: true) do
                  render PhlexKit::AccordionDefaultTrigger.new { "What subscription plans do you offer?" }
                  render PhlexKit::AccordionContent.new(open: true) do
                    render PhlexKit::AccordionDefaultContent.new { "Starter ($9/month), Professional ($29/month), and Enterprise ($99/month)." }
                  end
                end
                render PhlexKit::AccordionItem.new do
                  render PhlexKit::AccordionDefaultTrigger.new { "How does billing work?" }
                  render PhlexKit::AccordionContent.new do
                    render PhlexKit::AccordionDefaultContent.new { "Charged at the start of each cycle; prorated upgrades." }
                  end
                end
                render PhlexKit::AccordionItem.new do
                  render PhlexKit::AccordionDefaultTrigger.new { "How do I cancel my subscription?" }
                  render PhlexKit::AccordionContent.new do
                    render PhlexKit::AccordionDefaultContent.new { "Settings → Billing → Cancel. Access continues to the end of the cycle." }
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
