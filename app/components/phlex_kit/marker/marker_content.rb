module PhlexKit
  # Text of a Marker. See marker.rb.
  class MarkerContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = span(**mix({ class: "pk-marker-content" }, @attrs), &)
  end
end
