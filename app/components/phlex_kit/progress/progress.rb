module PhlexKit
  # Progress bar, ported from ruby_ui's RubyUI::Progress. `value:` (0–100,
  # clamped) drives an inner indicator translated into view. Presentational, no
  # JS; width comes from a caller `class:`/`style:`. Tailwind → vanilla
  # `.pk-progress*` (progress.css).
  class Progress < BaseComponent
    # value_text: is a named kwarg (not read from **attrs) because `mix`
    # would *fuse* a caller "aria-valuetext" with the generated default.
    # `value: nil` renders the INDETERMINATE state (Radix parity): a sliding
    # animation, data-state="indeterminate", and no aria-valuenow — which is
    # exactly how ARIA marks a progressbar of unknown value.
    def initialize(value: 0, value_text: nil, **attrs)
      @value = value.nil? ? nil : value.to_f.clamp(0.0, 100.0)
      @value_text = value_text
      @attrs = attrs
    end

    def view_template
      div(**mix(root_attrs, @attrs)) do
        div(class: "pk-progress-indicator")
      end
    end

    private

    def root_attrs
      base = {
        role: "progressbar",
        "aria-valuemin": 0,
        "aria-valuemax": 100,
        class: "pk-progress"
      }
      if @value.nil?
        base[:class] = "pk-progress indeterminate"
        base[:data] = { state: "indeterminate" }
        base[:"aria-valuetext"] = @value_text if @value_text
      else
        # %g drops float artifacts ("40.0" would be announced as "forty point
        # zero percent"). The value travels as a custom property so the fill
        # transform lives in progress.css, where a :dir(rtl) arm can flip it —
        # an inline translateX always filled from the physical left.
        v = Kernel.format("%g", @value)
        base[:"aria-valuenow"] = v
        base[:"aria-valuetext"] = @value_text || "#{v}%"
        base[:style] = "--pk-progress-value: #{v};"
      end
      base
    end
  end
end
