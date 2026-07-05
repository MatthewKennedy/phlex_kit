# shadcn/ui page-parity checklist

Worked with the `shadcn-parity` skill: audit the live page, upgrade the kit
where shadcn moved past ruby_ui, recreate their examples in the docs site,
verify, check off. A page is done when its examples match, its API surface
matches (parts/props), and its metrics have been compared.

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
- [ ] calendar — AUDITED 2026-07-05, needs a dedicated session: kit is single-date only; theirs adds range + multiple modes, month/year dropdown caption, week numbers, booked/disabled dates, --cell-size/--cell-radius vars, presets/time-picker compositions (8 examples). Controller build ≈ sidebar-offcanvas scale
- [x] card — CardAction, size: :sm, --pk-card-spacing, footer band, image cards; five examples
- [x] carousel — translate engine already at functional parity (arrows, drag, loop, axis, disabled state; nova only adds rounded-full nav which we had); recreated their Sizes/Spacing/Orientation examples with Card slides. Options/API/Events/Plugins sections are embla-React-specific — documented, not ported
- [ ] chart — AUDITED 2026-07-05: their page is a Recharts build-a-chart tutorial (grid/axis/tooltip/legend steps + ChartConfig theming), not an example gallery. Port = extend docs/06-CHARTS.md guide + step examples on Chart.js options. Own session; kit chart block itself is live (area/bar/doughnut)
- [x] checkbox — replaced native accent-color box ("redesign later" debt) with their custom-drawn control: appearance:none, input-border + translucent dark fill, brand fill + masked check when checked, :indeterminate minus, extended touch target (::before bleed), focus + aria-invalid rings; six examples incl. Table
- [x] collapsible — controller now stamps data-state=open/closed on the root (their styling hook) + .pk-collapsible-chevron rotation helper (--pk-collapsible-rotate override, scoped to nearest root for nesting); their three examples (Basic, Settings Panel, recursive File Tree)
- [ ] combobox — AUDITED 2026-07-05 (scope only): their page now has 10 example sections incl. chips/multiple/clear/auto-highlight/popup/input-group on the rebuilt parts API; kit controller is 300 lines with badge/input triggers already. Full diff needs its own session
- [x] command — search field restyled to their bordered pill inside a padded rounded-xl palette (was full-width divider row), added CommandShortcut + CommandSeparator (separator hides while filtering, like cmdk; replaces the old divide-y group borders), selected rows fill muted, list max-h-72 with hidden scrollbar; five examples incl. Scrollable + the ⌘K dialog
- [x] context-menu — mirrored the dropdown-menu part family (Group/Shortcut/CheckboxItem/RadioGroup+Item/Sub trio, destructive variant), items restyled from forced-2rem-inset to the gap grammar (.inset modifier kept), content overflow:visible so submenus can escape; their eight examples
- [ ] data-table — their page is a tanstack-table build tutorial; kit has its own data_table. Own session
- [ ] date-picker — blocked on the calendar rebuild (range/presets compositions)
- [x] dialog — fixed the footer band's undefined --pk-dialog-spacing (only alert-dialog defined it — margins silently no-op'd), respec'd to nova: 24rem default width (their max-w-sm) with viewport clamp + retuned size ladder, foreground-tint ring border, rounded-xl, p-4/gap-4/text-sm, title text-base/medium, close at top-2/right-2, description link styling; added show_close_button: + DialogClose part. Overlay kept at the kit-unified 0.5/8px — nova moved to black/10+blur-xs, change all overlays (dialog/alert-dialog/sheet/command) together as a follow-up. Five examples
- [x] drawer — added side: :top/:left/:right to DrawerContent (their direction prop; edge-attached rounding/border + per-side slide animations), nova metrics (title base/medium, header gap-0.5, text-sm body), handle hidden by default like nova's .cn-drawer-handle (re-show via CSS); Scrollable Content + Sides examples. "Responsive Dialog" is a React media-query component swap — documented, not ported
- [x] dropdown-menu — Group/Shortcut/CheckboxItem/RadioGroup+Item/Sub family, destructive items; seven examples
- [x] empty — nova metrics: borderless by default (dashed border now opt-in via `.outline` — their base sets only border-STYLE), rounded-xl (was 1.5rem), p-6 (was 3rem), title 1.125rem→text-sm/medium, icon chip 2.5→2rem w/ svg-4, content gap-2.5; their six examples (Default, Outline, Background, Avatar, Avatar Group, InputGroup)
- [ ] field (maps to our form + form_field) — AUDITED 2026-07-05 (scope only): their Field system is a full part vocabulary (FieldSet/FieldLegend/FieldGroup/Field/FieldContent/FieldLabel/FieldDescription/FieldError, orientation: horizontal/vertical/responsive, choice cards) with 13 examples; kit has the ruby_ui live-validation form_field trio. Own session — and afterwards rework the checkbox/dialog/collapsible examples that stub Field with ad-hoc rows
- [x] hover-card — added side: :top/:left/:right on content (their side prop, CSS-positioned), nova metrics (p-2.5 was 1rem, rounded-lg, text-sm, foreground-tint ring); Basic + Sides examples. Trigger-delay knobs are Radix props — controller uses its own fixed delays
- [x] input — nova respec: focus ring on --pk-ring (was brand), theme-forked fill (input/30 dark, transparent light), tinted disabled fill, invalid ring 20/40 split, styled file-selector button, text-base→md:text-sm (iOS zoom guard); eight examples (Field compositions stubbed with FormField pending the field audit)
- [x] input-group — added block_start/block_end addon aligns (group stacks to a column, full-width header/footer rows w/ .bordered rule) + InputGroupButton part (ghost-xs Button tuned flush), shell respec'd: fixed h-8 (auto w/ textarea or block addon), ring-colored focus (was brand), :has() invalid/disabled lift, theme-forked fill, textarea collapse, control padding tightened beside inline addons, addon button/kbd negative margins; eleven examples. "Custom Input" section is a Tailwind-restyle recipe — skipped
- [ ] input-otp
- [ ] item
- [ ] kbd
- [ ] label
- [ ] marker
- [ ] menubar
- [ ] message
- [ ] message-scroller
- [ ] native-select
- [ ] navigation-menu
- [ ] pagination
- [ ] popover
- [ ] progress
- [ ] radio-group
- [ ] resizable
- [ ] scroll-area
- [ ] select
- [ ] separator
- [ ] sheet
- [ ] sidebar — static part set at parity (GroupLabel/GroupContent/GroupAction/MenuAction/MenuBadge/MenuSkeleton/MenuSub*/Separator/Input added, 16rem width, optional --pk-sidebar-* tokens, menu: :default/:solid matching the create page's Menu option with shadcn's stock accent look as default); offcanvas collapse shipped (SidebarWrapper collapsible: :offcanvas + SidebarTrigger + scrim, desktop slide-away / mobile overlay drawer); icon-collapse mode + cookie persistence still omitted — page not fully audited
- [ ] skeleton
- [ ] slider
- [ ] sonner (maps to our toast — audit together with toast)
- [ ] spinner
- [ ] switch
- [ ] table
- [ ] tabs
- [ ] textarea
- [ ] toast
- [ ] toggle
- [ ] toggle-group
- [ ] tooltip
- [x] typography — fixed never-applied heading sizes; full prose specimen (h1–h4, list, table, lead/large/small/muted)

## Utilities (ui.shadcn.com/docs/utils/…)

- [ ] scroll-fade (horizontal mode shipped with attachment; page not yet audited against theirs)
- [x] shimmer — currentColor highlight sweep, custom-property knobs, once/reverse, reduced-motion, fallback

## Out of scope

- direction — React RTL context provider; handled as README documentation
- forms (react-hook-form / tanstack / formisch) — React-specific integrations
- PhlexKit-only pages with no upstream counterpart (audit N/A): link,
  masked-input, clipboard, codeblock, shortcut-key, theme-toggle
