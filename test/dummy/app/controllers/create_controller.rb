# frozen_string_literal: true

# The /create page — a PhlexKit recreation of ui.shadcn.com/create. Query
# params are whitelisted here so the page component can trust them; a
# ?preset=<code> expands to its knob bundle (screen always passes through).
class CreateController < ApplicationController
  def index
    knobs = Create::Page::PRESETS[params[:preset]] || params
    render Create::Page.new(
      theme: Create::Page::THEMES.include?(knobs[:theme]) ? knobs[:theme] : nil,
      icons: Create::Page::ICON_LIBRARIES.include?(knobs[:icons]) ? knobs[:icons] : nil,
      heading: Create::Page::FONTS.key?(knobs[:heading]) ? knobs[:heading] : nil,
      font: Create::Page::FONTS.key?(knobs[:font]) ? knobs[:font] : nil,
      chart: Create::Page::CHART_PALETTES.key?(knobs[:chart]) ? knobs[:chart] : nil,
      screen: params[:screen] == "2" ? "2" : nil
    )
  end
end
