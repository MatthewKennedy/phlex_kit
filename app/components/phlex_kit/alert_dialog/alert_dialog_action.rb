module PhlexKit
  # The confirm action in a PhlexKit::AlertDialog footer — a primary PhlexKit::Button. (For a
  # non-GET destructive action, use a `button_to` in the footer instead, so it
  # submits a real form.) See alert_dialog.rb.
  class AlertDialogAction < BaseComponent
    def initialize(variant: :primary, **attrs)
      @variant = variant
      @attrs = attrs
    end

    def view_template(&block)
      render PhlexKit::Button.new(variant: @variant, **@attrs, &block)
    end
  end
end
