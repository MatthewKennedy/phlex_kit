---
name: shadcn-theme-convert
description: Convert a shadcn/ui theme export (the :root/.dark oklch token CSS from ui.shadcn.com/create, ui.shadcn.com/themes, or tweakcn) into a PhlexKit theme file under app/assets/stylesheets/phlex_kit/themes/. Use when the user pastes a CSS block of --background/--foreground/--primary/... tokens, links a shadcn theme/create/preset URL, or asks to "convert/translate/port a shadcn theme" to PhlexKit.
---

# shadcn-theme-convert: shadcn token CSS → PhlexKit theme

A PhlexKit theme is a pure token override loaded AFTER the `phlex_kit.css`
manifest — the cascade re-themes all 70 component families with no component
CSS changes. Converting a shadcn export is a mechanical mapping plus three
structural adaptations. `_tokens.css`'s header comment is the canonical
mapping reference; `themes/claude.css` and `themes/zinc.css` are worked
examples (zinc's header carries the same recipe as this skill).

## Inputs

A shadcn export has a `:root` block (light) and a `.dark` block, ~30 tokens
each, usually `oklch()` values. Sources: ui.shadcn.com/create, the themes
page, tweakcn.com. `oklch()` / `hsl()` / hex all work verbatim in the kit's
vanilla CSS — never convert color spaces.

If the user gives a URL instead of pasted CSS, fetch it (or ask for the
copied CSS — the create page renders tokens client-side and may not fetch
cleanly).

The create page's non-token options don't travel in the CSS export but map
to kit features — mention them if the user picked non-defaults: Radius is
the `--radius` token (already in the table); Icon Library is
`PhlexKit.config.icon_library` (:lucide/:tabler/:phosphor/:remix — HugeIcons
excluded for licensing); Menu Default/Solid is `Sidebar.new(menu:)`.

## Token mapping (shadcn → --pk-*)

| shadcn | PhlexKit |
|---|---|
| `background` | `--pk-bg` |
| `card`, `popover` | `--pk-surface` (kit collapses them; use `card`) |
| `secondary`, `muted` | `--pk-surface-2` (use `secondary`) |
| `accent` | `--pk-accent` |
| `border` | `--pk-border` |
| `input` | `--pk-input` |
| `ring` | `--pk-ring` |
| `foreground` | `--pk-text` |
| `secondary-foreground` | `--pk-text-2` (see judgment call below) |
| `muted-foreground` | `--pk-muted` |
| `primary` | `--pk-brand` |
| `primary-foreground` | `--pk-brand-ink` |
| `destructive` | `--pk-red` |
| `chart-1`..`chart-5` | `--pk-chart-1`..`--pk-chart-5` |
| `radius` | `--pk-radius` |
| `font-sans` / `font-mono` (tweakcn exports) | `--pk-font-sans` / `--pk-font-mono` (only if the family is a system font or the host loads it — never point at a font the gem doesn't ship) |
| `sidebar` | `--pk-sidebar` (optional — see sidebar note) |
| `sidebar-foreground` | `--pk-sidebar-text` (optional) |
| `sidebar-accent` | `--pk-sidebar-accent` (optional) |
| `sidebar-border` | `--pk-sidebar-border` (optional) |
| `sidebar-primary` | `--pk-sidebar-primary` (optional) |
| `sidebar-primary-foreground` | `--pk-sidebar-primary-ink` (optional) |

**Sidebar tokens are optional overrides:** sidebar.css consumes them via
token→token fallbacks onto surface/text/accent/border/brand/brand-ink, so
**set one only when the export's value differs from its shared counterpart**
(compare against the tokens you already mapped; identical values are covered
by the fallback and just add noise). Setting `--pk-sidebar-primary` almost
always requires `--pk-sidebar-primary-ink` too — the fallback ink is
`--pk-brand-ink`, which is usually wrong on a different fill.

**Cascade trap:** setting a sidebar token in the dark `:root` block leaks
into light mode — `var()` fallbacks only apply when the property is UNSET,
and `:root` custom properties cascade into `:root[data-theme="light"]`. If
you set one in either mode, restate its other-mode value in BOTH light
blocks (even when that value merely equals the shared token).

**Dropped — no `--pk-*` slots:** `sidebar-ring` / `sidebar-accent-foreground`
(the kit's sidebar styles no focus ring and doesn't change hover text color),
`card-foreground` / `popover-foreground` / `accent-foreground` (kit text
tokens cover them), `destructive-foreground`, tweakcn's `shadow-*`.

**Inherited — omit, don't invent:** `--pk-green` and `--pk-amber` have no
shadcn source. Leave them out and they fall through to `_tokens.css`
defaults. Same for anything else the export doesn't define.

**Judgment call — dark `text-2`:** most dark exports set every
`*-foreground` to the same near-white, which would make secondary text as
bright as primary. When `secondary-foreground` ≈ `foreground`, pick a step
between `foreground` and `muted-foreground` (for a gray theme, `chart-1` /
the palette's ~0.87-lightness step often is that value — zinc.css used
zinc-300). Note the choice in the file's header comment.

## Structural adaptations

1. **Mode inversion.** shadcn is light-default with a `.dark` class;
   PhlexKit themes are dark-default with `data-theme="light"` opt-in plus a
   `system` block. Structure (mirror `_tokens.css` exactly):

   ```css
   :root { /* shadcn's .dark values */ color-scheme: dark; }
   :root[data-theme="light"] { /* shadcn's :root values */ color-scheme: light; }
   @media (prefers-color-scheme: light) {
     :root[data-theme="system"] { /* same light values again */ color-scheme: light; }
   }
   ```

   Keep the two light blocks byte-identical. Include `color-scheme` in all
   three.

2. **Header comment.** Attribute the source (preset URL/name) and record the
   translation notes: what was dropped, what was inherited, any judgment
   calls. Follow zinc.css's header as the template.

3. **File placement.** `app/assets/stylesheets/phlex_kit/themes/<name>.css`.
   Name after the preset/brand (kebab-case). Everything under
   `app/assets/stylesheets` is already on the engine's asset path — no
   manifest edit, no manifest regen (themes are deliberately NOT in
   `phlex_kit.css`; they load as a separate stylesheet link after it).

## Validation

1. `bundle exec rake test` — the suite must stay green (themes shouldn't
   affect it; a failure means something else got touched).
2. Boot the gallery with the theme: kill any server on 3999 first
   (`lsof -tnP -iTCP:3999 -sTCP:LISTEN`), then
   `PK_THEME=<name> bundle exec puma -p 3999 test/dummy/config.ru`.
   The dummy app links `phlex_kit/themes/#{ENV["PK_THEME"]}` when set —
   the default gallery stays the shadcn-parity baseline; never hard-link a
   theme in the dummy app.
3. Confirm the fingerprinted CSS serves:
   `curl -s http://localhost:3999/gallery | grep -o 'themes/<name>[^"]*'`
   then curl that asset path for a 200.
4. Screenshot-review BOTH modes in the browser (flip with
   `document.documentElement.dataset.theme = 'light'` or the gallery's
   theme toggle). Check specifically: primary vs destructive buttons are
   distinguishable, secondary text is dimmer than primary text (the text-2
   judgment call), focus ring color, and the chart section (charts read
   `--pk-chart-*` at Chart.js init — reload after flipping modes to see
   them recolored).

## Consumption (tell the user)

A host app applies the theme by linking it after the manifest:

```ruby
stylesheet_link_tag "phlex_kit/phlex_kit"
stylesheet_link_tag "phlex_kit/themes/<name>"
```

Dark is the default; `<html data-theme="light">` (set server-side) or
`data-theme="system"` for OS-following.
