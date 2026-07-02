module PhlexKit
  # Opens a PhlexKit::AlertDialog (wrap a PhlexKit::Button). See alert_dialog.rb.
  class AlertDialogTrigger < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-dialog-trigger", data: { action: "click->phlex-kit--alert-dialog#open" } }, @attrs), &block)
    end
  end
end
