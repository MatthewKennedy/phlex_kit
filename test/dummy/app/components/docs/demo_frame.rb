# frozen_string_literal: true

module Docs
  # One use case: title + Preview/Code tabs (dogfooding PhlexKit::Tabs +
  # Codeblock). The code tab shows the example's real view_template body,
  # extracted from its source file — it can never drift from the preview.
  class DemoFrame < Phlex::HTML
    def initialize(example, title: nil)
      @example = example
      @title = title || example.name.demodulize.underscore.humanize
    end

    def view_template
      section(class: "docs-demo") do
        h2(class: "docs-demo-title", id: @title.parameterize) { @title }
        render PhlexKit::Tabs.new(default: "preview") do
          render PhlexKit::TabsList.new do
            render PhlexKit::TabsTrigger.new(value: "preview") { "Preview" }
            render PhlexKit::TabsTrigger.new(value: "code") { "Code" }
          end
          render PhlexKit::TabsContent.new(value: "preview") do
            div(class: "docs-demo-preview") { render @example.new }
          end
          render PhlexKit::TabsContent.new(value: "code") do
            div(class: "docs-demo-code") do
              # The kit's Codeblock is plain by design; the docs site is a host,
              # and hosts bring their own highlighter — rouge, here.
              highlighted = self.class.highlight(source_body)
              render PhlexKit::Codeblock.new(syntax: :ruby) do
                raw safe(highlighted)
              end
            end
          end
        end
      end
    end

    def self.highlight(source)
      Rouge::Formatters::HTML.new.format(Rouge::Lexers::Ruby.new.lex(source))
    end

    private

    # The view_template body, dedented. Indentation-based (nested block `end`s
    # defeat regexes); example files are machine-formatted so this is reliable.
    def source_body
      path = Object.const_source_location(@example.name).first
      lines = File.read(path).lines
      start = lines.index { |l| l =~ /def view_template/ }
      indent = lines[start][/\A */].size
      stop = (start + 1...lines.size).find { |i| lines[i] =~ /\A {#{indent}}end\b/ }
      lines[(start + 1)...stop].map { |l| l.strip.empty? ? "\n" : l[(indent + 2)..] }.join
    end
  end
end
