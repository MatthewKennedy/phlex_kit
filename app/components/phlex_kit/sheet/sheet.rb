module PhlexKit
  # Side panel (drawer). Ported from ruby_ui's RubyUI::Sheet. Compose Sheet >
  # (SheetTrigger + SheetContent(side:) > SheetHeader/Title/Description/Footer).
  # On open the content template is cloned into <body>. phlex-kit--sheet.
  class Sheet < BaseComponent
    def initialize(open: false, **attrs)
      @open = open
      @attrs = attrs
    end
    def view_template(&)
      div(**mix({ data: { controller: "phlex-kit--sheet", phlex_kit__sheet_open_value: @open.to_s } }, @attrs), &)
    end
  end
end
