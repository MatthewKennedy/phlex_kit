module PhlexKit
  # 16px muted icon slot of a Marker. See marker.rb.
  class MarkerIcon < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = span(**mix({ class: "pk-marker-icon" }, @attrs), &)
  end
end
