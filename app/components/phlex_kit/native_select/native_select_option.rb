module PhlexKit
  # A single <option> inside PhlexKit::NativeSelect. Plain pass-through wrapper (no
  # base class); `value:`/`selected:`/`disabled:` ride through to the element.
  # See native_select.rb.
  class NativeSelectOption < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      option(**@attrs, &block)
    end
  end
end
