# frozen_string_literal: true

# Pins the PhlexKit Stimulus controllers so importmap-rails hosts can register
# them. The engine appends this file to the host's importmap paths.
#
# Each controller is co-located with its component under
# app/components/phlex_kit/<name>/<name>_controller.js, but we keep the flat
# `phlex_kit/controllers/*` module namespace stable so index.js imports and the
# host-facing API (`import … from "phlex_kit/controllers"`) never change. Basenames
# are globally unique, so the flat module IDs don't collide. app/components is
# already on the asset path (see Engine), so these logical paths resolve and
# get fingerprinted.
components_root = PhlexKit::Engine.root.join("app/components")
Dir.glob(components_root.join("phlex_kit/*/*_controller.js")).sort.each do |path|
  name = File.basename(path, ".js")               # e.g. "button_controller"
  logical = path.sub("#{components_root}/", "")    # e.g. "phlex_kit/button/button_controller.js"
  pin "phlex_kit/controllers/#{name}", to: logical
end

# The aggregator that hosts import from ("phlex_kit/controllers"); stays central.
pin "phlex_kit/controllers", to: "phlex_kit/controllers/index.js"
