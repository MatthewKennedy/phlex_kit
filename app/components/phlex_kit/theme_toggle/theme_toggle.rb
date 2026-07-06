module PhlexKit
  # Light/dark theme switch built on Toggle. Ported from ruby_ui's RubyUI::
  # ThemeToggle. The sibling phlex-kit--theme-toggle controller listens for the
  # toggle's change event and flips :root[data-theme] (matching the token system).
  class ThemeToggle < BaseComponent
    def initialize(wrapper: {}, aria: {}, **attrs)
      @wrapper = wrapper
      @aria = aria
      @attrs = attrs
    end

    def view_template(&block)
      # Merge caller wrapper/aria instead of splatting @attrs over the defaults —
      # a caller `wrapper:` would otherwise replace the hash wholesale and
      # silently delete the theme-toggle controller wiring.
      render PhlexKit::Toggle.new(
        aria: { label: "Toggle theme" }.merge(@aria),
        wrapper: mix({ data: { controller: "phlex-kit--theme-toggle", action: "phlex-kit--toggle:change->phlex-kit--theme-toggle#apply" } }, @wrapper),
        **@attrs, &block
      )
    end
  end
end
