# frozen_string_literal: true

require "test_helper"

# Guards the two things that silently break asset delivery:
#   1. every component's co-located .css is listed in the manifest, and
#   2. every @import uses the url() form (bare @import ships un-digested → 404).
class ManifestTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  MANIFEST = File.join(ROOT, "app/assets/stylesheets/phlex_kit/phlex_kit.css")

  def test_every_component_css_is_imported
    manifest = File.read(MANIFEST)
    Dir[File.join(ROOT, "app/components/phlex_kit/*/*.css")].each do |css|
      rel = css.sub("#{ROOT}/app/components/", "")
      assert_includes manifest, %(url("#{rel}")), "#{rel} missing from manifest"
    end
  end

  def test_all_imports_use_url_form
    File.read(MANIFEST).each_line do |line|
      next unless line.strip.start_with?("@import")
      assert_match(/@import url\("/, line, "bare @import (not url()) won't be fingerprinted: #{line.strip}")
    end
  end
end
