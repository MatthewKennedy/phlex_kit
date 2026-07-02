module PhlexKit
  # See attachment.rb.
  class AttachmentTitle < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-attachment-title" }, @attrs), &)
  end
end
