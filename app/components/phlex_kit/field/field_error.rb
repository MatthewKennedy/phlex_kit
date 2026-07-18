module PhlexKit
  # Validation message(s) for a Field, ported from shadcn/ui's FieldError.
  # Pass `errors:` an array of message strings (deduped; one renders plain,
  # several render a list) or give a block — both render (block after the
  # list) when both are given. Renders nothing when empty — matching theirs. Distinct from FormFieldError, which is the Stimulus
  # live-validation slot; server-rendered errors belong here. See field.rb.
  class FieldError < BaseComponent
    def initialize(errors: nil, **attrs)
      @errors = Array(errors).compact.uniq
      @attrs = attrs
    end

    def view_template(&block)
      return if @errors.empty? && !block

      base = { class: "pk-field-error", data: { slot: "field-error" } }
      # Default only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "alert" unless attr_set?(:role)
      div(**mix(base, @attrs)) do
        if @errors.length == 1
          plain @errors.first
        elsif @errors.length > 1
          ul(class: "pk-field-error-list") do
            @errors.each { |message| li { message } }
          end
        end
        yield if block
      end
    end
  end
end
