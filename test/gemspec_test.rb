# frozen_string_literal: true

require "minitest/autorun"
require "tmpdir"

# The gemspec's `files` globs must resolve relative to the gemspec's own
# directory, not the process cwd — `gem build` from anywhere else otherwise
# packages an empty gem ("WARNING: no files specified").
class GemspecTest < Minitest::Test
  GEMSPEC = File.expand_path("../phlex_kit.gemspec", __dir__)

  def test_files_resolve_when_loaded_from_another_cwd
    spec = Dir.chdir(Dir.tmpdir) { Gem::Specification.load(GEMSPEC) }
    assert_includes spec.files, "lib/phlex_kit.rb"
    assert_includes spec.files, "app/components/phlex_kit/button/button.rb"
    assert_includes spec.files, "config/importmap.rb"
  end
end
