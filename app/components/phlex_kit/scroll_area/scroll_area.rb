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
      base = { class: "pk-scroll-area", tabindex: "0" }
      base[:role] = "region" if labelled?
      div(**mix(base, @attrs), &)
    end

    private

    # True when the caller supplies an accessible name, via the aria: hash
    # (aria: { label:/labelledby: }) or flat aria_label/aria-labelledby attrs.
    def labelled?
      aria = @attrs[:aria] || @attrs["aria"]
      if aria.is_a?(Hash)
        return true if %w[label labelledby].any? { |k| aria[k.to_sym] || aria[k] }
      end
      [ :aria_label, "aria_label", "aria-label",
       :aria_labelledby, "aria_labelledby", "aria-labelledby" ].any? { |k| @attrs[k] }
    end
  end
end
