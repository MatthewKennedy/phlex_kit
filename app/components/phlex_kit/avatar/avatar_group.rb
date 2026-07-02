module PhlexKit
  # Overlapping row of Avatars (shadcn's grouped avatars). See avatar.rb.
  class AvatarGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-avatar-group" }, @attrs), &)
  end
end
