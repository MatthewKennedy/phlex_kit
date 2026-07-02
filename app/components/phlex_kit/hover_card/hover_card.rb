module PhlexKit
  # Hover/focus-triggered floating card, positioned with CSS. Ported from ruby_ui's
  # RubyUI::HoverCard. Compose HoverCard > (HoverCardTrigger + HoverCardContent).
  class HoverCard < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&)
      div(**mix({ class: "pk-hover-card", data: { controller: "phlex-kit--hover-card", action: "mouseenter->phlex-kit--hover-card#show mouseleave->phlex-kit--hover-card#hide focusin->phlex-kit--hover-card#show focusout->phlex-kit--hover-card#hide" } }, @attrs), &)
    end
  end
end
