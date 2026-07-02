module PhlexKit
  # Keyboard-key chip, ported from shadcn/ui's Kbd. The kit's ShortcutKey
  # predates it (ruby_ui naming) — Kbd is the shadcn-parity spelling; group
  # several in a KbdGroup. `.pk-kbd` (kbd.css).
  class Kbd < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      kbd(**mix({ class: "pk-kbd" }, @attrs), &)
    end
  end
end
