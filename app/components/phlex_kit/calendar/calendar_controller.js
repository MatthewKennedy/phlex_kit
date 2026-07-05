import { Controller } from "@hotwired/stimulus";

// Ported from ruby_ui's calendar controller (mustache replaced by a tiny
// {{key}} interpolator) and extended to shadcn's current calendar surface:
// mode single (default) / range / multiple, min/max + explicit disabled
// dates (rendered struck-through as "booked"), ISO week numbers, and a
// month/year dropdown caption (native <select>s the controller keeps in
// sync). Day templates gain a {{state}} class hook so range-start /
// range-end / in-range / booked ride the same five templates.
function renderTemplate(template, data) {
  return template.replace(/{{\s*(\w+)\s*}}/g, (_, key) => String(data[key] ?? ""));
}

export default class extends Controller {
  static targets = [
    "calendar",
    "title",
    "monthSelect",
    "yearSelect",
    "weekdaysTemplate",
    "disabledDateTemplate",
    "selectedDateTemplate",
    "todayDateTemplate",
    "currentMonthDateTemplate",
    "otherMonthDateTemplate",
  ];
  static values = {
    mode: { type: String, default: "single" },
    selectedDate: { type: String, default: null },
    selectedDates: { type: Array, default: [] },
    rangeStart: { type: String, default: null },
    rangeEnd: { type: String, default: null },
    minDate: { type: String, default: null },
    maxDate: { type: String, default: null },
    disabledDates: { type: Array, default: [] },
    weekNumbers: { type: Boolean, default: false },
    viewDate: {
      type: String,
      default: new Date().toISOString().slice(0, 10),
    },
    format: { type: String, default: "yyyy-MM-dd" },
  };
  static outlets = ["phlex-kit--calendar-input"];

  initialize() {
    this.updateCalendar(); // Initial calendar render
  }

  nextMonth(e) {
    e.preventDefault();
    this.viewDateValue = this.adjustMonth(1);
  }

  prevMonth(e) {
    e.preventDefault();
    this.viewDateValue = this.adjustMonth(-1);
  }

  // month/year dropdown caption (native selects)
  setMonth(e) {
    const date = this.viewDate();
    date.setDate(2);
    date.setMonth(Number(e.target.value));
    this.viewDateValue = date.toISOString().slice(0, 10);
  }

  setYear(e) {
    const date = this.viewDate();
    date.setDate(2);
    date.setFullYear(Number(e.target.value));
    this.viewDateValue = date.toISOString().slice(0, 10);
  }

  selectDay(e) {
    e.preventDefault();
    const iso = e.currentTarget.dataset.day;
    if (this.isDateDisabled(iso)) return;

    switch (this.modeValue) {
      case "range":
        this.selectRangeDay(iso);
        break;
      case "multiple":
        this.toggleMultipleDay(iso);
        break;
      default:
        this.selectedDateValue = iso;
    }
  }

  selectRangeDay(iso) {
    const candidate = this.parseDate(iso);
    const start = this.parseDate(this.rangeStartValue);
    const end = this.parseDate(this.rangeEndValue);

    if (!start || (start && end)) {
      // begin a fresh range
      this.rangeStartValue = this.isoDate(candidate);
      this.rangeEndValue = null;
    } else if (candidate < start) {
      this.rangeStartValue = this.isoDate(candidate);
    } else {
      this.rangeEndValue = this.isoDate(candidate);
    }
    this.updateCalendar();
    this.pushToOutlets();
    this.dispatchChange();
  }

  toggleMultipleDay(iso) {
    const day = this.isoDate(this.parseDate(iso));
    const current = [...this.selectedDatesValue];
    const index = current.indexOf(day);
    if (index >= 0) {
      current.splice(index, 1);
    } else {
      current.push(day);
      current.sort();
    }
    this.selectedDatesValue = current;
    this.updateCalendar();
    this.dispatchChange();
  }

  selectedDateValueChanged(value, prevValue) {
    const selectedDate = this.selectedDate();
    if (!selectedDate) {
      this.updateCalendar();
      return;
    }

    // update the viewDateValue to the selected date's month (this re-renders)
    const newViewDate = new Date(selectedDate);
    newViewDate.setDate(2); // avoid month-length/timezone edges
    this.viewDateValue = newViewDate.toISOString().slice(0, 10);

    this.updateCalendar();
    this.pushToOutlets();
    this.dispatchChange();
  }

  viewDateValueChanged(value, prevValue) {
    this.updateCalendar();
  }

  pushToOutlets() {
    const value = this.formattedSelection();
    if (value === null) return;
    this.phlexKitCalendarInputOutlets.forEach((outlet) => outlet.setValue(value));
  }

