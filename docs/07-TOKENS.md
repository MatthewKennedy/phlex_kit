# 07 — CSS token reference

Every PhlexKit component is styled with vanilla CSS that reads `--pk-*` custom
properties. Nothing is hard-coded: redefine a token on `:root` (or any
ancestor) and everything under it re-themes live, no rebuild. This document is
the complete token surface — the shared theme tokens, the optional sidebar
overrides, and the per-component knobs.

## How theming works

- `app/assets/stylesheets/phlex_kit/_tokens.css` defines the default theme —
  shadcn/ui's current (neutral) palette, values lifted verbatim from
  ui.shadcn.com. It is imported first by the `phlex_kit.css` manifest but is
  **optional**: a host that wants a fully custom palette can skip it and
  define every token itself.
- Dark is the default (`:root`). Light is opt-in via
  `<html data-theme="light">` (set it server-side to avoid a flash);
  `data-theme="system"` follows the OS via `prefers-color-scheme`.
- Your app's stylesheet sorts after the gem's, so overriding a token in your
  own `:root` block wins:

  ```css
  :root {
    --pk-brand: #3b5bdb;    /* primary buttons, selected states, slider fill */
    --pk-radius: 0.375rem;  /* every component radius derives from this */
  }
  ```

- Ready-made palettes ship under `app/assets/stylesheets/phlex_kit/themes/`
  (`neutral`, `zinc`, `claude`) — link one after the manifest. The
  `shadcn-theme-convert` skill turns any ui.shadcn.com/create or tweakcn
  export into a theme file.

> **Cascade trap** (see CLAUDE.md): a token set only in the dark `:root`
> block leaks into light mode — `var()` fallbacks apply to *unset* properties
> only, and `:root` values cascade into `:root[data-theme="light"]`. Any
> mode-varying token (including the optional `--pk-sidebar-*` overrides) must
> be restated in **both** light blocks (`[data-theme="light"]` and the
> `system` media-query block).

## Theme tokens

The shared palette every component reads. shadcn/ui equivalents are noted
because the default values are lifted from its token system.

### Surfaces & structure

| Token | Dark default | Light default | Controls | shadcn equiv. |
|---|---|---|---|---|
| `--pk-bg` | `#0a0a0a` | `#ffffff` | Page background; also inverse ink on tooltips/kbd and inset fills (e.g. sidebar search input). | `background` |
| `--pk-surface` | `#171717` | `#ffffff` | Raised surfaces: cards, popovers, menus, dialogs, drawers. | `card` / `popover` |
| `--pk-surface-2` | `#262626` | `#f5f5f5` | Muted fills: skeletons, tabs list, secondary buttons, table stripes, code chips. | `muted` |
| `--pk-accent` | `#404040` | `#f5f5f5` | Hover/active fills on interactive rows (menu items, options, toggles). Darker than `surface-2` in dark mode. | `accent` |
| `--pk-border` | `#ffffff1a` | `#e5e5e5` | Separators and container borders. | `border` |
| `--pk-input` | `#ffffff26` | `#e5e5e5` | Form-control borders (inputs, selects, textareas, checkboxes). | `input` |
| `--pk-ring` | `#737373` | `#a1a1a1` | Focus rings. Components render them as `box-shadow: 0 0 0 3px color-mix(in oklab, var(--pk-ring) 50%, transparent)`. | `ring` |

### Text

| Token | Dark default | Light default | Controls | shadcn equiv. |
|---|---|---|---|---|
| `--pk-text` | `#fafafa` | `#000000` | Primary foreground. Also the base for foreground-tint mixes (`color-mix(… var(--pk-text) 10% …)` rings/borders). | `foreground` |
| `--pk-text-2` | `#d4d4d4` | `#404040` | Secondary foreground — a **host-facing** tier between `text` and `muted`; no kit component consumes it by design. shadcn has no such tier (its secondary fills use near-foreground ink, which the kit renders with `--pk-text`), so theme conversion fills this slot from `secondary-foreground`, dimming it to a mid step when the export collapses it to ≈`foreground` (the `shadcn-theme-convert` judgment call). The docs site uses it for prose and syntax-highlight midtones. | `secondary-foreground` (converted, see left) |
| `--pk-muted` | `#a1a1a1` | `#737373` | Tertiary/placeholder text: descriptions, captions, item glyphs, disabled hints. | `muted-foreground` |

### Brand & status colors

| Token | Dark default | Light default | Controls | shadcn equiv. |
|---|---|---|---|---|
| `--pk-brand` | `#e5e5e5` | `#000000` | Primary actions: default buttons, selected states, slider/progress fill, checked controls. Monochrome by default. | `primary` |
| `--pk-brand-ink` | `#171717` | `#fafafa` | Text/icons sitting **on** a `--pk-brand` fill. | `primary-foreground` |
| `--pk-red` | `#ff6568` | `#e40014` | Destructive: danger buttons, error text, invalid-field borders/rings. | `destructive` |
| `--pk-green` | `#22c55e` | `#16a34a` | Success accents (alert/badge `.success`). | — |
| `--pk-amber` | `#f59e0b` | `#d97706` | Warning accents (alert/badge `.warning`). | — |

### Charts

