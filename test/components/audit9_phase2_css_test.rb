# frozen_string_literal: true

require "test_helper"

# Audit round 9 phase 2: CSS batch — nine independent small fixes,
# drift-guarded by asserting the key selectors/declarations survive.
class Audit9Phase2CssTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  CHECKBOX_CSS = File.join(ROOT, "app/components/phlex_kit/checkbox/checkbox.css")
  DRAWER_CSS = File.join(ROOT, "app/components/phlex_kit/drawer/drawer.css")
  INPUT_GROUP_CSS = File.join(ROOT, "app/components/phlex_kit/input_group/input_group.css")
  ATTACHMENT_CSS = File.join(ROOT, "app/components/phlex_kit/attachment/attachment.css")
  AVATAR_CSS = File.join(ROOT, "app/components/phlex_kit/avatar/avatar.css")
  ITEM_CSS = File.join(ROOT, "app/components/phlex_kit/item/item.css")
  LABEL_CSS = File.join(ROOT, "app/components/phlex_kit/label/label.css")

  # --- Finding 1: the always-on aria-invalid ring swallowed :focus-visible —
  # a focused invalid checkbox must show a distinct focus ring (with
  # theme-scoped arms outweighing the theme-scoped invalid copies).
  def test_checkbox_invalid_focus_visible_shows_a_ring
    css = File.read(CHECKBOX_CSS)
    rule = css[/\.pk-checkbox\[aria-invalid="true"\]:focus-visible,[^{]*\{[^}]*\}/m]
    refute_nil rule, "checkbox.css must style [aria-invalid=true]:focus-visible distinctly"
    assert_match(/box-shadow: 0 0 0 3px color-mix\(in oklab, var\(--pk-ring\) 50%, transparent\)/, rule)
    assert_includes rule, %(:root[data-theme="light"] .pk-checkbox[aria-invalid="true"]:focus-visible)
    assert_match(/:root\[data-theme="system"\] \.pk-checkbox\[aria-invalid="true"\]:focus-visible/, css)
  end

  # --- Finding 2: .pk-drawer had no overflow rule — tall content squashed
  # flex children and spilled past the rounded panel instead of scrolling.
  def test_drawer_panel_scrolls_overflowing_content
    css = File.read(DRAWER_CSS)
    rule = css[/\.pk-drawer\s*\{[^}]*\}/m]
    refute_nil rule
    assert_match(/overflow:\s*auto/, rule, "drawer.css must let .pk-drawer scroll content taller than max-height")
  end

  # --- Finding 3: :has(:disabled) matched ANY disabled descendant, so a
  # disabled addon button dimmed a group whose input was fully editable —
  # scope to the direct-child control only.
  def test_input_group_disabled_dim_is_scoped_to_the_control
    css = File.read(INPUT_GROUP_CSS)
    refute_match(/\.pk-input-group:has\(:disabled\)/, css, "the unscoped :has(:disabled) arm must not return")
    assert_match(/\.pk-input-group:has\(> input:disabled, > textarea:disabled, > select:disabled\)/, css)
    assert_match(/:root\[data-theme="light"\] \.pk-input-group:has\(> input:disabled/, css)
  end

  # --- Finding 4: the upload-title shimmer duplicated .pk-shimmer's recipe
  # but omitted its [dir="rtl"] animation-direction arm.
  def test_attachment_shimmer_reverses_in_rtl
    css = File.read(ATTACHMENT_CSS)
    rule = css[/\[dir="rtl"\] \.pk-attachment\[data-state="uploading"\] \.pk-attachment-title,[^{]*\{[^}]*\}/m]
    refute_nil rule, "attachment.css must reverse the upload-title shimmer under [dir=rtl]"
    assert_match(/animation-direction:\s*reverse/, rule)
  end

  # --- Finding 5: the group reserved only 2px for card rings, clipping the
  # outer 1px of the 3px trigger focus ring inside the scroll container.
  def test_attachment_group_reserves_room_for_the_3px_ring
    css = File.read(ATTACHMENT_CSS)
    rule = css[/\.pk-attachment-group\s*\{[^}]*\}/m]
    refute_nil rule
    assert_match(/padding:\s*3px/, rule, "the group padding must fit the 3px card focus ring")
  end

  # --- Finding 6: GroupCount's :has() size-matching only covered sm/lg —
  # xs/xl groups got the mismatched 2rem default pill.
  def test_avatar_group_count_matches_xs_and_xl_sizes
    css = File.read(AVATAR_CSS)
    assert_match(/\.pk-avatar-group:has\(\.pk-avatar\.xs\) \.pk-avatar-group-count \{ width: 1rem; height: 1rem;/, css)
    assert_match(/\.pk-avatar-group:has\(\.pk-avatar\.xl\) \.pk-avatar-group-count \{ width: 5rem; height: 5rem;/, css)
  end

  # --- Finding 7: ItemDescription's text-overflow: ellipsis was dead CSS
  # (no nowrap/line-clamp) — shadcn line-clamps to 2 lines.
  def test_item_description_line_clamps_to_two_lines
    css = File.read(ITEM_CSS)
    rule = css[/\.pk-item-description\s*\{[^}]*\}/m]
    refute_nil rule
    assert_match(/-webkit-line-clamp:\s*2/, rule)
    assert_match(/display:\s*-webkit-box/, rule)
    assert_match(/-webkit-box-orient:\s*vertical/, rule)
  end

  # --- Finding 8: Label's disabled-dim only matched a DIRECT disabled
  # sibling — a wrapped control (Switch's <label> root) never dimmed it.
  def test_label_dims_beside_a_label_wrapped_disabled_control
    css = File.read(LABEL_CSS)
    assert_match(/\.pk-label:has\(\+ label:has\(:disabled\)\)/, css)
    assert_match(/label:has\(:disabled\) \+ \.pk-label/, css)
  end

  # --- Finding 9: link Items had a hover fill but no :focus-visible ring.
  def test_link_item_has_the_standard_focus_ring
    css = File.read(ITEM_CSS)
    rule = css[/a\.pk-item:focus-visible\s*\{[^}]*\}/m]
    refute_nil rule, "item.css must give a.pk-item the kit's focus ring"
    assert_match(/outline:\s*none/, rule)
    assert_match(/border-color:\s*var\(--pk-ring\)/, rule)
    assert_match(/box-shadow: 0 0 0 3px color-mix\(in oklab, var\(--pk-ring\) 50%, transparent\)/, rule)
  end
end
