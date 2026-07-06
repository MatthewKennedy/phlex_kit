module PhlexKit
  # Loading spinner, ported from shadcn/ui's Spinner (a spinning loader icon;
  # not in ruby_ui). Sizes via SIZES.fetch. `.pk-spinner` (spinner.css).
  class Spinner < BaseComponent
    SIZES = { sm: "sm", md: nil, lg: "lg" }.freeze

    def initialize(size: :md, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template
      # A visible loader, not decoration: role=status + label, aria-hidden off.
      render Icon.new(:loader, size: nil, **mix({
        class: [ "pk-spinner", fetch_option(SIZES, @size, :size) ].compact.join(" "),
        role: "status",
        aria: { label: "Loading" },
        "aria-hidden": false
      }, @attrs))
    end
  end
end
