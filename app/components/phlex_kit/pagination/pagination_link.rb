module PhlexKit
  # A page-number link (square ghost button; outline when active), ported from
  # shadcn/ui's PaginationLink. Renders its own <li>. See pagination.rb.
  class PaginationLink < BaseComponent
    def initialize(href: "#", active: false, **attrs)
      @href = href
      @active = active
      @attrs = attrs
    end

    def view_template(&block)
      li do
        a(**mix({
          href: @href,
          class: "pk-button #{@active ? "outline" : "ghost"} icon",
          aria: { current: (@active ? "page" : nil) }
        }, @attrs), &block)
      end
    end
  end
end
