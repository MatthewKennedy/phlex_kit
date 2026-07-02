module PhlexKit
  # Toast headline. The data-slot lets the toaster fill it when cloning a
  # skeleton. See toast_region.rb.
  class ToastTitle < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-toast-title", data: { slot: "title" } }, @attrs), &)
    end
  end
end
