# frozen_string_literal: true

module Docs
  module Pages
    class Bubble < Docs::BasePage
      self.description = "Chat bubble for messages, reactions, and interactive content."

      def demos
        demo Docs::Examples::Bubble::Variants, title: "Variants"
        demo Docs::Examples::Bubble::Alignment, title: "Alignment"
        demo Docs::Examples::Bubble::Group, title: "Bubble Group"
        demo Docs::Examples::Bubble::LinksAndButtons, title: "Links and Buttons"
        demo Docs::Examples::Bubble::Reactions, title: "Reactions"
        demo Docs::Examples::Bubble::ShowMore, title: "Show More / Collapsible"
        demo Docs::Examples::Bubble::Tooltip, title: "Tooltip"
        demo Docs::Examples::Bubble::Popover, title: "Popover"
      end
    end
  end
end
