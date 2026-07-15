module PhlexKit
  # Callout box, ported from ruby_ui's RubyUI::Alert and matched to shadcn/ui's
  # current alert. Presentational, no JS. A `variant:` selector (same shape as
  # PhlexKit::Button) tints the text; a leading svg child becomes the icon column
  # (CSS :has switches the grid); compose with AlertTitle + AlertDescription
  # (+ optional AlertAction pinned top-right):
  #
  #   render PhlexKit::Alert.new do
  #     svg(...) { ... }  # optional icon
  #     render PhlexKit::AlertTitle.new { "Saved" }
  #     render PhlexKit::AlertDescription.new { "Your changes are live." }
  #     render PhlexKit::AlertAction.new { render PhlexKit::Button.new(size: :sm) { "Undo" } }
  #   end
  #
  # shadcn ships default/destructive; success/warning are kit extras kept from
  # ruby_ui, restyled to the same text-tint grammar. `VARIANTS.fetch` fails loud.
  class Alert < BaseComponent
    # variant => extra class appended after the base `pk-alert` (nil = neutral).
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
      div(**mix({ class: classes, role: "alert" }, @attrs), &block)
    end

    private

    def classes
      [ "pk-alert", fetch_option(VARIANTS, @variant, :variant) ].compact.join(" ")
    end
  end
end
