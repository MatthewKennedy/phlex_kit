# frozen_string_literal: true

require "test_helper"

# Guards the three things that silently break asset delivery:
#   1. every component's co-located .css is listed in the manifest,
#   2. every @import uses the url() form (bare @import ships un-digested → 404),
#   3. every import path is relative to the manifest's own phlex_kit/ directory —
#      Propshaft resolves bare url() paths against the referencing file's dir, so
#      a `phlex_kit/…` prefix doubles up (phlex_kit/phlex_kit/…) and 404s.
class ManifestTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  MANIFEST = File.join(ROOT, "app/assets/stylesheets/phlex_kit/phlex_kit.css")

  def test_every_component_css_is_imported
    manifest = File.read(MANIFEST)
    Dir[File.join(ROOT, "app/components/phlex_kit/*/*.css")].each do |css|
      rel = css.sub("#{ROOT}/app/components/phlex_kit/", "")
      assert_includes manifest, %(url("#{rel}")), "#{rel} missing from manifest"
    end
  end

  def test_all_imports_use_url_form
    import_lines.each do |line|
      assert_match(/@import url\("/, line, "bare @import (not url()) won't be fingerprinted: #{line}")
    end
  end

  def test_imports_are_relative_to_the_manifest_directory
    import_lines.each do |line|
      refute_match(%r{url\("(\./)?phlex_kit/}, line,
        "import must be relative to phlex_kit/ (Propshaft doubles the prefix otherwise): #{line}")
      refute_match(%r{url\("/}, line, "import should not be root-absolute: #{line}")
    end
  end

  private

  def import_lines
    # Drop the header comment first — its usage example is a host-side import.
    File.read(MANIFEST).sub(%r{\A/\*.*?\*/}m, "").each_line.map(&:strip).select { |line| line.start_with?("@import") }
  end
end
