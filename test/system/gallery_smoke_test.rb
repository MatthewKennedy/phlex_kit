# frozen_string_literal: true

require_relative "system_test_helper"

# Whole-page smoke: the gallery and every /docs/<slug> page render with a
# connected Stimulus application and zero JS console errors (the teardown
# trap flunks on any). This is the canary for importmap/controller wiring.
class GallerySmokeTest < SystemTestCase
  def test_gallery_renders_every_section_without_js_errors
    visit "/gallery"
    assert_selector "h1", text: "PhlexKit Gallery"
    # The server-rendered flash toast proves the toaster booted.
    assert_selector ".pk-toast", text: "Gallery loaded", wait: 5
  end

  def test_every_docs_page_renders_without_js_errors
    slugs = Docs::Registry.all.keys
    refute_empty slugs, "docs registry should list the component pages"

    slugs.each do |slug|
      visit "/docs/#{slug}"
      assert_selector "main, .docs-main", wait: 5
      errors = page.evaluate_script("window.__pkJsErrors || []")
      assert_empty errors, "/docs/#{slug} raised JS errors: #{errors.join("; ")}"
    end
  end
end
