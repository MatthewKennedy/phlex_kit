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
    "prevButton",
    "nextButton",
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
    // Resolved lazily by viewDate() — a `new Date()` default here would be
    // frozen at module load (stale "today" in long-lived tabs) and
    // toISOString() is UTC (wrong day for non-UTC users near midnight).
    viewDate: { type: String, default: "" },
    format: { type: String, default: "yyyy-MM-dd" },
  };
  static outlets = ["phlex-kit--calendar-input"];

  // No initialize() render: Stimulus fires every value's `…ValueChanged`
  // callback once during value initialization (before connect()), so
  // viewDateValueChanged already performs the initial updateCalendar().

  nextMonth(e) {
    e.preventDefault();
    this.viewDateValue = this.clampViewIso(this.adjustMonth(1));
  }

  prevMonth(e) {
    e.preventDefault();
    this.viewDateValue = this.clampViewIso(this.adjustMonth(-1));
  }

  // month/year dropdown caption (native selects)
  setMonth(e) {
    const date = this.viewDate();
    date.setDate(2);
    date.setMonth(Number(e.target.value));
    this.viewDateValue = this.clampViewIso(this.isoDate(date));
  }

  setYear(e) {
    const date = this.viewDate();
    date.setDate(2);
    date.setFullYear(Number(e.target.value));
    this.viewDateValue = this.clampViewIso(this.isoDate(date));
  }

  // --- month-navigation bounds (min/max dates + the year dropdown's range) ---

  // Earliest/latest navigable months. min/max dates bound directly; a year
  // dropdown additionally bounds the view to its option range (from_year /
  // to_year) so navigation can't drive the select out of range (blank).
  monthBounds() {
    let min = this.minDate();
    let max = this.maxDate();
    if (this.hasYearSelectTarget) {
      const years = [...this.yearSelectTarget.options].map((o) => Number(o.value)).filter(Number.isFinite);
      if (years.length) {
        const yearMin = new Date(Math.min(...years), 0, 1);
        const yearMax = new Date(Math.max(...years), 11, 31);
        if (!min || yearMin > min) min = yearMin;
        if (!max || yearMax < max) max = yearMax;
      }
    }
    return { min, max };
  }

  monthIndexOf(date) {
    return date.getFullYear() * 12 + date.getMonth();
  }

  clampViewIso(iso) {
    const date = this.parseDate(iso);
    if (!date) return iso;
    const { min, max } = this.monthBounds();
    if (min && this.monthIndexOf(date) < this.monthIndexOf(min)) {
      return this.isoDate(new Date(min.getFullYear(), min.getMonth(), 2));
    }
    if (max && this.monthIndexOf(date) > this.monthIndexOf(max)) {
      return this.isoDate(new Date(max.getFullYear(), max.getMonth(), 2));
    }
    return iso;
  }

  syncNavButtons() {
    const { min, max } = this.monthBounds();
    const view = this.monthIndexOf(this.viewDate());
    if (this.hasPrevButtonTarget) {
      this.prevButtonTarget.disabled = Boolean(min && view <= this.monthIndexOf(min));
    }
    if (this.hasNextButtonTarget) {
      this.nextButtonTarget.disabled = Boolean(max && view >= this.monthIndexOf(max));
    }
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
    // Normalized copy: server-supplied entries may be datetime strings
    // (Time#to_s) — indexOf against the bare isoDate must still match.
    const current = this.normalizeDates(this.selectedDatesValue);
    const index = current.indexOf(day);
    if (index >= 0) {
      current.splice(index, 1);
    } else {
      current.push(day);
      current.sort();
    }
    this.selectedDatesValue = current;
    this.updateCalendar();
    this.pushToOutlets();
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
    this.viewDateValue = this.isoDate(newViewDate);

    this.updateCalendar();

    // Stimulus fires valueChanged during value initialization too — a
    // server-rendered selected_date must not dispatch a change event.
    if (prevValue === undefined) return;
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
      // Deselecting the last date must clear the bound input: return ""
      // (pushed to outlets), not null (skipped by pushToOutlets' guard).
      if (!this.selectedDatesValue.length) return "";
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
    return this.isoDate(date);
  }

  updateCalendar() {
    if (this.hasTitleTarget) {
      this.titleTarget.textContent = this.monthAndYear();
    }
    this.syncDropdowns();
    this.syncNavButtons();
    // innerHTML replacement drops focus — remember the focused day so
    // keyboard selection/month hops don't strand focus on <body>.
    const focusedDay = this.calendarTarget.contains(document.activeElement)
      ? document.activeElement.dataset?.day
      : null;
    this.calendarTarget.innerHTML = this.calendarHTML();
    this.ensureGridTabStop(focusedDay);
  }

  // Roving tabindex: exactly one day button is tabbable — the previously
  // focused day (refocused across re-renders), else the selected day (its
  // template ships tabindex="0"), else today, else the first enabled day of
  // the current month. Without this, a calendar with no selection has no
  // keyboard entry point at all.
  ensureGridTabStop(focusedDay) {
    const days = [...this.calendarTarget.querySelectorAll(".pk-calendar-day:not([disabled])")];
    if (!days.length) return;
    const focused = focusedDay ? days.find((d) => d.dataset.day === focusedDay) : null;
    const stop =
      focused ||
      days.find((d) => d.getAttribute("tabindex") === "0") ||
      days.find((d) => d.classList.contains("today")) ||
      days.find((d) => !d.classList.contains("other")) ||
      days[0];
    days.forEach((d) => d.setAttribute("tabindex", d === stop ? "0" : "-1"));
    if (focused) stop.focus({ preventScroll: true });
  }

  // Arrow keys move by day/week, PageUp/PageDown by month (Shift: by year,
  // per APG), Home/End jump within the rendered week row; crossing a month
  // boundary re-renders the grid on the target month. Enter/Space activate
  // natively (the days are real <button>s).
  onKeydown(e) {
    const STEPS = { ArrowLeft: -1, ArrowRight: 1, ArrowUp: -7, ArrowDown: 7 };
    const day = e.target.closest?.("[data-day]");
    if (!day) return;

    let target;
    if (e.key in STEPS) {
      target = this.parseDate(day.dataset.day);
      target.setDate(target.getDate() + STEPS[e.key]);
    } else if (e.key === "PageUp" || e.key === "PageDown") {
      const base = this.parseDate(day.dataset.day);
      const months = (e.key === "PageUp" ? -1 : 1) * (e.shiftKey ? 12 : 1);
      target = new Date(base.getFullYear(), base.getMonth() + months, 1);
      // land on the same day-of-month, clamped to the target month's length
      const lastDay = new Date(target.getFullYear(), target.getMonth() + 1, 0).getDate();
      target.setDate(Math.min(base.getDate(), lastDay));
    } else if (e.key === "Home" || e.key === "End") {
      const rowDays = [...day.closest("tr").querySelectorAll("[data-day]")];
      target = this.parseDate(rowDays[e.key === "Home" ? 0 : rowDays.length - 1].dataset.day);
    } else {
      return;
    }
    e.preventDefault();

    let iso = this.isoDate(target);
    if (this.isDateDisabled(iso)) {
      // A min/max boundary holds focus in place; an isolated booked date is
      // SKIPPED in the travel direction (APG date-grid) — arrows only, the
      // month/row jumps (PageUp/Home/End) still stay put.
      if (!(e.key in STEPS) || this.outOfRange(target)) return;
      do {
        target.setDate(target.getDate() + STEPS[e.key]);
        if (this.outOfRange(target)) return;
      } while (this.isBooked(target));
      iso = this.isoDate(target);
    }

    if (target.getMonth() !== this.viewDate().getMonth() || target.getFullYear() !== this.viewDate().getFullYear()) {
      this.viewDateValue = iso; // re-renders the grid on the target month
    }
    const next = this.calendarTarget.querySelector(`[data-day="${iso}"]:not([disabled])`);
    if (!next) return;
    this.calendarTarget.querySelectorAll(".pk-calendar-day").forEach((d) => {
      d.setAttribute("tabindex", d === next ? "0" : "-1");
    });
    next.focus({ preventScroll: true });
  }

  syncDropdowns() {
    if (this.hasMonthSelectTarget) {
      this.monthSelectTarget.value = String(this.viewDate().getMonth());
    }
    if (this.hasYearSelectTarget) {
      const select = this.yearSelectTarget;
      const year = this.viewDate().getFullYear();
      select.value = String(year);
      if (select.selectedIndex === -1 && select.options.length) {
        // view year outside the option range — clamp to the nearest end
        // instead of leaving the select blank
        const years = [...select.options].map((o) => Number(o.value));
        select.value = String(year < Math.min(...years) ? Math.min(...years) : Math.max(...years));
      }
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
      cells = `<td class="pk-calendar-weeknumber" role="rowheader">${weekNumber}</td>` + cells;
    }
    return `<tr class="pk-calendar-week" role="row">${cells}</tr>`;
  }

  renderDay(day) {
    const today = new Date();
    const iso = this.isoDate(day);
    const data = {
      day: iso,
      dayDate: day.getDate(),
      // full human-readable date for the button's accessible name — a bare
      // day number ("14") is meaningless to a screen reader
      dayLabel: day.toLocaleDateString("en-US", { weekday: "long", month: "long", day: "numeric", year: "numeric" }),
      state: this.dayState(day),
    };

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
      return this.normalizeDates(this.selectedDatesValue).includes(this.isoDate(day));
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
    return this.normalizeDates(this.disabledDatesValue).includes(this.isoDate(day));
  }

  // disabled_dates / selected_dates entries may be Time#to_s or datetime ISO
  // strings — every other date input tolerates those via parseDate, so the
  // membership arrays must be normalized the same way (exact string equality
  // silently no-oped for anything but bare yyyy-MM-dd).
  normalizeDates(values) {
    return values
      .map((d) => { const parsed = this.parseDate(d); return parsed ? this.isoDate(parsed) : null; })
      .filter(Boolean);
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

    // Longest tokens first: MMMM must precede MM or the alternation eats
    // "MMMM" as two "MM"s and renders the month number twice.
    const formattedDate = format.replace(
      /yyyy|MMMM|MM|dd|HH|mm|ss|EEEE|PPPP|do/g,
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
    return this.outOfRange(candidate) || this.isBooked(candidate);
  }

  // min/max bounds only (not booked entries) — the keyboard skip needs to
  // distinguish a hard boundary from a hole in the middle of the grid.
  outOfRange(candidate) {
    const minDate = this.minDate();
    if (minDate && this.startOfDay(candidate) < this.startOfDay(minDate)) return true;
    const maxDate = this.maxDate();
    return !!(maxDate && this.startOfDay(candidate) > this.startOfDay(maxDate));
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
