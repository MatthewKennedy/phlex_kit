module PhlexKit
  # Stack of Items. See item.rb. No role="list": Items carry no
  # role="listitem" (an href Item is an <a> that must keep its link role), so
  # claiming a list here made AT announce an empty list.
  class ItemGroup < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&) = div(**mix({ class: "pk-item-group" }, @attrs), &)
  end
end
