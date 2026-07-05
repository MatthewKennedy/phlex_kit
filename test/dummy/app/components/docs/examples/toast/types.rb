# frozen_string_literal: true

module Docs
  module Examples
    module Toast
      class Types < Phlex::HTML
        def view_template
          div(class: "row") do
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast('Event has been created')")) { "Default" }
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast.success('Event has been created')")) { "Success" }
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast.info('Be at the area 10 minutes before the event time')")) { "Info" }
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast.warning('Event start time cannot be earlier than 8am')")) { "Warning" }
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast.error('Event has not been created')")) { "Error" }
            render PhlexKit::Button.new(variant: :outline, onclick: safe("PhlexKit.toast.promise(new Promise(r => setTimeout(() => r('Event'), 2000)), { loading: 'Loading...', success: (name) => name + ' has been created', error: 'Error' })")) { "Promise" }
          end
        end
      end
    end
  end
end
