# frozen_string_literal: true

class DocsController < ApplicationController
  def index
    redirect_to doc_path(Docs::Registry.all.keys.first)
  end

  def show
    entry = Docs::Registry.all[params[:id]]
    raise ActionController::RoutingError, "no such component" unless entry
    render Docs::Layout.new(current: params[:id]) { render entry[:page].new }
  end
end
