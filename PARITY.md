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
- [ ] badge
- [ ] breadcrumb
- [ ] bubble
- [ ] button
- [ ] button-group
- [ ] calendar
- [x] card — CardAction, size: :sm, --pk-card-spacing, footer band, image cards; five examples
- [ ] carousel
- [ ] chart
- [ ] checkbox
- [ ] collapsible
- [ ] combobox
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
