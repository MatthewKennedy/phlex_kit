# frozen_string_literal: true

require "minitest/autorun"

# `require "phlex_kit"` must work in a bare script/console (no Rails booted,
# nothing pre-required) — phlex-rails needs ActiveSupport::SafeBuffer loaded
# first and lib/phlex_kit.rb is responsible for that. Run in a subprocess so
# this suite's own requires can't mask a regression.
class StandaloneRequireTest < Minitest::Test
  def test_bare_require_succeeds
    lib = File.expand_path("../lib", __dir__)
    output = IO.popen(
      [ RbConfig.ruby, "-I", lib, "-e", 'require "phlex_kit"; print PhlexKit::VERSION' ],
      err: [ :child, :out ], &:read
    )
    assert $?.success?, "bare `require \"phlex_kit\"` failed:\n#{output}"
    assert_equal PhlexKit::VERSION, output
  end
end
