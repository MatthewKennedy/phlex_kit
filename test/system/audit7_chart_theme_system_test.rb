# frozen_string_literal: true

require_relative "system_test_helper"
require_relative "interaction_helpers"

# Audit round 7: the chart controller resolved theme tokens from
# document.documentElement, so a .pk-dark island (_tokens.css:123-129) — an
# element-level override for a subtree — was invisible to it; every chart
# inside an island still rendered with the page-root theme's colors. The fix
# resolves via getComputedStyle(this.element), which correctly picks up the
# nearest ancestor's custom-property values.
#
# --pk-chart-1..5 don't vary between the kit's shipped light/dark themes (see
# _tokens.css), so a real theme flip can't distinguish "read from the root"
# from "read from the element" for THIS token family — both would resolve
# to the same physical value even with the bug. Instead this pins a distinct
# --pk-chart-1 directly on a synthetic .pk-dark island (a value only that
# subtree has) and asserts the chart built inside it uses THAT value, not the
# document root's --pk-chart-1 — proving resolution is per-element.
class Audit7ChartThemeSystemTest < SystemTestCase
  include InteractionHelpers

  def test_chart_resolves_series_color_from_its_pk_dark_island_not_the_document_root
    visit "/docs/chart"
    demo("Your First Chart") # wait for the page's own chart(s) to settle

    root_chart_1 = page.evaluate_script(
      "getComputedStyle(document.documentElement).getPropertyValue('--pk-chart-1').trim()"
    )
    refute_equal "rgb(1, 2, 3)", root_chart_1, "sanity: the island override must not already be the document root's value"

    page.execute_script(<<~JS)
      const island = document.createElement("div")
      island.className = "pk-dark"
      island.style.setProperty("--pk-chart-1", "rgb(1, 2, 3)")
      island.id = "audit7-chart-island"
      const canvas = document.createElement("canvas")
      canvas.setAttribute("data-controller", "phlex-kit--chart")
      canvas.setAttribute("data-phlex-kit--chart-options-value", JSON.stringify({
        type: "bar",
        data: { labels: ["a", "b"], datasets: [{ label: "Series", data: [1, 2] }] }
      }))
      island.appendChild(canvas)
      document.body.appendChild(island)
    JS

    canvas = find("#audit7-chart-island canvas")

    wait_until("chart controller should resolve the island's --pk-chart-1, not the document root's") do
      page.evaluate_script(<<~JS, canvas)
        (() => {
          const el = arguments[0]
          const controller = window.Stimulus?.getControllerForElementAndIdentifier(el, "phlex-kit--chart")
          return controller && controller.chart && controller.chart.data.datasets[0].borderColor === "rgb(1, 2, 3)"
        })()
      JS
    end
  ensure
    page.execute_script('document.getElementById("audit7-chart-island")?.remove()')
  end
end
