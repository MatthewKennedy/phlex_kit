# shadcn/ui page-parity checklist

Worked with the `shadcn-parity` skill (read it first — it carries the flow +
established conventions): audit from the LOCAL shadcn checkout at
`~/Developer/ui` (nova style), upgrade the kit where shadcn moved past
ruby_ui, recreate their examples in the docs site, verify, check off. A page
is done when its examples match, its API surface matches (parts/props), and
its metrics have been compared. One commit per page; suite must stay green
(`bundle exec rake test`); verify each page renders on the dummy app
(`bundle exec puma -p 3999 test/dummy/config.ru`, slugs are dasherized).
Everything unchecked below is a DEDICATED SESSION — ready-to-paste prompts at
the bottom of this file.

## Components (ui.shadcn.com/docs/components/radix/…)

- [x] accordion — added type: :single (shadcn default, closes siblings)/:multiple, disabled items, bordered modifier; five examples
- [x] alert — added AlertAction, icon-grid layout (`:has(> svg)`), role="alert", title h5→div, text-tint variants on card surface (shadcn dropped tinted fills; success/warning kept as kit extras), link underlines; four examples incl. light-dark() custom colors
- [x] alert-dialog — added AlertDialogMedia, size: :sm, action variants, footer band, centered media stack
- [x] aspect-ratio — square + portrait examples (component already at parity)
- [x] attachment — states/sizes/orientation, media variants, AttachmentTrigger, AttachmentGroup + horizontal scroll-fade
- [x] avatar — added AvatarBadge + AvatarGroupCount, ::after hairline border (mix-blend darken/lighten per theme — first theme-scoped component CSS), un-clipped root so badges overhang (image/fallback round themselves), fallback muted-fg, group :has() count sizing; eight examples
- [x] badge — restyled to the solid pill spec (h-5, full-round, solid primary; old tinted-ring look dropped), added ghost/link variants, href: renders <a> (their asChild) with link-only hover fills, data-icon inline-start/end padding insets, focus ring, dark/light destructive tint split; five examples + kit-extras demo
- [x] breadcrumb — structure already at parity; metric fixes (item gap 1.5→1, ellipsis box 2.25rem→size-5) and their four examples (Basic, Custom separator w/ block dot, Dropdown, Collapsed). "Link component" page section is React-router-specific (our BreadcrumbLink takes href natively) — skipped like RTL
- [x] bubble — content metrics to rounded-xl/px-3/py-2, interactive content (button/a) hover fills + focus ring per variant, tinted rebuilt on relative-oklch with dark/light lightness pins, destructive 10/20 theme split, ghost full-width, reactions :has(button) p-0, Message-align passthrough; eight examples
- [x] button — added xs size (+ icon-xs/sm/lg squares via icon:), href: renders <a> (their asChild), destructive restyled solid-red→tinted (10/20 theme split), outline theme-forked (translucent input fill dark / bordered light), hover fills to /80 + oklch secondary mix, active translate-y nudge (not aria-haspopup), aria-expanded held states, per-size radius caps, data-icon insets, svg-4 defaults; their twelve examples (Button Group → own page)
- [x] button-group — added orientation: :vertical, ButtonGroupText + ButtonGroupSeparator parts, nested-group gap via :has(), inner-corner-only squaring (children keep their own outer radius — old version forced var(--pk-radius)), input flex-1; nine examples (Input Group example folded into Nested pending that page's audit)
- [x] calendar — controller extended to mode: :single/:range/:multiple (range paints a contiguous accent band via range-start/in-range/range-end/range-cap {{state}} hooks on the SAME five templates), min/max + disabled_dates (struck-through "booked"), ISO week numbers column, caption_layout: :dropdown (native month/year selects the controller syncs — no JS lib), --pk-cell-size/--pk-cell-radius sizing vars, outlet pushes "start – end" for ranges + a phlex-kit--calendar:change event; nine examples. Hijri/locales out of scope
- [x] card — CardAction, size: :sm, --pk-card-spacing, footer band, image cards; five examples
- [x] carousel — translate engine already at functional parity (arrows, drag, loop, axis, disabled state; nova only adds rounded-full nav which we had); recreated their Sizes/Spacing/Orientation examples with Card slides. Options/API/Events/Plugins sections are embla-React-specific — documented, not ported
- [ ] chart — AUDITED 2026-07-05: their page is a Recharts build-a-chart tutorial (grid/axis/tooltip/legend steps + ChartConfig theming), not an example gallery. Port = extend docs/06-CHARTS.md guide + step examples on Chart.js options. Own session; kit chart block itself is live (area/bar/doughnut)
- [x] checkbox — replaced native accent-color box ("redesign later" debt) with their custom-drawn control: appearance:none, input-border + translucent dark fill, brand fill + masked check when checked, :indeterminate minus, extended touch target (::before bleed), focus + aria-invalid rings; six examples incl. Table
- [x] collapsible — controller now stamps data-state=open/closed on the root (their styling hook) + .pk-collapsible-chevron rotation helper (--pk-collapsible-rotate override, scoped to nearest root for nesting); their three examples (Basic, Settings Panel, recursive File Tree)
- [x] combobox — controller diff vs the rebuilt upstream API found two real gaps, both closed: auto_highlight: (first visible match stays marked while typing, Enter picks it) and invalid:/disabled: states on the input trigger; triggers restyled to the form-control grammar (translucent dark fill + hover step, ring focus was brand, invalid rings w/ theme split). Everything else already existed (chips=BadgeTrigger, clear, groups, popup=button+search, keyboard nav, toggle-all). Their ten example sections + the kit's toggle-all demo
- [x] command — search field restyled to their bordered pill inside a padded rounded-xl palette (was full-width divider row), added CommandShortcut + CommandSeparator (separator hides while filtering, like cmdk; replaces the old divide-y group borders), selected rows fill muted, list max-h-72 with hidden scrollbar; five examples incl. Scrollable + the ⌘K dialog
- [x] context-menu — mirrored the dropdown-menu part family (Group/Shortcut/CheckboxItem/RadioGroup+Item/Sub trio, destructive variant), items restyled from forced-2rem-inset to the gap grammar (.inset modifier kept), content overflow:visible so submenus can escape; their eight examples
- [x] data-table — their tanstack tutorial's END STATE recreated as one rich payments example on the kit's server-driven data_table (row-selection column, sortable email, right-aligned tabular amounts, per-row actions dropdown, filter input, column-visibility toggle, selection summary + pagination), with the tutorial steps narrated as Code-tab comments; zero controller changes needed. Column defs/tanstack API are React-specific by design
- [x] date-picker — unblocked by the calendar rebuild; DatePicker's calendar_attrs passthrough composes every new mode (Range writes "start – end" into the bound input, Date of Birth uses the dropdown caption + max_date, Time pairs a Field time input); four examples. "Input"/"Natural Language" sections are text-parsing (chrono-node) — out of scope
- [x] dialog — fixed the footer band's undefined --pk-dialog-spacing (only alert-dialog defined it — margins silently no-op'd), respec'd to nova: 24rem default width (their max-w-sm) with viewport clamp + retuned size ladder, foreground-tint ring border, rounded-xl, p-4/gap-4/text-sm, title text-base/medium, close at top-2/right-2, description link styling; added show_close_button: + DialogClose part. Overlay kept at the kit-unified 0.5/8px — nova moved to black/10+blur-xs, change all overlays (dialog/alert-dialog/sheet/command) together as a follow-up. Five examples
- [x] drawer — added side: :top/:left/:right to DrawerContent (their direction prop; edge-attached rounding/border + per-side slide animations), nova metrics (title base/medium, header gap-0.5, text-sm body), handle hidden by default like nova's .cn-drawer-handle (re-show via CSS); Scrollable Content + Sides examples. "Responsive Dialog" is a React media-query component swap — documented, not ported
- [x] dropdown-menu — Group/Shortcut/CheckboxItem/RadioGroup+Item/Sub family, destructive items; seven examples
- [x] empty — nova metrics: borderless by default (dashed border now opt-in via `.outline` — their base sets only border-STYLE), rounded-xl (was 1.5rem), p-6 (was 3rem), title 1.125rem→text-sm/medium, icon chip 2.5→2rem w/ svg-4, content gap-2.5; their six examples (Default, Outline, Background, Avatar, Avatar Group, InputGroup)
- [x] field — full part vocabulary shipped (FieldSet/FieldLegend legend|label/FieldGroup container/Field vertical|horizontal|responsive w/ invalid+disabled/FieldContent/FieldLabel/FieldTitle/FieldDescription/FieldSeparator w/ riding text/FieldError w/ dedup+list). Field = presentational layout; FormField stays the Stimulus validation wrapper (they nest). Choice-card via FieldLabel:has(input:checked). Responsive = container query on FieldGroup ≥28rem. Thirteen examples; stubbed examples across checkbox/input/dialog/radio-group/switch/progress/collapsible/button-group reworked onto the real parts
- [x] hover-card — added side: :top/:left/:right on content (their side prop, CSS-positioned), nova metrics (p-2.5 was 1rem, rounded-lg, text-sm, foreground-tint ring); Basic + Sides examples. Trigger-delay knobs are Radix props — controller uses its own fixed delays
- [x] input — nova respec: focus ring on --pk-ring (was brand), theme-forked fill (input/30 dark, transparent light), tinted disabled fill, invalid ring 20/40 split, styled file-selector button, text-base→md:text-sm (iOS zoom guard); eight examples (Field compositions stubbed with FormField pending the field audit)
- [x] input-group — added block_start/block_end addon aligns (group stacks to a column, full-width header/footer rows w/ .bordered rule) + InputGroupButton part (ghost-xs Button tuned flush), shell respec'd: fixed h-8 (auto w/ textarea or block addon), ring-colored focus (was brand), :has() invalid/disabled lift, theme-forked fill, textarea collapse, control padding tightened beside inline addons, addon button/kbd negative margins; eleven examples. "Custom Input" section is a Tailwind-restyle recipe — skipped
- [x] input-otp — nova metrics: size-8 slots (was 2.25rem), ring-colored focus (was brand), aria-invalid slot/group states w/ 20/40 split, theme-forked fill, disabled opacity; six examples (Controlled/Form are React-state/RHF — skipped)
- [x] item — added size: sm/xs, ItemMedia variants (:icon/:image square thumbs sized by item size), ItemSeparator/ItemHeader/ItemFooter parts (header/footer stack the item into a column), href: link items with hover fill, media self-start nudge beside descriptions, nova metrics (content gap-1, muted at 50%, group gap-4 w/ :has() size steps); nine examples
- [x] kbd — already at parity bar two nova rules: svg-3 glyphs + background-tint restyle inside (inverted) tooltip content (10/20 dark/light); their five examples (Default, Group, Button, Tooltip, Input Group)
- [x] label — already at parity (their page has no Examples section; "Label in Field" belongs to the field audit); demo updated to their checkbox-pair copy
- [x] marker — border variant fixed full-box→bottom-border-only (their border-b pb-2), separator content flex-none/centered, interactive markers (href:/as: :button) with underline+hover brighten, min-h to 1rem; their seven examples (Status w/ Spinner, Shimmer on .pk-shimmer)
- [x] menubar — mirrored the full menu family (Group/Label/Shortcut/CheckboxItem/RadioGroup+Item/Sub trio, destructive + inset items), nova metrics (h-8 bar w/ 3px padding, tight px-1.5 triggers on muted hover, min-w-36 ring-bordered panels, rounded-md rows); five examples incl. the big four-menu demo
- [x] message — two nova rules added (avatar rises 2rem above a footer row; header/footer lose their inset beside ghost bubbles), structure already at parity; their five examples (Avatar, Group, Header and Footer, Actions, Attachment) + kept Conversation demo
- [ ] message-scroller — AUDITED 2026-07-05 (scope only): their page is a streaming-chat behavior doc with 11 large stateful React demos (anchoring modes, streaming, load-history, visibility). Kit controller exists (11.8KB); parity = behavior verification + simulated-stream demos. Own session
- [x] native-select — nova respec mirroring input: rounded-lg (was r-2px), translucent dark fill w/ hover step (transparent light), ring focus (was brand), aria-invalid states w/ 20/40 split, sm radius cap; four examples
- [x] navigation-menu — metric fixes only (structure at parity): triggers/links to rounded-lg px-2.5 py-1.5 on MUTED hovers (was accent) w/ half-fill open state, panel ring-bordered p-1, in-panel links rounded-md, svg-4. Page has no Examples section; Link Component is router-specific
- [x] pagination — added PaginationLink (square ghost/outline-active) + PaginationPrevious/Next (chevron + sm-hidden label, near-side trim) matching their part API (PaginationItem kept as the combined back-compat part), content gap-0.5, ellipsis size-8; three examples (Default, Simple, Icons Only w/ rows-per-page Select)
- [x] popover — added PopoverHeader/Title/Description parts + align: :end on content (their align prop), panel respec'd to nova (w-72, p-2.5 gap-2.5 column, rounded-lg, foreground-tint ring, text-sm); three examples; bubble + button-group examples retrofitted onto the real parts
- [x] progress — nova metrics: h-1 (was h-2), muted track (was brand/20); Default + Label examples (their Controlled is React state)
- [x] radio-group — RadioButton rebuilt custom-drawn (same recipe as the checkbox respec: appearance:none, input border + translucent dark fill, brand fill + fg dot when checked, touch bleed, focus/invalid rings, theme forks), group gap-3→gap-2; six examples (Default, Description, Choice Card, Fieldset, Disabled, Invalid)
- [x] resizable — added with_handle: grip pill (their withHandle / .cn-resizable-handle-icon, rotates with vertical groups); engine already at parity; their three examples incl. the nested demo
- [x] scroll-area — native-scroll implementation already at parity (thin themed scrollbars ≈ their 2.5-wide rounded thumbs); their two examples (Tags list w/ separators, Horizontal artwork strip)
- [x] select — trigger respec'd to the input grammar (translucent dark fill + hover step, ring focus was brand, invalid states, gap-1.5 pl-2.5/pr-2, size: :sm w/ radius cap), check indicator moved to the RIGHT (their right-2 absolute; was left), item pr-8 rounded-md, label to text-xs muted, viewport ring + rounded-lg, new SelectSeparator part; five examples. "Align Item With Trigger" is Radix item-aligned positioning — skipped
- [x] separator — already at parity; their four examples (Default, Vertical, Menu, List)
- [x] sheet — panel respec'd to nova: NO panel padding (header/footer bring p-4, body px-4 via SheetMiddle), gap-0.5 header, title text-base/medium, close top-3/right-3, side panels 75%/max-w-sm; added show_close_button: + SheetClose wrapper; three examples. Overlay stays kit-unified
- [ ] sidebar — offcanvas + static parts done (see PR #19); REMAINING for a dedicated session: collapsible: :icon rail mode, cookie persistence, SidebarRail part, keyboard shortcut — offcanvas-scale build
- [x] skeleton — fill fixed brand-tint→muted surface (their bg-muted); their five examples (Avatar, Card, Text, Form, Table)
- [x] slider — nova metrics on the native range: h-1 track (was 1.5), size-3 white thumb on the ring border (was brand-bordered 1rem) w/ hover/active rings, vertical via writing-mode (.vertical, min-h-40); three examples. Range/Multiple-thumbs are Radix multi-thumb — native input is single-thumb, documented
- [x] sonner (maps to our toast) — audited with toast: the Stimulus toaster already covers their Types/Description/Position/promise API; docs recreated from the sonner page
- [x] spinner — already at parity (loader icon + spin); Size/Button/Badge examples (Input Group + Empty compositions live on those pages)
- [x] switch — respec'd to nova geometry (32×18.4px track / 24×14 sm, size-4 thumb sliding calc(100%-2px)), input-tone unchecked fill, theme-aware thumb (bg in light, fg/brand-ink in dark), size: :sm, focus + invalid rings, real hidden input (was display:none); six examples
- [x] table — metric fixes: heads to text-foreground (were muted) + whitespace-nowrap, footer gains the muted/50 fill, row hover to /50 + data-[state=selected] fill, checkbox-column pr-0; Footer + Actions examples added
- [x] tabs — added variant: :line (transparent list + animated underline; moves to the right edge when vertical) and orientation: :vertical on the root, nova metrics (h-8 list w/ 3px padding, px-1.5 triggers, dark active = translucent input fill + input border vs light bg-background, hover brighten, focus ring, data-icon insets); five examples
- [x] textarea — same nova respec as input (rounded-lg, translucent dark fill, ring focus, invalid/disabled fills, iOS-zoom text-base→md:text-sm); four examples
- [x] toast — toaster already at functional parity (types incl. loading/promise, positions, description); nova's rounded-2xl applied; four examples from the sonner page (their /toast page just redirects to sonner)
- [x] toggle — nova metrics: h-8/7/9 (was 9/8/10), rounded-lg w/ sm cap, gap-1 px-2.5, muted hover + on fills (was accent-hover w/ muted text), focus ring, outline uses input border, data-icon insets, svg 4/3.5; five examples
- [x] toggle-group — group radius to rounded-lg (items inherit via first/last overrides), joined items tighten to px-2; six examples on the real yield-API (Outline, Size, Spacing, Vertical, Disabled)
- [x] tooltip — INVERTED to their foreground-bg/background-text surface (was surface-2 bordered) with the rotated-square arrow, side: :bottom/:left/:right, nova metrics (rounded-md, px-3 py-1.5, text-xs, kbd gap + pr trim — kbd.css tint now lines up); four examples
- [x] typography — fixed never-applied heading sizes; full prose specimen (h1–h4, list, table, lead/large/small/muted)

## Utilities (ui.shadcn.com/docs/utils/…)

- [x] scroll-fade — horizontal mode promoted from attachment-scoped CSS to a generic `.pk-scroll-fade.horizontal` variant; fade size via the --pk-scroll-fade-size knob (their scroll-fade-N classes); Default/Horizontal/Fade Size examples. No-overflow-no-fade already handled by the controller's both-flags state
- [x] shimmer — currentColor highlight sweep, custom-property knobs, once/reverse, reduced-motion, fallback

## Out of scope

- direction — React RTL context provider; handled as README documentation
- forms (react-hook-form / tanstack / formisch) — React-specific integrations
- PhlexKit-only pages with no upstream counterpart (audit N/A): link,
  masked-input, clipboard, codeblock, shortcut-key, theme-toggle

## Dedicated-session prompts

Paste one of these to start its session. Each assumes: read
`.claude/skills/shadcn-parity/SKILL.md` first, work from the local checkout
at `~/Developer/ui`, one commit per logical step, suite green before every
commit, check off the PARITY.md line with an audit note when done.

### field

> Using the shadcn-parity skill, build the Field system to parity with
> ui.shadcn.com's field page. Source: `~/Developer/ui/apps/v4/registry/bases/radix/ui/field.tsx`
> + `style-nova.css` `.cn-field*` + `examples/radix/field-*.tsx` (13 examples).
> Add the full part vocabulary as new `field/` components (FieldSet,
> FieldLegend (variant: :legend/:label), FieldGroup, Field (orientation:
> :vertical/:horizontal/:responsive), FieldContent, FieldLabel, FieldTitle,
> FieldDescription, FieldError, FieldSeparator) — keep the existing
> form/form_field live-validation trio untouched; Field is presentational
> layout, FormField stays the Stimulus validation wrapper (document how they
> compose). Include the choice-card recipe (bordered label Field wrapping
> checkbox/radio/switch). AFTERWARDS: rework the examples that stubbed Field
> with ad-hoc rows — checkbox (Basic/Description/Group), input
> (Disabled/Invalid/File/Grid/Required/Badge), dialog demo, radio-group
> (Description/Choice Card/Fieldset), switch (Description/Choice Card),
> progress Label, collapsible Settings Panel, button-group Popover — onto the
> real Field parts.

### calendar

> Using the shadcn-parity skill, rebuild Calendar to parity with
> ui.shadcn.com's calendar page (audit note dated 2026-07-05 on the PARITY
> line). This is a Stimulus build ≈ sidebar-offcanvas scale: extend
> `calendar_controller.js` with mode: single (current) / range / multiple
> selection, month+year dropdown caption (their captionLayout), week numbers,
> booked/disabled dates (matcher list passed as a value), and the
> --pk-cell-size/--pk-cell-radius variable system from nova's `.cn-calendar*`.
> Source: `registry/bases/radix/ui/calendar.tsx` (react-day-picker wrapper —
> mirror behavior, not code) + `examples/radix/calendar-*.tsx` (8 examples:
> basic, range, month/year selector, presets, date+time, booked dates, custom
> cell size, week numbers; hijri is out of scope). Keep the
> phlex-kit--calendar-input outlet contract (DatePicker depends on it). Range
> mode needs range-start/range-end/in-range day states in CSS. Tests for the
> new day-state templates; examples with their copy.

