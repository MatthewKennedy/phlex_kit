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

    private

    # Fail-loud option lookup with an actionable message. Still a KeyError —
    # the same class a bare VARIANTS.fetch raised — but names the component,
    # the option, and the valid values instead of "key not found: :prmary".
    def fetch_option(map, key, name)
      map.fetch(key) do
        raise KeyError, "#{self.class.name}: unknown #{name} #{key.inspect} — " \
                        "valid: #{map.keys.map(&:inspect).join(", ")}"
      end
    end

    # True when the caller supplied their own value for a plain attribute in
    # @attrs — symbol or string spelling. A component with a generated default
    # for that attribute must skip it then: `mix` merges duplicate attrs
    # (role="dialog region") instead of overriding. Aria attributes have their
    # own check (aria_key_set?) covering the aria: hash spelling too.
    def attr_set?(key)
      @attrs.key?(key) || @attrs.key?(key.to_s)
    end

    # True when the caller supplied an accessible name in @attrs — via the
    # aria: hash or flat aria_label/aria-label(ledby) keys. Components with a
    # generated default label must skip it then: `mix` merges duplicate string
    # attrs ("pagination Résultats") instead of overriding.
    def aria_labelled?
      aria_key_set?(:label) || aria_key_set?(:labelledby)
    end

    # True when the caller already supplied their own value for a given aria
    # attribute — via the aria: hash (aria: { <key>: ... }) or the flat
    # "aria-<key>"/aria_<key> spelling. A component with a generated default
    # for that attribute must skip it then: `mix` merges duplicate attrs
    # (aria-modal="true false") instead of overriding.
    def aria_key_set?(key)
      aria = @attrs[:aria] || @attrs["aria"]
      if aria.is_a?(Hash)
        return true if aria.key?(key) || aria.key?(key.to_s)
      end
      dashed = "aria-#{key}"
      underscored = "aria_#{key}"
      [ dashed.to_sym, dashed, underscored.to_sym, underscored ].any? { |k| @attrs[k] }
    end
  end
end
