module PhlexKit
  # Header region of a PhlexKit::AlertDialog (Title + Description). See alert_dialog.rb.
  class AlertDialogHeader < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: "pk-alert-dialog-header" }, @attrs), &block)
    end
  end
end
