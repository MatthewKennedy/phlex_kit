module PhlexKit
  # Modal confirm dialog, ported from ruby_ui's RubyUI::AlertDialog. Keeps the
  # Stimulus controller: the trigger clones the (template) content into <body> as
  # a modal; Cancel removes it. No floating-ui. Compose Trigger + Content
  # (Header/Title/Description + Footer with Cancel + the destructive submit).
  # Tailwind → vanilla `.pk-alert-dialog*` (alert_dialog.css).
  class AlertDialog < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-alert-dialog",
        data: { controller: "phlex-kit--alert-dialog", phlex_kit__alert_dialog_open_value: @open.to_s }
      }, @attrs), &block)
    end
  end
end
