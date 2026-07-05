# frozen_string_literal: true

require_relative "../test_helper"

# The /examples admin-UI pages are plain Phlex documents in the dummy app.
# They render here standalone by stubbing the four Rails asset helpers the
# BasePage head uses — everything else is kit components.
examples_root = File.expand_path("../dummy/app/components/examples", __dir__)
require File.join(examples_root, "base_page")
Dir[File.join(examples_root, "pages", "*.rb")].sort.each { |f| require f }
require File.join(examples_root, "registry")
require File.join(examples_root, "index_page")

class ExamplesPagesTest < Minitest::Test
  # slug => a landmark string that proves the page's real content rendered.
  LANDMARKS = {
    "dashboard-cards" => "Good morning, Mae",
    "sidebar-header" => "#HB-1042",
    "master-detail" => "Mark fulfilled",
    "holy-grail" => "Ada Thornton",
    "header-top" => "Monthly revenue",
    "settings-form" => "Statement descriptor"
  }.freeze

  def test_registry_lists_six_pages_with_resolvable_classes
    all = Examples::Registry.all
    assert_equal LANDMARKS.keys.sort, all.keys.sort
    all.each_value do |entry|
      assert_operator entry[:page], :<, Examples::BasePage
      assert entry[:title]
      assert entry[:blurb]
      assert entry[:layout]
    end
  end

  def test_each_example_page_renders_its_landmark
    Examples::Registry.all.each do |slug, entry|
      html = renderable(entry[:page]).new.call
      assert_includes html, LANDMARKS.fetch(slug), "#{slug} lost its landmark"
      assert_includes html, "Harbor", "#{slug} lost the Harbor chrome"
      assert_includes html, "pk-", "#{slug} renders no kit components"
    end
  end

  def test_index_page_links_every_example
    html = renderable(Examples::IndexPage).new.call
    Examples::Registry.all.each_key do |slug|
      assert_includes html, %(href="/examples/#{slug}")
    end
  end

  private

  # Subclass with the Rails asset helpers stubbed out (head chrome only —
  # the body under test never touches them).
  def renderable(klass)
    Class.new(klass) do
      def stylesheet_link_tag(*, **) = nil
      def javascript_include_tag(*, **) = nil
      def javascript_importmap_tags(*, **) = nil
      def asset_path(name, **) = "/assets/#{name}"
    end
  end
end
