module PhlexKit
  # Filled action button in a toast (e.g. "Undo"). Pass `on:` a Stimulus action
  # string for server-rendered toasts; client-spawned toasts get their onClick
  # wired by the toaster when it clones the action slot template.
  # See toast_region.rb.
  class ToastAction < BaseComponent
    def initialize(label:, on: nil, **attrs)
      @label = label
      @on = on
      @attrs = attrs
    end

    def view_template
      data = { slot: "action" }
      # Caller action first, then dismiss — client-spawned actions dismiss
      # their toast after onClick (Sonner parity), so server-rendered ones
      # must too.
      data[:action] = [ @on, "click->phlex-kit--toast#dismiss" ].compact.join(" ") if @on
      button(**mix({ type: :button, class: "pk-toast-action", data: data }, @attrs)) { @label }
    end
  end
end
