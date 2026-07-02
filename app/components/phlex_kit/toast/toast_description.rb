module PhlexKit
  # Muted secondary line under a PhlexKit::ToastTitle. The toaster removes it from a
  # cloned skeleton when the spawn has no description. See toast_region.rb.
  class ToastDescription < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-toast-description", data: { slot: "description" } }, @attrs), &)
    end
  end
end
