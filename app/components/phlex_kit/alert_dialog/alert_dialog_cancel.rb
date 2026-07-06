module PhlexKit
  # The dismiss button in a PhlexKit::AlertDialog footer — an outline PhlexKit::Button wired to
  # the controller's #dismiss (removes the modal). See alert_dialog.rb.
  class AlertDialogCancel < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      render PhlexKit::Button.new(variant: :outline, **mix({ data: { action: "click->phlex-kit--alert-dialog#dismiss" } }, @attrs), &block)
    end
  end
end
