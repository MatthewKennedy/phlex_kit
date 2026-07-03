# frozen_string_literal: true

require_relative "lib/phlex_kit/version"

Gem::Specification.new do |spec|
  spec.name    = "phlex_kit"
  spec.version = PhlexKit::VERSION
  spec.authors = ["Matt Kennedy"]
  spec.email   = ["m.kennedy@aypex.io"]

  spec.summary     = "shadcn/ui-style component system for Phlex, styled with vanilla CSS and design tokens."
  spec.description = "PhlexKit brings the shadcn/ui component catalog to Phlex and Rails, " \
                     "replacing Tailwind with co-located vanilla CSS per component plus a " \
                     "global :root design-token theme. phlex-reactive is an optional, " \
                     "per-component integration — never a required dependency. Assets ship " \
                     "precompiled-static, so no host build step."
  spec.homepage = "https://github.com/MatthewKennedy/phlex_kit"
  spec.license  = "MIT"
  spec.required_ruby_version = ">= 3.2"

  spec.metadata["homepage_uri"]    = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["rubygems_mfa_required"] = "true"

  # Ship precompiled-static assets (the whole point): the .rb components, the
  # co-located .css, the token/manifest stylesheets, and the Stimulus controllers.
  spec.files = Dir[
    "lib/**/*",
    "app/**/*",
    "config/**/*",
    "MIT-LICENSE",
    "THIRD_PARTY_LICENSES",
    "README.md"
  ]
  spec.require_paths = ["lib"]

  # HARD dependencies — the mature foundation. NOT phlex-reactive; NOT tailwind_merge.
  spec.add_dependency "phlex-rails", ">= 2.0", "< 3"
  spec.add_dependency "railties",    ">= 7.1", "< 9"

  spec.add_development_dependency "propshaft"
  spec.add_development_dependency "importmap-rails"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "rake"
  # Optional integration is exercised in tests but never required at runtime:
  # spec.add_development_dependency "phlex-reactive"
end
