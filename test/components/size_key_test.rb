# frozen_string_literal: true

require "test_helper"

# The neutral size key is :md kit-wide (0.16.0 — five components spelled it
# :default through 0.15.0). Every SIZES map must agree, or `size:` means
# something different depending on which component you reach for.
class SizeKeyTest < Minitest::Test
  include RenderHelper

  SIZED = [
    PhlexKit::AlertDialogContent, PhlexKit::Attachment, PhlexKit::Card,
    PhlexKit::NativeSelect, PhlexKit::Toggle, PhlexKit::Avatar,
    PhlexKit::DialogContent, PhlexKit::CommandDialogContent, PhlexKit::Item,
    PhlexKit::SelectTrigger, PhlexKit::Switch, PhlexKit::Spinner,
    PhlexKit::Button, PhlexKit::Badge, PhlexKit::Link
  ].freeze

  def test_every_sizes_map_uses_md_as_the_neutral_key
    offenders = SIZED.reject { |k| k::SIZES.key?(:md) }
    assert_empty offenders, "these SIZES maps lack an :md key: #{offenders.join(", ")}"
  end

  def test_no_sizes_map_still_spells_the_neutral_key_default
    offenders = SIZED.select { |k| k::SIZES.key?(:default) }
    assert_empty offenders, "these SIZES maps still use :default: #{offenders.join(", ")}"
  end

  def test_renamed_components_accept_md
    assert_includes render(PhlexKit::Card.new(size: :md)) { "x" }, "pk-card"
    assert_includes render(PhlexKit::NativeSelect.new(size: :md)), "pk-native-select"
  end

  # fetch_option fails loud and names the valid keys, so an upgrader passing
  # the old spelling gets told what to use.
  def test_old_default_spelling_raises_naming_the_valid_keys
    error = assert_raises(KeyError) { render(PhlexKit::Card.new(size: :default)) { "x" } }
    assert_match(/unknown size :default/, error.message)
    assert_match(/:md/, error.message)
  end
end
