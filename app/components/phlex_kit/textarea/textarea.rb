module PhlexKit
  # Multi-line text input, ported from ruby_ui's RubyUI::Textarea. Same plain-CSS
  # treatment (and form-field wiring) as PhlexKit::Input — `rows:` sets the initial height,
  # the yielded block is the textarea's content (an edit form's current value),
  # and every other attr (`name:`, `id:`, `placeholder:`, `**on(...)`) passes
  # through via `mix`. No VARIANTS. Styled by `.pk-textarea` (textarea.css).
  class Textarea < BaseComponent
    def initialize(rows: 4, **attrs)
      @rows = rows
      @attrs = attrs
    end

    def view_template(&block)
      textarea(**mix({
        rows: @rows,
        class: "pk-textarea",
        data: {
          phlex_kit__form_field_target: "input",
          action: "input->phlex-kit--form-field#onInput invalid->phlex-kit--form-field#onInvalid"
        }
      }, @attrs), &block)
    end
  end
end
