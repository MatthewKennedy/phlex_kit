module PhlexKit
  # The row that opens a MenubarSub (trailing ▸ chevron). See menubar.rb.
  class MenubarSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      base = { class: "pk-menubar-item pk-menubar-sub-trigger" }
      # Defaults only when the caller didn't supply their own — `mix` fuses.
      base[:role] = "menuitem" unless attr_set?(:role)
      # -1: the roving focus reaches it via arrows (focus-within opens the
      # sub); tabindex 0 made it a stray tab stop inside the open panel.
      base[:tabindex] = "-1" unless attr_set?(:tabindex)
      base[:"aria-haspopup"] = "menu" unless aria_key_set?(:haspopup)
      # expanded starts false; the sub is revealed by CSS (:hover /
      # :focus-within), so MenubarSub's syncSub actions mirror that state
      # onto this attribute.
      base[:"aria-expanded"] = "false" unless aria_key_set?(:expanded)
      div(**mix(base, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-menubar-sub-chevron")
      end
    end
  end
end
