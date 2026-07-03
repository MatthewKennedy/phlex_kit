# frozen_string_literal: true

require "test_helper"

# Guards the JS wiring the way manifest_test guards the CSS: every co-located
# Stimulus controller must be imported AND registered in the central registry,
# and the registry must not reference controllers that no longer exist. Catches
# the "added/moved a controller but forgot to (un)register it" class of bug and
# locks in the colocation convention (controllers live beside their component,
# the flat phlex_kit/controllers/* module namespace stays stable).
class JavascriptRegistrationTest < Minitest::Test
  ROOT = File.expand_path("../..", __dir__)
  INDEX = File.join(ROOT, "app/javascript/phlex_kit/controllers/index.js")

  # Every *_controller.js co-located under a component folder, by basename
  # without the .js (e.g. "button_controller"). Basenames are globally unique.
  def controller_names
    Dir[File.join(ROOT, "app/components/phlex_kit/*/*_controller.js")]
      .map { |f| File.basename(f, ".js") }.sort
  end

  def test_every_controller_is_imported_and_registered
    index = File.read(INDEX)
    controller_names.each do |name|
      assert_includes index, %(from "phlex_kit/controllers/#{name}"),
        "#{name}.js is not imported in controllers/index.js"
    end
  end

  def test_every_import_points_at_an_existing_controller
    names = controller_names
    imported = File.read(INDEX).scan(%r{from "phlex_kit/controllers/(\w+_controller)"}).flatten
    imported.each do |name|
      assert_includes names, name,
        "controllers/index.js imports #{name} but no matching *_controller.js exists"
    end
  end

  def test_every_controller_is_registered_under_a_phlex_kit_identifier
    index = File.read(INDEX)
    controller_names.each do |name|
      # accordion_controller → phlex-kit--accordion
      identifier = "phlex-kit--#{name.sub(/_controller\z/, "").tr("_", "-")}"
      assert_includes index, %{application.register("#{identifier}"},
        "#{name} is not registered as #{identifier} in controllers/index.js"
    end
  end
end
