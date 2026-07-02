module PhlexKit
  # Opens the command palette on click and on ctrl/cmd+K (override with
  # `keybindings:`). Wrap a PhlexKit::Button or any clickable. See command.rb.
  class CommandDialogTrigger < BaseComponent
    DEFAULT_KEYBINDINGS = [
      "keydown.ctrl+k@window",
      "keydown.meta+k@window"
    ].freeze

    def initialize(keybindings: DEFAULT_KEYBINDINGS, **attrs)
      @keybindings = keybindings.map { |kb| "#{kb}->phlex-kit--command-dialog#open" }
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-command-dialog-trigger",
        data: { action: [ "click->phlex-kit--command-dialog#open", *@keybindings ].join(" ") }
      }, @attrs), &)
    end
  end
end
