module PhlexKit
  # Star rating (CUSTOM — ruby_ui has no rating component). Replaces the `stars`
  # view helper: renders `rating` filled stars + the remainder empty, out of
  # `max`. Presentational; attrs pass through via mix. Self-colours (amber) so it
  # works anywhere, not just inside a review.
  class Stars < BaseComponent
    def initialize(rating:, max: 5, **attrs)
      @rating = rating.to_i.clamp(0, max)
      @max = max
      @attrs = attrs
    end

    def view_template
      span(**mix({ class: "pk-stars", title: "#{@rating}/#{@max}" }, @attrs)) do
        plain(("★" * @rating) + ("☆" * (@max - @rating)))
      end
    end
  end
end
