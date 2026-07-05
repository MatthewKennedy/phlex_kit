# frozen_string_literal: true

# The /examples pages — six full-viewport admin screens for "Harbor", a
# fictional commerce admin, each recreating one grid-layout/admin-ui frame
# entirely from PhlexKit components. Standalone documents like /create.
class ExamplesController < ApplicationController
  def index
    render Examples::IndexPage.new
  end

  def show
    entry = Examples::Registry.all[params[:id]]
    raise ActionController::RoutingError, "no such example" unless entry
    render entry[:page].new
  end
end
