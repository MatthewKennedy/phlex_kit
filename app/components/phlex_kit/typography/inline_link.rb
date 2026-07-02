module PhlexKit
  # Inline text link, ported from ruby_ui's RubyUI::InlineLink — a brand-coloured
  # underline-on-hover `<a>` for links inside prose (vs PhlexKit::Link, which is the
  # button-styled link family). `href:` required; attrs pass through via mix.
  class InlineLink < BaseComponent
    def initialize(href:, **attrs)
      @href = href
      @attrs = attrs
    end

    def view_template(&block)
      a(**mix({ href: @href, class: "pk-inline-link" }, @attrs), &block)
    end
  end
end