### date-picker (after calendar)

> Using the shadcn-parity skill, bring DatePicker to parity with
> ui.shadcn.com's date-picker page. Requires the calendar rebuild (range +
> presets modes) — verify those exist first. Their page is compositions:
> simple picker, date range picker, with presets (Select + Calendar in a
> Popover), form field composition. Source: `examples/radix/date-picker-*.tsx`.
> Mostly docs-site examples + any glue the compositions expose as missing
> (e.g. range wired into two Inputs).

### combobox

> Using the shadcn-parity skill, bring Combobox to parity with
> ui.shadcn.com's combobox page (rebuilt upstream API — audit note dated
> 2026-07-05). Source: `registry/bases/radix/ui/combobox.tsx` +
> `style-nova.css` `.cn-combobox*` + `examples/radix/combobox-*.tsx` (10
> sections: Basic, Multiple, Clear Button, Groups, Custom Items, Invalid,
> Disabled, Auto Highlight, Popup, Input Group). Kit already has
> combobox_controller.js (300 lines) with badge/input triggers — diff its
> behavior against theirs (multiple-selection chips, clear button, auto
> highlight first match, open-on-focus popup mode) and extend. Restyle to the
> form-control grammar (see skill §1b). Their Chips example maps to the
> existing ComboboxBadgeTrigger — verify, don't duplicate.

