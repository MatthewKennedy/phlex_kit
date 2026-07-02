module PhlexKit
  # Light/dark theme switch built on Toggle. Ported from ruby_ui's RubyUI::
  # ThemeToggle. The sibling phlex-kit--theme-toggle controller listens for the
  # toggle's change event and flips :root[data-theme] (matching the token system).
  class ThemeToggle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      render PhlexKit::Toggle.new(
        aria: { label: "Toggle theme" },
        wrapper: { data: { controller: "phlex-kit--theme-toggle", action: "phlex-kit--toggle:change->phlex-kit--theme-toggle#apply" } },
        **@attrs, &block
      )
    end
  end
end
