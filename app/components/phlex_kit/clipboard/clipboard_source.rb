module PhlexKit
  class ClipboardSource < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ data: { phlex_kit__clipboard_target: "source" } }, @attrs), &)
  end
end