### data-table

> Using the shadcn-parity skill, bring the data-table docs to parity with
> ui.shadcn.com's data-table page. Their page is a tanstack-table BUILD
> TUTORIAL (columns → sorting → filtering → visibility → pagination → row
> selection), not an example gallery. The kit has its own `data_table`
> (Stimulus sort/filter/paginate). Recreate the tutorial's END STATE as one
> rich docs example (payments table: checkbox row-selection column, sortable
> email header, amount column right-aligned, actions dropdown, filter input,
> column-visibility dropdown, pagination footer) using kit parts, and write
> the intermediate steps as docs prose (Code-tab comments), not separate
> examples. Extend the controller only where the end state needs it (e.g.
> column visibility toggling).

### chart

> Using the shadcn-parity skill, port ui.shadcn.com's chart page to the
> kit's Chart.js block. Their page is a Recharts tutorial: Your First Chart →
> Add a Grid → Add an Axis → Add Tooltip → Add Legend → Chart Config →
> Theming. Recreate each tutorial step as a docs example driven by Chart.js
> options (grid: scales.grid, axis: scales.x/y ticks, tooltip/legend:
> plugins), reusing the --pk-chart-1..5 tokens, and extend
> `docs/06-CHARTS.md` with the step-by-step guide. No new controller work
> expected — the chart block + host-supplied window.Chart pattern stays.

