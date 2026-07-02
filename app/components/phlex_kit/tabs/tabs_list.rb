module PhlexKit
  class TabsList < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-tabs-list", role: "tablist" }, @attrs), &)
  end
end
