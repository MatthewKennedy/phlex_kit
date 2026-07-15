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
        variant: fetch_option(VARIANTS, @variant, :variant),
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

      attrs = { class: "pk-toast", data: data }
      # Defaults only when the caller didn't supply their own — `mix` would
      # fuse role="status log" / tabindex="0 -1" / aria-atomic="true false"
      # instead of overriding.
      unless @attrs.key?(:role) || @attrs.key?("role")
        attrs[:role] = ALERT_VARIANTS.include?(@variant) ? "alert" : "status"
      end
      attrs[:tabindex] = "0" unless @attrs.key?(:tabindex) || @attrs.key?("tabindex")
      unless aria_key_set?(:atomic)
        attrs[:aria] = { atomic: "true" }
      end
      attrs[:id] = @id if @id
      attrs
    end
  end
end