Consumed by the `chart` component's Stimulus controller as the default series
palette (host supplies `window.Chart`). Same values in dark and light by
default (Tailwind blue 300/500/600/700/800).

| Token | Default |
|---|---|
| `--pk-chart-1` | `#93c5fd` |
| `--pk-chart-2` | `#3b82f6` |
| `--pk-chart-3` | `#2563eb` |
| `--pk-chart-4` | `#1d4ed8` |
| `--pk-chart-5` | `#1e40af` |

### Shape & type

| Token | Default | Controls |
|---|---|---|
| `--pk-radius` | `0.625rem` | The single radius source. Every component derives from it (`calc(var(--pk-radius) - 2px)` for nested/small elements, etc.) — change one value, the whole kit follows. Maps to the **Radius** knob on ui.shadcn.com/create. |
| `--pk-font-sans` | `ui-sans-serif, system-ui, -apple-system, sans-serif` | Body/UI type — components inherit the host's body font, so this is the slot the host sets its body `font-family` from (the docs site does: `font: 16px/1.5 var(--pk-font-sans)` after a Geist `@font-face`). |
| `--pk-font-mono` | `ui-monospace, SFMono-Regular, Menlo, monospace` | Mono text: codeblock, typography inline-code, shortcut keys. |
| `--pk-font-serif` | `ui-serif, Georgia, Cambria, "Times New Roman", Times, serif` | Serif slot — no base component consumes it; themes and hosts do (the `claude` theme repoints it at Copernicus → Georgia and sets `.pk-heading` in it). Maps from tweakcn exports' `font-serif`. |

## Optional sidebar overrides

shadcn `sidebar-*` parity. **Undefined by default** — `sidebar.css` reads them
through token→token fallbacks, so unset they inherit the shared palette. Set
one only when its value should differ from the shared token (e.g. the
`neutral` theme's distinct blue `sidebar-primary` in dark mode). shadcn's
`sidebar-ring` / `sidebar-accent-foreground` have no consumption site in the
kit and stay unmapped.

| Token | Falls back to | Controls |
|---|---|---|
| `--pk-sidebar` | `--pk-surface` | Sidebar background. |
| `--pk-sidebar-text` | `--pk-text` | Sidebar foreground. |
| `--pk-sidebar-accent` | `--pk-accent` | Hover/active fill on menu buttons. |
| `--pk-sidebar-border` | `--pk-border` | Sidebar edge + separators. |
| `--pk-sidebar-primary` | `--pk-brand` | Active/primary menu emphasis. |
| `--pk-sidebar-primary-ink` | `--pk-brand-ink` | Text on a `sidebar-primary` fill. |

Because these are mode-varying when set, remember the cascade trap: restate
them in both light blocks.

## Per-component knobs

Local tokens defined by a component's own CSS with a default, meant to be
tuned per-instance (inline `style:` or a scoped rule) rather than themed
globally.

| Token | Component | Default | Purpose |
|---|---|---|---|
| `--pk-card-spacing` | card | `1rem` (`.75rem` on `.sm`) | Single source for every card gap/inset; the `size: :sm` modifier just tightens it. |
| `--pk-dialog-spacing` | dialog, alert_dialog | `1rem` dialog / `1.5rem` alert (`1rem` on `.sm`) | Panel padding + section gaps. |
| `--pk-cell-size` | calendar (+ date_picker) | `2rem` | Day-cell square size — shadcn's "Custom Cell Size" example is just an inline override. |
| `--pk-cell-radius` | calendar (+ date_picker) | `calc(var(--pk-radius) - 2px)` | Day-cell corner radius (range endpoints etc.). |
| `--pk-collapsible-rotate` | collapsible | `180deg` | Open-state rotation of a `.pk-collapsible-chevron` (file trees use `90deg` on a chevron-right). |
| `--pk-skeleton-width` | sidebar (MenuSkeleton) | `70%` | Max-width of the text bar; the component randomises 50–90% per render, shadcn's `--skeleton-width` trick. |
| `--pk-scroll-fade-size` | `.pk-scroll-fade` utility | `2rem` | Depth of the edge fade masks on scrollable containers. |
| `--pk-shimmer-color` | `.pk-shimmer` utility | brightened `currentColor` (oklch relative) | Highlight band color. |
| `--pk-shimmer-duration` | `.pk-shimmer` utility | `2s` | One sweep. |
| `--pk-shimmer-spread` | `.pk-shimmer` utility | `calc(3ch + 40px)` | Band width. |
| `--pk-shimmer-angle` | `.pk-shimmer` utility | `20deg` | Band tilt. |
| `--pk-nav-gap` | navigation_menu | `.375rem` | Trigger→panel gap; the invisible `::before` hover bridge spans it. |

**Internal, not a knob:** `--pk-slider-progress` — the slider's filled-track
percentage, set inline by `slider.rb` at render and kept in sync by the
`phlex-kit--slider` controller on input. Don't theme it.

## Defining a token set from scratch

Skip the `_tokens.css` import (or link a stylesheet after it) and define all
of: the seven surface/structure tokens, three text tokens, five brand/status
tokens, five chart tokens, `--pk-radius`, and the three font stacks — in a
`:root` (dark) block and both light blocks. The sidebar overrides and
per-component knobs are optional. `themes/zinc.css` is the cleanest example
to copy.
