module PhlexKit
  # Light/dark theme switch built on Toggle. Ported from ruby_ui's RubyUI::
  # ThemeToggle. The sibling phlex-kit--theme-toggle controller listens for the
  # toggle's change event and flips :root[data-theme] (matching the token system).
  # Only an actual user toggle is persisted to localStorage — with no stored
  # choice the OS preference is followed live on every load.
  #
  # The controller applies the stored theme at Stimulus connect, which is late
  # enough to flash light-mode for returning dark-theme users. To avoid the
  # FOUC, inline this in <head> before any stylesheets:
  #
  #   <script>
  #     let t; try { t = localStorage.theme } catch {}
  #     document.documentElement.dataset.theme = (t === "dark" || t === "light") ? t : "system";
  #   </script>
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
