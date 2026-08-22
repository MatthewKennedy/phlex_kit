module PhlexKit
  # Command palette, ported from ruby_ui's RubyUI::Command. The palette body:
  # CommandInput + CommandList(CommandGroup > CommandItem) + CommandEmpty.
  # Normally composed inside CommandDialog/CommandDialogContent, whose cloned
  # wrapper carries the phlex-kit--command controller (matching ruby_ui); for an
  # inline palette add `data: { controller: "phlex-kit--command" }` yourself.
  # Upstream's fuse.js fuzzy search is replaced with a dependency-free substring
  # match in the controller. Tailwind → vanilla `.pk-command*` (command.css).
  class Command < BaseComponent
    # Announcement templates for the live region — the only strings the
    # controller writes itself (CommandEmpty is server-rendered, so it
    # localizes with the rest of your markup). %{count} is interpolated.
    DEFAULT_RESULTS_FORMAT = "%{count} result(s)"
    DEFAULT_NO_RESULTS_TEXT = "No results"

    def initialize(results_format: DEFAULT_RESULTS_FORMAT, no_results_text: DEFAULT_NO_RESULTS_TEXT, **attrs)
      @results_format = results_format
      @no_results_text = no_results_text
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
    # writes the results_format / no_results_text strings into it from
    # filter(), interpolating %{count}.
    def live_region
      div(
        class: "pk-sr-only",
        aria: { live: "polite" },
        data: {
          phlex_kit__command_target: "liveRegion",
          results_format: @results_format,
          no_results_text: @no_results_text
        }
      )
    end
  end
end
