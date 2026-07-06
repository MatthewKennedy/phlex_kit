module PhlexKit
  # One labeled control row/column, ported from shadcn/ui's Field. PRESENTATIONAL
  # layout only — pair with PhlexKit::FormField when you want the kit's Stimulus
  # live-validation (FormField wraps the control; Field arranges label, control,
  # description and error around it — they nest without conflict).
  #
  #   render PhlexKit::Field.new do
  #     render PhlexKit::FieldLabel.new(for: "email") { "Email" }
  #     render PhlexKit::Input.new(id: "email", type: :email)
  #     render PhlexKit::FieldDescription.new { "We never share it." }
  #   end
  #
  # orientation: :vertical (default) stacks; :horizontal puts the label beside
  # the control (checkbox/switch rows); :responsive is vertical that goes
  # horizontal when the enclosing FieldGroup is ≥28rem wide (container query).
  # `invalid: true` tints the whole field; `disabled: true` dims labels.
  # `.pk-field*` (field.css).
  class Field < BaseComponent
    ORIENTATIONS = { vertical: "vertical", horizontal: "horizontal", responsive: "responsive" }.freeze

    def initialize(orientation: :vertical, invalid: false, disabled: false, **attrs)
      @orientation = orientation.to_sym
      @invalid = invalid
      @disabled = disabled
      @attrs = attrs
    end

    def view_template(&)
      data = { slot: "field", orientation: fetch_option(ORIENTATIONS, @orientation, :orientation) }
      data[:invalid] = "true" if @invalid
      data[:disabled] = "true" if @disabled
      div(**mix({ class: "pk-field", role: "group", data: data }, @attrs), &)
    end
  end
end
