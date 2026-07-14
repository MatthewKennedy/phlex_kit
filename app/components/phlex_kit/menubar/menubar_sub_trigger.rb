module PhlexKit
  # The row that opens a MenubarSub (trailing ▸ chevron). See menubar.rb.
  class MenubarSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      div(**mix({
        class: "pk-menubar-item pk-menubar-sub-trigger",
        role: "menuitem",
        # -1: the roving focus reaches it via arrows (focus-within opens the
        # sub); tabindex 0 made it a stray tab stop inside the open panel.
        tabindex: "-1",
        aria: { haspopup: "menu" }
      }, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-menubar-sub-chevron")
      end
    end
  end
end
