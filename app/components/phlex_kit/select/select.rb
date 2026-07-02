module PhlexKit
  # Custom dropdown select, ported from ruby_ui's RubyUI::Select — the styled
  # popover (Image #2), NOT the native <select> (that's PhlexKit::NativeSelect). Unlike
  # the rest of the kit this component IS JS-driven: it keeps ruby_ui's Stimulus
  # wiring (`phlex-kit--select` / `phlex-kit--select-item`, in
  # app/javascript/controllers/ruby_ui/), since the open/close, selection, and
  # keyboard nav are the point. The one change from upstream: the controller drops
  # the `@floating-ui/dom` dependency and positions the panel with plain CSS
  # (opens directly below the trigger). Tailwind → vanilla `.pk-select-*` (select.css).
  #
  # Multi-part. The hidden SelectInput carries the form value/name; SelectTrigger +
  # SelectValue are the closed-state button; SelectContent > SelectGroup >
  # (SelectLabel +) SelectItem are the panel:
  #
  #   render PhlexKit::Select.new do
  #     render PhlexKit::SelectInput.new(name: "user[role]", id: "user_role", value: @user.role)
  #     render PhlexKit::SelectTrigger.new do
  #       render PhlexKit::SelectValue.new(placeholder: "Select a role") { @user.role&.capitalize }
  #     end
  #     render PhlexKit::SelectContent.new do
  #       render PhlexKit::SelectGroup.new do
  #         render PhlexKit::SelectItem.new(value: "admin", "aria-selected": "true") { "Admin" }
  #       end
  #     end
  #   end
  class Select < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        class: "pk-select",
        data: {
          controller: "phlex-kit--select",
          phlex_kit__select_open_value: "false",
          action: "click@window->phlex-kit--select#clickOutside",
          phlex_kit__select_phlex_kit__select_item_outlet: ".pk-select-item"
        }
      }, @attrs), &block)
    end
  end
end
