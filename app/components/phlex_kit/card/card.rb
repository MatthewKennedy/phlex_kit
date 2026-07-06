module PhlexKit
  # Container card kit, ported from ruby_ui's Card (https://ruby-ui.com). Six
  # presentational parts — Card + CardHeader / CardTitle / CardDescription /
  # CardContent / CardFooter — each wrapping its children in an element with a
  # base class and passing arbitrary attrs straight through via `mix` (so a
  # caller `class:` augments rather than clobbers, exactly like PhlexKit::Button).
  #
  # Styles are namespaced `.pk-card*` in card.css rather than `.card`: this app
  # already uses `.card` for the dashboard stat tiles (application.css), which are
  # a different, padded component. Compose the parts:
  #
  #   render PhlexKit::Card.new do
  #     render PhlexKit::CardHeader.new do
  #       render PhlexKit::CardTitle.new { "Title" }
  #       render PhlexKit::CardDescription.new { "Subtitle" }
  #     end
  #     render PhlexKit::CardContent.new { "…" }
  #     render PhlexKit::CardFooter.new { render PhlexKit::Button.new { "Action" } }
  #   end
  class Card < BaseComponent
    # size => modifier class; :sm tightens --pk-card-spacing (shadcn's size prop).
    SIZES = { default: nil, sm: "sm" }.freeze

    def initialize(size: :default, **attrs)
      @size = size.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: [ "pk-card", fetch_option(SIZES, @size, :size) ].compact.join(" ") }, @attrs), &block)
    end
  end
end
