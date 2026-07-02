# frozen_string_literal: true

class GalleryController < ApplicationController
  def index
    render Gallery::Page.new
  end
end
