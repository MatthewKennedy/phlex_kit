module PhlexKit
  # <template>s for the five day states (disabled / selected / today / current
  # month / other month). The controller picks one per day and interpolates
  # {{day}} / {{dayDate}} / {{dayLabel}} / {{state}} — state carries the extra
  # range/booked classes (range-start / range-end / in-range / booked), and
  # dayLabel is the full human-readable date used as the button's accessible
  # name. Per the APG date-grid pattern the <td> is the gridcell (and carries
  # aria-selected); the <button> inside is a plain button. See calendar.rb.
  class CalendarDays < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      render_disabled_date_template
      render_selected_date_template
      render_today_date_template
      render_current_month_date_template
      render_other_month_date_template
    end

    private

    def render_disabled_date_template
      date_template("disabledDateTemplate") do
        button(
          data_day: "{{day}}",
          name: "day",
          class: "pk-calendar-day disabled {{state}}",
          disabled: true,
          tabindex: "-1",
          type: "button",
          aria_disabled: "true",
          aria_label: "{{dayLabel}}"
        ) { "{{dayDate}}" }
      end
    end

    def render_selected_date_template
      date_template("selectedDateTemplate", aria_selected: "true") do
        button(
          data_day: "{{day}}",
          data_action: "click->phlex-kit--calendar#selectDay",
          name: "day",
          class: "pk-calendar-day selected {{state}}",
          tabindex: "0",
          type: "button",
          aria_label: "{{dayLabel}}"
        ) { "{{dayDate}}" }
      end
    end

    def render_today_date_template
      date_template("todayDateTemplate") do
        button(
          data_day: "{{day}}",
          data_action: "click->phlex-kit--calendar#selectDay",
          name: "day",
          class: "pk-calendar-day today {{state}}",
          tabindex: "-1",
          type: "button",
          aria_label: "{{dayLabel}}"
        ) { "{{dayDate}}" }
      end
    end

    def render_current_month_date_template
      date_template("currentMonthDateTemplate") do
        button(
          data_day: "{{day}}",
          data_action: "click->phlex-kit--calendar#selectDay",
          name: "day",
          class: "pk-calendar-day {{state}}",
          tabindex: "-1",
          type: "button",
          aria_label: "{{dayLabel}}"
        ) { "{{dayDate}}" }
      end
    end

    def render_other_month_date_template
      date_template("otherMonthDateTemplate") do
        button(
          data_day: "{{day}}",
          data_action: "click->phlex-kit--calendar#selectDay",
          name: "day",
          class: "pk-calendar-day other {{state}}",
          tabindex: "-1",
          type: "button",
          aria_label: "{{dayLabel}}"
        ) { "{{dayDate}}" }
      end
    end

    def date_template(target, **td_attrs, &block)
      template(data: { phlex_kit__calendar_target: target }) do
        td(class: "pk-calendar-cell", role: "gridcell", **td_attrs, &block)
      end
    end
  end
end
