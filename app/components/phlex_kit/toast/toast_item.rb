module PhlexKit
  # A single toast <li> — rendered server-side (flash) or cloned from a skeleton
  # template by the toaster. The phlex-kit--toast controller runs the auto-close
  # timer (pause on hover), swipe-to-dismiss, and Escape. The toaster stacks it
  # via inline --y-offset/--scale/--opacity. See toast_region.rb.
  class ToastItem < BaseComponent
    VARIANTS = {
      default: "default",
      success: "success",
      error: "error",
      warning: "warning",
      info: "info",
      loading: "loading"
    }.freeze

    # Variants announced assertively (role="alert" instead of "status").
    ALERT_VARIANTS = %i[error].freeze

    def initialize(
      variant: :default,
      id: nil,
      duration: nil,
      dismissible: true,
      invert: false,
      on_dismiss: nil,
      on_auto_close: nil,
      **attrs
    )
      @variant = variant.to_sym
      @id = id
      @duration = duration
      @dismissible = dismissible
      @invert = invert
      @on_dismiss = on_dismiss
      @on_auto_close = on_auto_close
      @attrs = attrs
    end

    def view_template(&)
      li(**mix(item_attrs, @attrs), &)
    end

    private

    def item_attrs
      data = {
        variant: VARIANTS.fetch(@variant),
        state: "pending",
        swipe: "none",
        controller: "phlex-kit--toast",
        phlex_kit__toaster_target: "toast",
        phlex_kit__toast_dismissible_value: @dismissible.to_s,
        phlex_kit__toast_invert_value: @invert.to_s
      }
      data[:phlex_kit__toast_duration_value] = @duration.to_s if @duration
      data[:phlex_kit__toast_on_dismiss_value] = @on_dismiss if @on_dismiss
      data[:phlex_kit__toast_on_auto_close_value] = @on_auto_close if @on_auto_close

      attrs = {
        role: ALERT_VARIANTS.include?(@variant) ? "alert" : "status",
        tabindex: "0",
        class: "pk-toast",
        aria: { atomic: "true" },
        data: data
      }
      attrs[:id] = @id if @id
      attrs
    end
  end
end
