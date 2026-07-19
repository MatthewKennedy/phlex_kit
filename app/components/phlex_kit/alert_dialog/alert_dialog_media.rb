module PhlexKit
  # Icon/image tile in an AlertDialogHeader — a muted circle above the title
  # (beside the text column in size :sm dialogs). Ported from shadcn/ui's
  # AlertDialogMedia (newer than ruby_ui's alert dialog). See alert_dialog.rb.
  class AlertDialogMedia < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      base = { class: "pk-alert-dialog-media" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:aria] = { hidden: "true" } unless aria_key_set?(:hidden)
      div(**mix(base, @attrs), &)
    end
  end
end
