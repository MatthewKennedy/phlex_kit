module PhlexKit
  # Wrapper wiring a CommandDialogTrigger to its CommandDialogContent. The
  # outlet selector finds the live palette instance (if already open) so a
  # second trigger press just refocuses the input. See command.rb.
  class CommandDialog < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        data: {
          controller: "phlex-kit--command-dialog",
          phlex_kit__command_dialog_phlex_kit__command_outlet: "[data-phlex-kit--command-dialog-instance]"
        }
      }, @attrs), &)
    end
  end
end
