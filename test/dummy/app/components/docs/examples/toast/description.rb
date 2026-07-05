# frozen_string_literal: true

module Docs
  module Examples
    module Toast
      class Description < Phlex::HTML
        def view_template
          render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast('Event has been created', { description: 'Monday, January 3rd at 6:00pm' })")) { "Show Toast" }
        end
      end
    end
  end
end
