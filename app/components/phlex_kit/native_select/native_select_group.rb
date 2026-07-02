module PhlexKit
  # An <optgroup> inside PhlexKit::NativeSelect — labels a cluster of options
  # (`label:` passes through). Plain pass-through wrapper. See native_select.rb.
  class NativeSelectGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      optgroup(**@attrs, &block)
    end
  end
end
