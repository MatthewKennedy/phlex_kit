module PhlexKit
  # Toast region ("toaster"), ported from ruby_ui's RubyUI::ToastRegion. Renders
  # the fixed, position-anchored <ol> stack plus hidden <template> skeletons (one
  # per variant) and action/cancel/close slot templates. The phlex-kit--toaster
  # controller clones those to spawn toasts client-side — via
  # `window.PhlexKit.toast(...)`, a "phlex-kit:toast" window event, or the `toast`
  # Turbo Stream action. Pass `flash:` to render server-side flash messages as
  # toasts on page load. Per-toast behaviour (timer, swipe) lives on each
  # PhlexKit::ToastItem. Tailwind → vanilla `.pk-toast*` (toast.css).
  class ToastRegion < BaseComponent
    SKELETON_VARIANTS = %i[default success error warning info loading].freeze

    POSITIONS = {
      top_left: "top-left",
      top_center: "top-center",
      top_right: "top-right",
      bottom_left: "bottom-left",
      bottom_center: "bottom-center",
      bottom_right: "bottom-right"
    }.freeze

    def initialize(
      position: :bottom_right,
      expand: false,
      max: 3,
      duration: 4000,
      gap: 14,
      offset: 24,
      theme: :system,
      rich_colors: false,
      close_button: false,
      hotkey: %w[alt t],
      dir: :ltr,
      flash: nil,
      **attrs
    )
      @position = POSITIONS.fetch(position.to_sym)
      @expand = expand
      @max = max
      @duration = duration
      @gap = gap
      @offset = offset
      @theme = theme.to_sym
      @rich_colors = rich_colors
      @close_button = close_button
      @hotkey = hotkey
      @dir = dir
      @flash = flash
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix(region_attrs, @attrs)) do
        ol(id: "pk-toaster", class: "pk-toast-list") do
          render_flash if @flash
          yield(self) if block
        end
        SKELETON_VARIANTS.each { |variant| skeleton(variant) }
        slot_template("actionTpl") { render ToastAction.new(label: "") }
        slot_template("cancelTpl") { render ToastCancel.new(label: "") }
        slot_template("closeTpl") { render ToastClose.new }
      end
    end

    private

    def render_flash
      @flash.each do |key, message|
        next if message.nil? || message.to_s.empty?
        variant = Toast.flash_variant(key)
        render ToastItem.new(variant: variant, id: "flash-#{key}") do
          render ToastIcon.new(variant: variant)
          render ToastTitle.new { message.to_s }
        end
      end
    end

    def skeleton(variant)
      template(data: { phlex_kit__toaster_target: "skeleton", variant: variant.to_s }) do
        render ToastItem.new(variant: variant) do
          render ToastIcon.new(variant: variant)
          div(class: "pk-toast-body") do
            render ToastTitle.new
            render ToastDescription.new
          end
          render ToastClose.new if @close_button
        end
      end
    end

    def slot_template(target_name, &)
      template(data: { phlex_kit__toaster_target: target_name }, &)
    end

    def region_attrs
      {
        id: "pk-toaster-region",
        role: "region",
        class: "pk-toast-region",
        aria: { label: "Notifications", live: "polite" },
        data: {
          controller: "phlex-kit--toaster",
          turbo_permanent: "",
          close_button: @close_button.to_s,
          position: @position,
          phlex_kit__toaster_position_value: @position,
          phlex_kit__toaster_expand_value: @expand.to_s,
          phlex_kit__toaster_max_value: @max.to_s,
          phlex_kit__toaster_duration_value: @duration.to_s,
          phlex_kit__toaster_gap_value: @gap.to_s,
          phlex_kit__toaster_offset_value: @offset.to_s,
          phlex_kit__toaster_theme_value: @theme.to_s,
          phlex_kit__toaster_rich_colors_value: @rich_colors.to_s,
          phlex_kit__toaster_close_button_value: @close_button.to_s,
          phlex_kit__toaster_hotkey_value: Array(@hotkey).join("+"),
          phlex_kit__toaster_dir_value: @dir.to_s
        }
      }
    end
  end
end
