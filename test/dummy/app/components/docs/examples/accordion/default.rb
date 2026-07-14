# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class Default < Phlex::HTML
        # type :single (the default): opening one item closes the others.
        FAQS = [
          [ "How do I reset my password?", "Click on 'Forgot Password' on the login page, enter your email address, and we'll send you a link. The link expires in 24 hours.", true ],
          [ "Can I change my subscription plan?", "Yes — upgrades apply immediately, downgrades at the end of the billing cycle.", false ],
          [ "What payment methods do you accept?", "All major credit cards, PayPal, and bank transfers on annual plans.", false ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Accordion.new do
              FAQS.each do |question, answer, open|
                render PhlexKit::AccordionItem.new(open: open) do
                  render PhlexKit::AccordionDefaultTrigger.new { question }
                  render PhlexKit::AccordionContent.new(open: open) do
                    render PhlexKit::AccordionDefaultContent.new { answer }
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