  formattedSelection() {
    if (this.modeValue === "range") {
      const start = this.parseDate(this.rangeStartValue);
      const end = this.parseDate(this.rangeEndValue);
      if (!start) return null;
      return end ? `${this.formatDate(start)} – ${this.formatDate(end)}` : this.formatDate(start);
    }
    if (this.modeValue === "multiple") {
      return this.selectedDatesValue.map((d) => this.formatDate(this.parseDate(d))).join(", ");
    }
    const selected = this.selectedDate();
    return selected ? this.formatDate(selected) : null;
  }

  dispatchChange() {
    this.dispatch("change", {
      detail: {
        mode: this.modeValue,
        selected: this.selectedDateValue,
        selectedDates: this.selectedDatesValue,
        rangeStart: this.rangeStartValue,
        rangeEnd: this.rangeEndValue,
        formatted: this.formattedSelection(),
      },
    });
  }

  adjustMonth(adjustment) {
    const date = this.viewDate();
    date.setDate(2); // avoid month-length/timezone edges
    date.setMonth(date.getMonth() + adjustment);
    return date.toISOString().slice(0, 10);
  }

  updateCalendar() {
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = this.monthAndYear();
    }
    this.syncDropdowns();
    this.calendarTarget.innerHTML = this.calendarHTML();
  }

  syncDropdowns() {
    if (this.hasMonthSelectTarget) {
      this.monthSelectTarget.value = String(this.viewDate().getMonth());
    }
    if (this.hasYearSelectTarget) {
      this.yearSelectTarget.value = String(this.viewDate().getFullYear());
    }
  }

  calendarHTML() {
    return this.weekdaysTemplateTarget.innerHTML + this.calendarDays();
  }

  calendarDays() {
    return this.getFullWeeksStartAndEndInMonth()
      .map((week) => this.renderWeek(week))
      .join("");
  }

  renderWeek(week) {
    let cells = week.map((day) => this.renderDay(day)).join("");
    if (this.weekNumbersValue) {
      const weekNumber = this.isoWeekNumber(week[0]);
      cells = `<td class="pk-calendar-weeknumber" role="presentation">${weekNumber}</td>` + cells;
    }
    return `<tr class="pk-calendar-week">${cells}</tr>`;
  }

  renderDay(day) {
    const today = new Date();
    const iso = this.isoDate(day);
    const data = { day: iso, dayDate: day.getDate(), state: this.dayState(day) };

    if (this.isDateDisabled(day)) {
      return renderTemplate(this.disabledDateTemplateTarget.innerHTML, data);
    }
    if (this.isDaySelected(day)) {
      return renderTemplate(this.selectedDateTemplateTarget.innerHTML, data);
    }
    if (this.isDayInRange(day)) {
      // middle of a range: current-month look + the in-range state class
      return renderTemplate(this.currentMonthDateTemplateTarget.innerHTML, data);
    }
    if (day.toDateString() === today.toDateString()) {
      return renderTemplate(this.todayDateTemplateTarget.innerHTML, data);
    }
    if (day.getMonth() === this.viewDate().getMonth()) {
      return renderTemplate(this.currentMonthDateTemplateTarget.innerHTML, data);
    }
    return renderTemplate(this.otherMonthDateTemplateTarget.innerHTML, data);
  }

  // Extra state classes interpolated into the day templates ({{state}}).
  dayState(day) {
    const states = [];
    if (this.isBooked(day)) states.push("booked");
    if (this.modeValue === "range") {
      const start = this.parseDate(this.rangeStartValue);
      const end = this.parseDate(this.rangeEndValue);
      const isStart = start && day.toDateString() === start.toDateString();
      const isEnd = end && day.toDateString() === end.toDateString();
      if (isStart) states.push("range-start");
      if (isEnd) states.push("range-end");
      // caps only band with the accent once the range is complete
      if (start && end && (isStart || isEnd)) states.push("range-cap");
      if (this.isDayInRange(day)) states.push("in-range");
    }
    return states.join(" ");
  }

  isDaySelected(day) {
    if (this.modeValue === "range") {
      const start = this.parseDate(this.rangeStartValue);
      const end = this.parseDate(this.rangeEndValue);
      return (
        (start && day.toDateString() === start.toDateString()) ||
        (end && day.toDateString() === end.toDateString())
      );
    }
    if (this.modeValue === "multiple") {
      return this.selectedDatesValue.includes(this.isoDate(day));
    }
    const selectedDate = this.selectedDate();
    return selectedDate && day.toDateString() === selectedDate.toDateString();
  }

  isDayInRange(day) {
    if (this.modeValue !== "range") return false;
    const start = this.parseDate(this.rangeStartValue);
    const end = this.parseDate(this.rangeEndValue);
    if (!start || !end) return false;
    const candidate = this.startOfDay(day);
    return candidate > this.startOfDay(start) && candidate < this.startOfDay(end);
  }

  isBooked(day) {
    return this.disabledDatesValue.includes(this.isoDate(day));
  }

  monthAndYear() {
    const month = this.viewDate().toLocaleString("en-US", { month: "long" });
    const year = this.viewDate().getFullYear();
    return `${month} ${year}`;
  }

  selectedDate() {
    return this.parseDate(this.selectedDateValue);
  }

  viewDate() {
    return (
      this.parseDate(this.viewDateValue) || this.selectedDate() || new Date()
    );
  }

  getFullWeeksStartAndEndInMonth() {
    const month = this.viewDate().getMonth();
    const year = this.viewDate().getFullYear();

    let weeks = [],
      firstDate = new Date(year, month, 1),
      lastDate = new Date(year, month + 1, 0),
      numDays = lastDate.getDate();

    let start = 1;
    let end;
    if (firstDate.getDay() === 1) {
      end = 7;
    } else if (firstDate.getDay() === 0) {
      let preMonthEndDay = new Date(year, month, 0);
      start = preMonthEndDay.getDate() - 6 + 1;
      end = 1;
    } else {
      let preMonthEndDay = new Date(year, month, 0);
      start = preMonthEndDay.getDate() + 1 - firstDate.getDay() + 1;
      end = 7 - firstDate.getDay() + 1;
      weeks.push({
        start: start,
        end: end,
      });
      start = end + 1;
      end = end + 7;
    }
    while (start <= numDays) {
      weeks.push({
        start: start,
        end: end,
      });
      start = end + 1;
      end = end + 7;
      end = start === 1 && end === 8 ? 1 : end;
      if (end > numDays && start <= numDays) {
        end = end - numDays;
        weeks.push({
          start: start,
          end: end,
        });
        break;
      }
    }
    return weeks.map(({ start, end }, index) => {
      const sub = +(start > end && index === 0);
      return Array.from({ length: 7 }, (_, index) => {
        const date = new Date(year, month - sub, start + index);
        return date;
      });
    });
  }

  isoWeekNumber(date) {
    const target = new Date(Date.UTC(date.getFullYear(), date.getMonth(), date.getDate()));
    const dayNumber = target.getUTCDay() || 7;
    target.setUTCDate(target.getUTCDate() + 4 - dayNumber);
    const yearStart = new Date(Date.UTC(target.getUTCFullYear(), 0, 1));
    return Math.ceil(((target - yearStart) / 86400000 + 1) / 7);
  }

  isoDate(date) {
    const year = date.getFullYear();
    const month = ("0" + (date.getMonth() + 1)).slice(-2);
    const day = ("0" + date.getDate()).slice(-2);
    return `${year}-${month}-${day}`;
  }

  formatDate(date) {
    const format = this.formatValue;
    const day = date.getDate();
    const month = date.getMonth() + 1;
    const year = date.getFullYear();
    const hours = date.getHours();
    const minutes = date.getMinutes();
    const seconds = date.getSeconds();
    const dayOfWeek = date.toLocaleString("en-US", { weekday: "long" });
    const monthName = date.toLocaleString("en-US", { month: "long" });
    const daySuffix = this.getDaySuffix(day);

    const map = {
      yyyy: year,
      MM: ("0" + month).slice(-2),
      dd: ("0" + day).slice(-2),
      HH: ("0" + hours).slice(-2),
      mm: ("0" + minutes).slice(-2),
      ss: ("0" + seconds).slice(-2),
      EEEE: dayOfWeek,
      MMMM: monthName,
      do: day + daySuffix,
      PPPP: `${dayOfWeek}, ${monthName} ${day}${daySuffix}, ${year}`,
    };

    const formattedDate = format.replace(
      /yyyy|MM|dd|HH|mm|ss|EEEE|MMMM|do|PPPP/g,
      (matched) => map[matched],
    );
    return formattedDate;
  }

  getDaySuffix(day) {
    if (day > 3 && day < 21) return "th";
    switch (day % 10) {
      case 1:
        return "st";
      case 2:
        return "nd";
      case 3:
        return "rd";
      default:
        return "th";
    }
  }

  minDate() {
    return this.parseDate(this.minDateValue);
  }

  maxDate() {
    return this.parseDate(this.maxDateValue);
  }

  isDateDisabled(date) {
    const candidate = this.parseDate(date);
    if (!candidate) return false;

    const minDate = this.minDate();
    if (minDate && this.startOfDay(candidate) < this.startOfDay(minDate)) return true;

    const maxDate = this.maxDate();
    if (maxDate && this.startOfDay(candidate) > this.startOfDay(maxDate)) return true;

    return this.disabledDatesValue.includes(this.isoDate(candidate));
  }

  parseDate(value) {
    if (!value) return null;
    if (value instanceof Date) return new Date(value);

    const isoDate = value.toString().match(/^(\d{4})-(\d{2})-(\d{2})/);
    if (isoDate) {
      return new Date(
        Number(isoDate[1]),
        Number(isoDate[2]) - 1,
        Number(isoDate[3]),
      );
    }

    const date = new Date(value);
    return Number.isNaN(date.getTime()) ? null : date;
  }

  startOfDay(date) {
    const normalizedDate = new Date(date);
    normalizedDate.setHours(0, 0, 0, 0);
    return normalizedDate;
  }
}
