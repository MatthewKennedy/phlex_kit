module PhlexKit
  class BubbleContent < BaseComponent
    # `as:` is dispatched dynamically — whitelist the documented containers
    # (incl. the interactive button/a contract bubble.css styles) so it can't
    # reach arbitrary (including private) methods.
    AS_TAGS = %i[div p blockquote button a].freeze
    def initialize(as: :div, **attrs)
      @as = as.to_sym
      raise ArgumentError, "unknown BubbleContent as: #{@as.inspect} (use one of #{AS_TAGS.join(", ")})" unless AS_TAGS.include?(@as)
      @attrs = attrs
    end
    def view_template(&)
      base = { class: "pk-bubble-content", data: { slot: "bubble-content" } }
      # An interactive bubble inside a <form> must not be an implicit
      # type="submit" (same default PhlexKit::Button ships).
      base[:type] = :button if @as == :button && !attr_set?(:type)
      send(@as, **mix(base, @attrs), &)
    end
  end
end
