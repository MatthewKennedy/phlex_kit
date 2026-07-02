module PhlexKit
  # Subtle dismiss button in a toast (the "Cancel" counterpart to ToastAction).
  # Dismisses via the phlex-kit--toast controller. See toast_region.rb.
  class ToastCancel < BaseComponent
    def initialize(label:, **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template
      button(**mix({
        type: :button,
        class: "pk-toast-cancel",
        data: { slot: "cancel", action: "click->phlex-kit--toast#dismiss" }
      }, @attrs)) { @label }
    end
  end
end
