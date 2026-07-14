module PhlexKit
  class BubbleContent < BaseComponent
    # `as:` is dispatched dynamically — whitelist the sensible text containers
    # so it can't reach arbitrary (including private) methods.
    AS_TAGS = %i[div p blockquote].freeze
    def initialize(as: :div, **attrs)
      @as = as.to_sym
      raise ArgumentError, "unknown BubbleContent as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})" unless AS_TAGS.include?(@as)
      @attrs = attrs
    end
    def view_template(&)
      send(@as, **mix({ class: "pk-bubble-content", data: { slot: "bubble-content" } }, @attrs), &)
    end
  end
end
