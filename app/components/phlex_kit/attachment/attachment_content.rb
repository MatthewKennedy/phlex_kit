module PhlexKit
  # See attachment.rb.
  class AttachmentContent < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-attachment-content" }, @attrs), &)
  end
end
