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
      div(**mix({ class: "pk-codeblock", tabindex: "0", role: "region", data: { syntax: @syntax } }, @attrs)) do
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
