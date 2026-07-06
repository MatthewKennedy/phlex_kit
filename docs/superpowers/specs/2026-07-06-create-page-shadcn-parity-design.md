# Create page shadcn parity — design

Date: 2026-07-06. Approved by Matt in-session.

## Goal

Bring `test/dummy` /create in line with ui.shadcn.com/create (audited from the
local `~/Developer/ui` checkout): two demo screens switched by a floating
01/02 pill, and a like-for-like rebuild of their Customizer sidebar, composed
from PhlexKit components.

## Reference facts (from the shadcn source audit)

- 01/02 is NOT Tabs: two ghost Buttons in a `rounded-xl bg-card/90
  backdrop-blur-xl` pill at the canvas's bottom-right, swapping two separate
  statically-rendered demo screens via a URL param (`item`).
- The sidebar is NOT Sidebar: a small always-dark Card. Header = "Menu"
  dropdown (Open Preset / Shuffle / Reset / …). Content = FieldGroup with
  FieldSeparator sections of picker rows; each row = dropdown trigger styled
  as muted-label-over-value with a right-edge indicator (color dot / "Aa" /
  style shape), opening a side-right radio-options panel. Footers =
  `--preset <code>` copy button, Open Preset (dialog + input), Shuffle, and
  Get Code.
- All state lives in URL search params, collapsed into a shareable preset
  code.

## Our build

1. **Screens**: split the existing card set — 01 = finance dashboard, 02 =
   smart-home + music/artist. Each screen is its own horizontally scrolling
   canvas. Pill = two ghost `PhlexKit::Button`s (links preserving the other
   params) toggling `?screen=`; active gets the accent fill. Old scroll-dots
   JS goes away.
2. **Sidebar**: `PhlexKit::Card` (forced dark, rounded-2xl) with
   `FieldGroup`/`FieldSeparator` sections. Picker rows = `DropdownMenu` whose
   trigger is the row grammar and whose content opens `side: :right`;
   options are `DropdownMenuItem` links (href = current params + the change)
   with a check on the selected one. Header "Menu" = `DropdownMenu` (Open
   Preset / Shuffle / Reset). Footer: `--preset <code>` (copies
   `--preset <code>` via clipboard, "Copied" feedback), Open Preset
   (`Dialog` + `Input`, GET submit), Shuffle, then Get Code (existing
   dialog). No lock buttons, no undo/redo (YAGNI).
3. **Kit change (the only gem change)**: `DropdownMenuContent` gains
   `side: :left / :right` alongside `:bottom/:top` — `position-area:
   inline-end/inline-start span-block-end` + `flip-inline` fallback,
   mirroring shadcn's side prop. Render test updated.
4. **Knobs** (all URL params, server-rendered):
   - Theme (default/neutral/zinc/claude) and Icon Library (4) — existing.
   - Heading + Font — swap `--pk-font-serif`/`--pk-font-sans` (headings use
     the serif token per kit convention) to bundled system stacks: System,
     Serif (Georgia), Mono, Rounded. Inline style block.
   - Chart Color — swap `--pk-chart-1..5` palettes: Blue (default), Emerald,
     Amber, Violet, Rose. Charts re-read tokens on the reload each knob
     change causes.
   - Style ("PhlexKit") and Base Color ("Neutral") — single-option rows,
     pixel-faithful.
5. **Presets**: curated named bundles (`b0` = defaults + a handful of
   combos). The `--preset` button shows the current match (else `custom`);
   Open Preset accepts a code and expands it to params. Shuffle randomises
   all real knobs.

## Verification

Suite green; Chrome + WebKit interaction pass: pill switch preserves knobs,
every picker row opens right and applies, preset copy/open round-trip,
fonts/charts visibly change.
