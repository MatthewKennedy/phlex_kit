module PhlexKit
  # Square preview tile of an Attachment — a file-type icon or an <img>.
  # See attachment.rb.
  class AttachmentMedia < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-attachment-media" }, @attrs), &)
  end
end
