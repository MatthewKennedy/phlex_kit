module PhlexKit
  # Progress bar, ported from ruby_ui's RubyUI::Progress. `value:` (0–100,
  # clamped) drives an inner indicator translated into view. Presentational, no
  # JS; width comes from a caller `class:`/`style:`. Tailwind → vanilla
  # `.pk-progress*` (progress.css).
  class Progress < BaseComponent
    def initialize(value: 0, **attrs)
      @value = value.to_f.clamp(0.0, 100.0)
      @attrs = attrs
    end

    def view_template
      div(**mix({
        role: "progressbar",
        "aria-valuenow": @value,
        "aria-valuemin": 0,
        "aria-valuemax": 100,
        "aria-valuetext": "#{@value}%",
        class: "pk-progress"
      }, @attrs)) do
        div(class: "pk-progress-indicator", style: "transform: translateX(-#{100 - @value}%)")
      end
    end
  end
end
