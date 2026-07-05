module PhlexKit
  # <legend> of a FieldSet, ported from shadcn/ui's FieldLegend.
  # variant: :legend (text-base, default) or :label (text-sm — matches
  # FieldLabel when the set sits among plain fields). See field.rb.
  class FieldLegend < BaseComponent
    VARIANTS = { legend: "legend", label: "label" }.freeze

    def initialize(variant: :legend, **attrs)
      @variant = variant.to_sym
      @attrs = attrs
    end

    def view_template(&)
      legend(**mix({ class: "pk-field-legend #{VARIANTS.fetch(@variant)}" }, @attrs), &)
    end
  end
end
