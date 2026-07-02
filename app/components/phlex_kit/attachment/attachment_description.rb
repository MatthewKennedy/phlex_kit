module PhlexKit
  # See attachment.rb.
  class AttachmentDescription < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-attachment-description" }, @attrs), &)
  end
end
