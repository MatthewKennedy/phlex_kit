module PhlexKit
  # Blockquote, ported from ruby_ui's RubyUI::TypographyBlockquote. See heading.rb.
  class Blockquote < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      blockquote(**mix({ class: "pk-blockquote" }, @attrs), &block)
    end
  end
end
