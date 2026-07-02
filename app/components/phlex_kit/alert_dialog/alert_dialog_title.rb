module PhlexKit
  # Title of a PhlexKit::AlertDialog. See alert_dialog.rb.
  class AlertDialogTitle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      h2(**mix({ class: "pk-alert-dialog-title" }, @attrs), &block)
    end
  end
end
