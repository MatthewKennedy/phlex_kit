# frozen_string_literal: true

module PhlexKit
  # Base for every PhlexKit component: a plain Phlex::HTML subclass. It stays free
  # of any Rails-runtime coupling (no route helpers, no booted-app assumptions) so
  # the components load and render anywhere Phlex does — that also keeps the unit
  # suite bootable without a Rails app. A host component that needs route helpers
  # includes `Phlex::Rails::Helpers::Routes` itself.
  #
  # Reactivity is deliberately NOT baked in. Components pass **attrs straight
  # through `mix`, so a phlex-reactive `**on(:event)` bundle composes onto the
  # root element with zero coupling. `on` here is a safe no-op unless the host has
  # opted into reactivity AND the component includes Phlex::Reactive::Component
  # (which provides the real `on`).
  class BaseComponent < Phlex::HTML
    # No-op fallback. A reactive component includes Phlex::Reactive::Component,
    # whose own `on` shadows this and returns the real attribute bundle.
    def on(*, **)
      {}
    end
  end
end
