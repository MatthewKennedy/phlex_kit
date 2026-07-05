module PhlexKit
  # On/off toggle rendered as a checkbox styled as a track+thumb. Ported from
  # ruby_ui's RubyUI::Switch — pure CSS (`:has(:checked)`), no Stimulus. Emits an
  # optional hidden field so an unchecked box still posts a value (Rails idiom).
  class Switch < BaseComponent
    SIZES = { md: nil, sm: "sm" }.freeze

    def initialize(include_hidden: true, checked_value: "1", unchecked_value: "0", size: :md, **attrs)
      @include_hidden = include_hidden
      @checked_value = checked_value
      @unchecked_value = unchecked_value
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template
      label(**mix({ role: "switch", class: [ "pk-switch", SIZES.fetch(@size) ].compact.join(" ") }, {})) do
        input(type: "hidden", name: @attrs[:name], value: @unchecked_value) if @include_hidden
        input(**mix({ class: "pk-switch-input" }, @attrs).merge(type: "checkbox", value: @checked_value))
        span(class: "pk-switch-thumb")
      end
    end
  end
end
