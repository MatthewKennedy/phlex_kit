module PhlexKit
  # Validation message(s) for a Field, ported from shadcn/ui's FieldError.
  # Pass `errors:` an array of message strings (deduped; one renders plain,
  # several render a list) or give a block. Renders nothing when empty —
  # matching theirs. Distinct from FormFieldError, which is the Stimulus
  # live-validation slot; server-rendered errors belong here. See field.rb.
  class FieldError < BaseComponent
    def initialize(errors: nil, **attrs)
      @errors = Array(errors).compact.uniq
      @attrs = attrs
    end

    def view_template(&block)
      return if @errors.empty? && !block

      div(**mix({ class: "pk-field-error", role: "alert", data: { slot: "field-error" } }, @attrs)) do
        if block
          yield
        elsif @errors.length == 1
          plain @errors.first
        else
          ul(class: "pk-field-error-list") do
            @errors.each { |message| li { message } }
          end
        end
      end
    end
  end
end
