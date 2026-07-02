module PhlexKit
  # Callout box, ported from ruby_ui's RubyUI::Alert. Presentational, no JS. A
  # `variant:` selector (same shape as PhlexKit::Button) tints the box; compose with
  # AlertTitle + AlertDescription:
  #
  #   render PhlexKit::Alert.new(variant: :success) do
  #     render PhlexKit::AlertTitle.new { "Saved" }
  #     render PhlexKit::AlertDescription.new { "Your changes are live." }
  #   end
  #
  # ruby_ui's variants (nil / warning / success / destructive) map onto the
  # palette tokens in vanilla CSS (alert.css). `VARIANTS.fetch` fails loud.
  class Alert < BaseComponent
    # variant => extra class appended after the base `ui-alert` (nil = neutral).
    VARIANTS = {
      default: nil,
      warning: "warning",
      success: "success",
      destructive: "destructive"
    }.freeze

    def initialize(variant: :default, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({ class: classes }, @attrs), &block)
    end

    private

    def classes
      [ "pk-alert", VARIANTS.fetch(@variant) ].compact.join(" ")
    end
  end
end
