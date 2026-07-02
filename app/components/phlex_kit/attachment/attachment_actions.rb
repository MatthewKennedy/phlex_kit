module PhlexKit
  # See attachment.rb.
  class AttachmentActions < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-attachment-actions" }, @attrs), &)
  end
end
