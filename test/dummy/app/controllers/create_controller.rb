# frozen_string_literal: true

# The /create page — a PhlexKit recreation of ui.shadcn.com/create. The two
# query params are whitelisted here so the page component can trust them.
class CreateController < ApplicationController
  def index
    render Create::Page.new(
      theme: Create::Page::THEMES.include?(params[:theme]) ? params[:theme] : nil,
      icons: Create::Page::ICON_LIBRARIES.include?(params[:icons]) ? params[:icons] : nil
    )
  end
end
