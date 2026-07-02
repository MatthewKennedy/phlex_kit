# frozen_string_literal: true

# Pins the PhlexKit Stimulus controllers so importmap-rails hosts can register
# them. The engine appends this file to the host's importmap paths.
pin_all_from PhlexKit::Engine.root.join("app/javascript/phlex_kit/controllers"),
  under: "phlex_kit/controllers",
  to: "phlex_kit/controllers"
