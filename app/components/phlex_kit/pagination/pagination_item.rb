module PhlexKit
  class PaginationItem < BaseComponent
    def initialize(href: "#", active: false, **attrs)
      @href = href
      @active = active
      @attrs = attrs
    end
    def view_template(&block)
      li do
        a(**mix({ href: @href, class: "pk-button #{@active ? "outline" : "ghost"}", aria: { current: (@active ? "page" : nil) } }, @attrs), &block)
      end
    end
  end
end
