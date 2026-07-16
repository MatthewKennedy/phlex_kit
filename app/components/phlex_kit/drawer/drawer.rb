module PhlexKit
  # Bottom drawer, ported from shadcn/ui's Drawer. The vaul dependency is
  # replaced by reusing the kit's sheet machinery — the phlex-kit--sheet
  # controller clones DrawerContent's <template> into <body> — with drawer
  # chrome (bottom sheet, grab handle, slide-up animation). Compose Drawer >
  # DrawerTrigger + DrawerContent(DrawerHeader(DrawerTitle + DrawerDescription)
  # + body + DrawerFooter [+ DrawerClose]). `.pk-drawer*` (drawer.css).
  class Drawer < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ data: { controller: "phlex-kit--sheet", phlex_kit__sheet_open_value: @open.to_s } }, @attrs), &)
    end
  end
end
