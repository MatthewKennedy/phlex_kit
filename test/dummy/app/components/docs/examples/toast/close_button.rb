# frozen_string_literal: true

module Docs
  module Examples
    module Toast
      # A dedicated region rendered with close_button: true — its skeletons bake
      # a × in. Spawning INTO it with closeButton: true must not stack a second
      # one (audit round 9, phase 2). Distinct id so it routes independently of
      # the shared layout region.
      class CloseButton < Phlex::HTML
        def view_template
          render PhlexKit::ToastRegion.new(id: "pk-toaster-cb", close_button: true)
          render PhlexKit::Button.new(
            variant: :outline, size: :sm,
            onclick: safe("PhlexKit.toast('Saved', { region: 'pk-toaster-cb', closeButton: true, id: 'cb-toast' })")
          ) { "With close button" }
        end
      end
    end
  end
end
