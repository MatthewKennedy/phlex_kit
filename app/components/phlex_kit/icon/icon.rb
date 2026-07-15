module PhlexKit
  # A glyph from the configured icon library (ui.shadcn.com/create's "Icon
  # Library" option): :lucide (default), :tabler, :phosphor, or :remix — set
  # kit-wide via PhlexKit.config.icon_library or per-instance with `library:`.
  # Names are PhlexKit's canonical semantic set (PhlexKit::Icons.names);
  # unknown names/libraries fail loud (KeyError).
  #
  # `size:` emits width/height attributes (default 16, shadcn's size-4); pass
  # `size: nil` to defer sizing to CSS (existing `.pk-x svg { … }` rules).
  # Stroke libraries (lucide/tabler) render stroke="currentColor"; fill
  # libraries (phosphor/remix) render fill="currentColor" — both follow text
  # color. Attrs pass through via mix.
  class Icon < BaseComponent
    def initialize(name, library: nil, size: 16, **attrs)
      @name = name
      @library = library
      @size = size
      @attrs = attrs
    end

    def view_template
      icon = Icons.fetch(@name, library: @library || PhlexKit.config.icon_library)
      base = base_attrs(icon)
      # `mix` merges duplicate string attrs ("16 24") — drop a generated attr
      # whenever the caller supplies their own copy, so theirs wins.
      %i[width height viewbox aria-hidden].each do |key|
        base.delete(key) if @attrs.key?(key) || @attrs.key?(key.to_s)
      end
      svg(**mix(base, @attrs)) do |s|
        icon[:elements].each { |tag, attrs| s.public_send(tag, **attrs) }
      end
    end

    private

    def base_attrs(icon)
      base = {
        xmlns: "http://www.w3.org/2000/svg",
        viewbox: icon[:view_box],
        class: "pk-icon",
        "aria-hidden": "true"
      }
      base[:width] = base[:height] = @size.to_s if @size
      if icon[:mode] == :stroke
        base.merge(
          fill: "none",
          stroke: "currentColor",
          "stroke-width": icon[:stroke_width].to_s,
          "stroke-linecap": "round",
          "stroke-linejoin": "round"
        )
      else
        base.merge(fill: "currentColor")
      end
    end
  end
end
