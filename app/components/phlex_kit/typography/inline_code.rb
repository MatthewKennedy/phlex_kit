module PhlexKit
  # Inline `<code>`, ported from ruby_ui's RubyUI::InlineCode. Replaces the legacy
  # `code.key` utility. See heading.rb (same Typography family).
  class InlineCode < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      code(**mix({ class: "pk-inline-code" }, @attrs), &block)
    end
  end
end
