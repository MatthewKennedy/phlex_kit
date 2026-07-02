module PhlexKit
  # See menubar.rb.
  class MenubarSeparator < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template = div(**mix({ class: "pk-menubar-separator", role: "separator" }, @attrs))
  end
end
