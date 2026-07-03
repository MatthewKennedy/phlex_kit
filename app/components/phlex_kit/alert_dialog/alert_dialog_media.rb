module PhlexKit
  # Icon/image tile in an AlertDialogHeader — a muted circle above the title
  # (beside the text column in size :sm dialogs). Ported from shadcn/ui's
  # AlertDialogMedia (newer than ruby_ui's alert dialog). See alert_dialog.rb.
  class AlertDialogMedia < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-alert-dialog-media", aria: { hidden: "true" } }, @attrs), &)
    end
  end
end
