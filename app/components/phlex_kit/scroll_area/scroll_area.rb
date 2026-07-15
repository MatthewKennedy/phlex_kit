module PhlexKit
  # Styled scroll container, ported from shadcn/ui's ScrollArea. Radix's custom
  # scrollbars are replaced with native thin scrollbars themed via CSS — no JS.
  # Constrain it with a height/width from the caller. tabindex=0 makes the
  # scrollable region keyboard-focusable (WCAG scrollable-region-focusable).
  # Pass `aria: { label: ... }` (or aria-labelledby) to name it — only then
  # does it render role=region; a nameless region is noise for AT, so the
  # role is omitted when unlabelled. `.pk-scroll-area` (scroll_area.css).
  class ScrollArea < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      # Defaults only when the caller didn't supply their own — `mix` would
      # fuse role="region log" / tabindex="0 -1" instead of overriding.
      base = { class: "pk-scroll-area" }
      base[:tabindex] = "0" unless @attrs.key?(:tabindex) || @attrs.key?("tabindex")
      base[:role] = "region" if aria_labelled? && !@attrs.key?(:role) && !@attrs.key?("role")
      div(**mix(base, @attrs), &)
    end
  end
end
