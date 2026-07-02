# frozen_string_literal: true

require "test_helper"

# The Propshaft source-skip guard hooks a PRIVATE method (Propshaft::LoadPath#
# without_dotfiles). If a Propshaft upgrade renames/removes it, our prepend
# becomes a silent no-op and Ruby source gets served from public/assets/. This
# test fails loudly in that case.
class AssetLoadPathTest < Minitest::Test
  def setup
    require "propshaft/load_path"
    require "phlex_kit/propshaft_skip_source"
  rescue LoadError
    skip "propshaft not installed"
  end

  def test_guard_is_prepended
    assert_includes Propshaft::LoadPath.ancestors,
      PhlexKit::PropshaftSkipSourceFiles,
      "source-skip guard not prepended — Propshaft may have changed"
  end

  def test_hooked_method_still_exists
    assert Propshaft::LoadPath.private_method_defined?(:without_dotfiles),
      "Propshaft::LoadPath#without_dotfiles is gone — update the guard hook"
  end

  def test_source_extensions_rejected
    ext = PhlexKit::PropshaftSkipSourceFiles::SOURCE_EXTENSIONS
    assert_includes ext, ".rb"
    assert_includes ext, ".erb"
  end
end
