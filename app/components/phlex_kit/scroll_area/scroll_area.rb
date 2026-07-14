module PhlexKit
  # Styled scroll container, ported from shadcn/ui's ScrollArea. Radix's custom
  # scrollbars are replaced with native thin scrollbars themed via CSS — no JS.
  # Constrain it with a height/width from the caller. tabindex=0 makes the
  # scrollable region keyboard-focusable (WCAG); role=region gives that focus
  # stop a role — pass `aria: { label: ... }` to name it. `.pk-scroll-area`
  # (scroll_area.css).
  class ScrollArea < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-scroll-area", tabindex: "0", role: "region" }, @attrs), &)
    end
  end
end
