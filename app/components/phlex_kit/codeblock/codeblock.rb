module PhlexKit
  # Preformatted code block. Ported from ruby_ui's RubyUI::Codeblock, minus the
  # server-side syntax highlighting (ruby_ui uses the `rouge` gem). Ships a plain
  # styled <pre><code>; add rouge yourself and pass pre-highlighted HTML if wanted.
  class Codeblock < BaseComponent
    def initialize(code = nil, syntax: nil, **attrs)
      @code = code
      @syntax = syntax
      @attrs = attrs
    end
    def view_template(&block)
      # tabindex=0 + role=region: the block scrolls (overflow:auto), so it must
      # be keyboard-focusable (WCAG 2.1.1 scrollable-region-focusable). Pass
      # `aria: { label: ... }` to name the region for AT.
      # Defaults only when the caller didn't supply their own — `mix` would
      # fuse tabindex="0 -1" / role="region article" instead of overriding.
      base = { class: "pk-codeblock", data: { syntax: @syntax } }
      base[:tabindex] = "0" unless attr_set?(:tabindex)
      base[:role] = "region" unless attr_set?(:role)
      # A region landmark without a name is an axe violation — default one
      # from the syntax; a caller aria: { label: } replaces it (never fused).
      unless aria_labelled?
        base[:aria] = { label: @syntax ? "#{@syntax} code" : "Code" }
      end
      div(**mix(base, @attrs)) do
        pre do
          if block
            code(&block)
          else
            code { @code }
          end
        end
      end
    end
  end
end
