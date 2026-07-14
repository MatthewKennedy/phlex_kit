module PhlexKit
  # Wrapper wiring a CommandDialogTrigger to its CommandDialogContent. The
  # controller tracks its own live clone (sheet pattern) so a second trigger
  # press just refocuses the input — per instance, unlike the old
  # document-scoped outlet selector, which let one dialog adopt another's
  # open palette. See command.rb.
  class CommandDialog < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        data: { controller: "phlex-kit--command-dialog" }
      }, @attrs), &)
    end
  end
end
