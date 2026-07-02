# frozen_string_literal: true

module Docs
  module Examples
    module Toast
      class Default < Phlex::HTML
        def view_template
          # The ToastRegion is mounted once in the site layout; these buttons
          # spawn into it via the global API.
          render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("PhlexKit.toast('Event has been created')")) { "Default" }
          render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("PhlexKit.toast.success('Saved', { description: 'Your changes are live.' })")) { "Success" }
          render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("PhlexKit.toast.error('Something went wrong')")) { "Error" }
          render PhlexKit::Button.new(variant: :outline, size: :sm, onclick: safe("PhlexKit.toast.promise(new Promise(r => setTimeout(r, 1500)), { loading: 'Saving…', success: 'Saved', error: 'Failed' })")) { "Promise" }
        end
      end
    end
  end
end
