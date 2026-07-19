module PhlexKit
  # See menubar.rb.
  class MenubarSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      base = { class: "pk-menubar-separator" }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "separator" unless attr_set?(:role)
      div(**mix(base, @attrs))
    end
  end
end
