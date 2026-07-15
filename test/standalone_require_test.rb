# frozen_string_literal: true

require "minitest/autorun"
require "phlex_kit"

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

  def test_date_is_available_after_require
    # Phlex 2.4's attribute type-dispatch references Date on every attribute
    # render. A bare `require "phlex_kit"` must have Date available.
    lib = File.expand_path("../lib", __dir__)
    output = IO.popen(
      [ RbConfig.ruby, "-I", lib, "-e", 'require "phlex_kit"; print Date.today' ],
      err: [ :child, :out ], &:read
    )
    assert $?.success?, "Date not available after `require \"phlex_kit\"`:\n#{output}"
  end
end
