module PhlexKit
  # Styled native <select>, ported from ruby_ui's RubyUI::NativeSelect. A real
  # browser select (native option list, mobile-friendly) wrapped so we can hide
  # the OS chevron (appearance:none) and draw our own — otherwise the native
  # arrow renders an inconsistent light-on-dark box. Multi-part, like PhlexKit::Card:
  #
  #   render PhlexKit::NativeSelect.new(name: "store_id") do
  #     render PhlexKit::NativeSelectOption.new(value: "") { "All stores" }
  #     render PhlexKit::NativeSelectGroup.new(label: "Live") do
  #       render PhlexKit::NativeSelectOption.new(value: store.id) { store.name }
  #     end
  #   end
  #
  # The yielded block is the <option>/<optgroup> list; `name:`/`id:`/`required:`/
  # `**on(...)` pass through to the <select> via `mix`. `size:` is the kit's lone
  # selector here (default | sm) — `SIZES.fetch` fails loud on anything else.
  class NativeSelect < BaseComponent
    # size => extra class appended after the base select class (nil = default).
    SIZES = {
      default: nil,
      sm: "sm"
    }.freeze

    def initialize(size: :default, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(class: "pk-native-select") do
        select(**mix({
          class: classes,
          data: {
            phlex_kit__form_field_target: "input",
            action: "change->phlex-kit--form-field#onChange invalid->phlex-kit--form-field#onInvalid"
          }
        }, @attrs), &block)
        render PhlexKit::NativeSelectIcon.new
      end
    end

    private

    def classes
      [ "pk-native-select-field", fetch_option(SIZES, @size, :size) ].compact.join(" ")
    end
  end
end
