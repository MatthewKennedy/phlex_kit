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
- [ ] command
- [ ] context-menu
- [ ] data-table
- [ ] date-picker
- [ ] dialog
- [ ] drawer
- [x] dropdown-menu — Group/Shortcut/CheckboxItem/RadioGroup+Item/Sub family, destructive items; seven examples
- [ ] empty
- [ ] field (maps to our form + form_field)
- [ ] hover-card
- [ ] input
- [ ] input-group
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
