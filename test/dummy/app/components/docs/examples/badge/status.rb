# frozen_string_literal: true

module Docs
  module Examples
    module Badge
      class Status < Phlex::HTML
        def view_template
          # PhlexKit extras beyond shadcn's four variants.
          render PhlexKit::Badge.new(variant: :success) { "Live" }
          render PhlexKit::Badge.new(variant: :warning) { "Pending" }
          render PhlexKit::Badge.new(size: :sm) { "sm" }
        end
      end
    end
  end
end
