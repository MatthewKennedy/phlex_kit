module PhlexKit
  # Keyboard-shortcut hint, rendered as <kbd>. Ported from ruby_ui's
  # RubyUI::ShortcutKey. Purely visual — wires no key handler.
  class ShortcutKey < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)

    def view_template(&) = kbd(**mix({ class: "pk-shortcut-key" }, @attrs), &)
  end
end