### message-scroller

> Using the shadcn-parity skill, verify MessageScroller against
> ui.shadcn.com's message-scroller page (a streaming-chat BEHAVIOR doc — 11
> stateful React demos). The kit controller exists (11.8KB). Diff its
> behavior against their documented concepts: anchoring turns (anchor the
> latest user turn to the top), opening position, following the live edge
> while streaming, load-history preserving scroll position, keeping context
> visible, scroll-to-bottom affordance. Build 3-4 docs examples that
> simulate streaming with a small inline Stimulus controller or setInterval
> script (their Commands/GroupChat demos), and fix any controller gaps the
> diff finds. This is verification-first: read their mdx concepts section
> closely before touching code.

### sidebar (icon rail)

> Using the shadcn-parity skill, finish the Sidebar audit (offcanvas mode
> shipped in PR #19). Remaining per the PARITY note: `collapsible: :icon`
> rail mode (sidebar collapses to an icon strip — labels hide, menu buttons
> become icon squares, tooltips show labels, groups collapse), cookie
> persistence of the collapsed state (their sidebar_state cookie, read
> server-side to avoid flash), the SidebarRail grab-strip part, and the ⌘B
> keyboard shortcut. Source: `registry/bases/radix/ui/sidebar.tsx` (big) +
> `style-nova.css` `.cn-sidebar*`. Extend the existing phlex-kit--sidebar
> controller + SidebarWrapper API (collapsible: :offcanvas | :icon | :none);
> keep DOM-only state + the scrim/Escape/turbo:before-cache behaviors.
> Audit the full page top-to-bottom afterwards and check the line off.

### unified overlay pass (small)

> One-pass overlay change across the kit: nova's overlays are now
> `bg-black/10` + `backdrop-blur-xs` (with a supports-backdrop-filter guard)
> — the kit is unified at rgb(0 0 0/.5) + blur(8px). Change dialog
> (::backdrop), alert-dialog, sheet, drawer, command overlays TOGETHER, add
> an @supports fallback that darkens to /50 when backdrop-filter is
> unavailable, and spot-check every overlay page in both themes. Update the
> PARITY dialog-line note when done.
