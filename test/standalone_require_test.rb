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

  def test_bare_require_can_render_a_component
    # The mechanism check above only proves the require chain resolves — it
    # never exercises Phlex's own render path (attribute dispatch, SafeBuffer
    # output) outside a booted Rails app. Render an attr-bearing component to
    # prove that path actually works standalone. Components autoload via
    # Zeitwerk inside a Rails app, so a bare script requires the file
    # directly — same as the plain unit suite's test_helper.
    lib = File.expand_path("../lib", __dir__)
    badge = File.expand_path("../app/components/phlex_kit/badge/badge.rb", __dir__)
    script = %(require "phlex_kit"; require #{badge.inspect}; print PhlexKit::Badge.new(variant: :secondary) { "x" }.call)
    output = IO.popen(
      [ RbConfig.ruby, "-I", lib, "-e", script ],
      err: [ :child, :out ], &:read
    )
    assert $?.success?, "bare `require \"phlex_kit\"` render failed:\n#{output}"
    assert_equal '<span class="pk-badge secondary">x</span>', output
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
