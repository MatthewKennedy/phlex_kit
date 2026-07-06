module PhlexKit
  # Command palette, ported from ruby_ui's RubyUI::Command. The palette body:
  # CommandInput + CommandList(CommandGroup > CommandItem) + CommandEmpty.
  # Normally composed inside CommandDialog/CommandDialogContent, whose cloned
  # wrapper carries the phlex-kit--command controller (matching ruby_ui); for an
  # inline palette add `data: { controller: "phlex-kit--command" }` yourself.
  # Upstream's fuse.js fuzzy search is replaced with a dependency-free substring
  # match in the controller. Tailwind → vanilla `.pk-command*` (command.css).
  class Command < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template
      div(**mix({ class: "pk-command" }, @attrs)) do
        live_region
        yield
      end
    end

    private

    # Screen-reader announcement of the filtered result count — the controller
    # writes "N results" / "No results" into it from filter().
    def live_region
      div(
        class: "pk-sr-only",
        aria: { live: "polite" },
        data: { phlex_kit__command_target: "liveRegion" }
      )
    end
  end
end
