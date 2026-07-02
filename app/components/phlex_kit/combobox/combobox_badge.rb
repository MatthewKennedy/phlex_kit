module PhlexKit
  # Selected-value chip, ported from ruby_ui's RubyUI::ComboboxBadge. The
  # controller builds chips with this class into the ComboboxBadgeTrigger's
  # container client-side; render the component directly when server-rendering
  # an initial selection. See combobox.rb.
  class ComboboxBadge < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      span(**mix({ class: "pk-combobox-badge" }, @attrs), &)
    end
  end
end
