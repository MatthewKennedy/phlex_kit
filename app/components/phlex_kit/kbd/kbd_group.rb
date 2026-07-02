module PhlexKit
  # Row of Kbd chips (e.g. ⌘ + K). See kbd.rb.
  class KbdGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      kbd(**mix({ class: "pk-kbd-group" }, @attrs), &)
    end
  end
end
