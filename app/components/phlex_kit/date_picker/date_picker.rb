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
      @selected_date = selected_date
      @date_format = date_format
      # Seed the input with the same date_format the calendar controller
      # writes — a bare `selected_date.to_s` (ISO) would mismatch the format
      # until the first interaction.
      @value = value || format_selected_date
      @placeholder = placeholder
      # An id smuggled through input_attrs would MERGE with the generated one
      # (mix fuses duplicate string attrs), breaking label[for] and the
      # calendar outlet selector — the top-level id: kwarg is the one path.
      if input_attrs.key?(:id) || input_attrs.key?("id")
        raise ArgumentError, "DatePicker: pass id: as the top-level kwarg, not input_attrs[:id]"
      end
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
            render Calendar.new(input_id: input_selector, selected_date: @selected_date, date_format: @date_format, **@calendar_attrs)
          end
        end
      end
    end

    private

    # The outlet takes a CSS selector. "#id" is only valid for CSS-identifier
    # ids — anything else (Rails-style "user:due.date" etc) must go through a
    # quoted attribute selector or querySelector throws.
    def input_selector
      return "##{@id}" if @id.match?(/\A[A-Za-z][\w-]*\z/)

      %([id="#{@id.gsub(/[\\"]/) { |c| "\\#{c}" }}"])
    end

    # Mirrors the calendar controller's formatDate tokens (calendar_controller.js)
    # so the server-rendered input matches what JS writes after a pick.
    FORMAT_TOKENS = /yyyy|MMMM|MM|dd|HH|mm|ss|EEEE|PPPP|do/

    def format_selected_date
      return nil unless @selected_date

      date = @selected_date.respond_to?(:strftime) ? @selected_date : Date.parse(@selected_date.to_s)
      day = date.day
      suffix = day_suffix(day)
      day_name = Date::DAYNAMES[date.wday]
      month_name = Date::MONTHNAMES[date.month]
      map = {
        "yyyy" => date.year.to_s,
        "MMMM" => month_name,
        "MM" => Kernel.format("%02d", date.month),
        "dd" => Kernel.format("%02d", day),
        "HH" => Kernel.format("%02d", date.respond_to?(:hour) ? date.hour : 0),
        "mm" => Kernel.format("%02d", date.respond_to?(:min) ? date.min : 0),
        "ss" => Kernel.format("%02d", date.respond_to?(:sec) ? date.sec : 0),
        "EEEE" => day_name,
        "do" => "#{day}#{suffix}",
        "PPPP" => "#{day_name}, #{month_name} #{day}#{suffix}, #{date.year}"
      }
      @date_format.gsub(FORMAT_TOKENS) { |token| map[token] }
    rescue Date::Error
      @selected_date.to_s
    end

    def day_suffix(day)
      return "th" if day > 3 && day < 21

      { 1 => "st", 2 => "nd", 3 => "rd" }.fetch(day % 10, "th")
    end

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
