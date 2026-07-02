module PhlexKit
  # Date picker, ported from ruby_ui's RubyUI::DatePicker: a labelled
  # PhlexKit::Input inside a PhlexKit::Popover whose panel holds a
  # PhlexKit::Calendar. The input carries the phlex-kit--calendar-input
  # controller and the calendar's outlet points at its id, so picking a day
  # writes the formatted date into the field. Upstream's popover_options
  # (hover trigger via @floating-ui) are gone — the kit popover is click-only,
  # CSS-positioned. Tailwind → vanilla `.pk-date-picker*` (date_picker.css).
  class DatePicker < BaseComponent
    def initialize(
      id: nil,
      name: nil,
      label: "Select a date",
      value: nil,
      placeholder: "Select a date",
      selected_date: value,
      date_format: "yyyy-MM-dd",
      input_attrs: {},
      calendar_attrs: {},
      trigger_attrs: {},
      content_attrs: {},
      **attrs
    )
      @id = id || "date-picker-#{SecureRandom.hex(4)}"
      @name = name
      @label = label
      @value = value || selected_date&.to_s
      @placeholder = placeholder
      @selected_date = selected_date
      @date_format = date_format
      @input_attrs = input_attrs
      @calendar_attrs = calendar_attrs
      @trigger_attrs = trigger_attrs
      @content_attrs = content_attrs
      @attrs = attrs
    end

    def view_template
      div(**mix({ class: "pk-date-picker" }, @attrs)) do
        render Popover.new do
          render PopoverTrigger.new(**trigger_attrs) do
            div(class: "pk-date-picker-field") do
              label(class: "pk-date-picker-label", for: @id) { @label } if @label
              render Input.new(**input_attrs)
            end
          end
          render PopoverContent.new(**@content_attrs) do
            render Calendar.new(input_id: "##{@id}", selected_date: @selected_date, date_format: @date_format, **@calendar_attrs)
          end
        end
      end
    end

    private

    def trigger_attrs
      mix({ class: "pk-date-picker-trigger" }, @trigger_attrs)
    end

    def input_attrs
      mix({
        type: :text,
        placeholder: @placeholder,
        id: @id,
        name: @name,
        value: @value,
        data: { controller: "phlex-kit--calendar-input" }
      }.compact, @input_attrs)
    end
  end
end
