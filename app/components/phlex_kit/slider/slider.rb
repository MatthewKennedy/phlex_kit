module PhlexKit
  # Range slider, ported from shadcn/ui's Slider. Radix's slider is replaced
  # with a styled native <input type="range"> (keyboard/touch/forms for free);
  # the tiny phlex-kit--slider controller keeps the filled-track width in sync
  # via a custom property. `.pk-slider` (slider.css).
  class Slider < BaseComponent
    def initialize(min: 0, max: 100, step: 1, value: nil, **attrs)
      @min = min
      @max = max
      @step = step
      @value = value || (@min + (@max - @min) / 2)
      @attrs = attrs
    end

    def view_template
      input(**mix({
        type: :range,
        min: @min,
        max: @max,
        step: @step,
        value: @value,
        class: "pk-slider",
        # Trailing ";" — mix joins a caller style: with a space; without it
        # both declarations fuse into one invalid declaration.
        style: "--pk-slider-progress: #{progress}%;",
        data: {
          controller: "phlex-kit--slider",
          action: "input->phlex-kit--slider#update"
        }
      }, @attrs))
    end

    private

    def progress
      span = (@max - @min).to_f
      return 0 if span.zero?
      (((@value.to_f - @min) / span) * 100).round(2)
    end
  end
end
