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
      div(**mix({ class: "pk-codeblock", data: { syntax: @syntax } }, @attrs)) do
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
