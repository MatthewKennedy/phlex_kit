module PhlexKit
  # The row that opens a MenubarSub (trailing ▸ chevron). See menubar.rb.
  class MenubarSubTrigger < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template(&block)
      div(**mix({
        class: "pk-menubar-item pk-menubar-sub-trigger",
        role: "menuitem",
        tabindex: "0",
        aria: { haspopup: "menu" }
      }, @attrs)) do
        block&.call
        render Icon.new(:chevron_right, size: nil, class: "pk-menubar-sub-chevron")
      end
    end
  end
end
