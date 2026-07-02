# frozen_string_literal: true

module Docs
  module Examples
    module Accordion
      class Default < Phlex::HTML
        FAQS = [
          [ "Is it accessible?", "Yes. It keeps the upstream ARIA structure.", true ],
          [ "Is it styled?", "Yes. Vanilla CSS on the --pk-* tokens — no Tailwind.", false ],
          [ "Is it animated?", "Yes. Native Web Animations API — no motion dependency.", false ]
        ].freeze

        def view_template
          div(class: "w-lg") do
            render PhlexKit::Accordion.new do
              FAQS.each do |question, answer, open|
                render PhlexKit::AccordionItem.new(open: open) do
                  render PhlexKit::AccordionDefaultTrigger.new { question }
                  render PhlexKit::AccordionContent.new do
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
