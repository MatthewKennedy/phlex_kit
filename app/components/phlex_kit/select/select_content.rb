module PhlexKit
  # The dropdown panel for PhlexKit::Select — a native [popover=manual] the
  # controller toggles, anchor-positioned to the trigger with viewport-edge
  # flipping (select.css). Outer div is the positioned/targeted layer; the
  # inner `.pk-select-viewport` is the bordered, scrollable box.
  # Holds SelectGroup / SelectLabel / SelectItem children. See select.rb.
  class SelectContent < BaseComponent
    # id: is a named kwarg (not left in **attrs) because `mix` would *merge* a
    # caller id with the generated one into an invalid two-token id, breaking
    # aria-controls and the generated item ids.
    def initialize(id: nil, **attrs)
      @id = id || "pk-select-content-#{SecureRandom.hex(4)}"
      @attrs = attrs
    end

    def view_template(&block)
      div(**mix({
        id: @id,
        role: "listbox",
        tabindex: "-1",
        class: "pk-select-content",
        popover: "manual",
        data: {
          phlex_kit__select_target: "content",
          action: "keydown->phlex-kit--select#typeahead"
        }
      }, @attrs)) do
        div(class: "pk-select-viewport", &block)
      end
    end
  end
end
