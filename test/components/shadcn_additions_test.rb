# frozen_string_literal: true

require "test_helper"

# shadcn/ui components beyond the ruby_ui catalog (tier 1 — CSS-only).
class ShadcnAdditionsTest < Minitest::Test
  include RenderHelper

  def test_spinner_sizes_fail_loud
    assert_includes render(PhlexKit::Spinner.new), "pk-spinner"
    assert_includes render(PhlexKit::Spinner.new(size: :lg)), "pk-spinner lg"
    assert_includes render(PhlexKit::Spinner.new), %(aria-label="Loading")
    assert_raises(KeyError) { render(PhlexKit::Spinner.new(size: :xxl)) }
  end

  def test_kbd_and_group
    assert_includes render(PhlexKit::Kbd.new { "K" }), "<kbd"
    assert_includes render(PhlexKit::KbdGroup.new { "x" }), "pk-kbd-group"
  end

  def test_label_binds
    html = render(PhlexKit::Label.new(for: "email") { "Email" })
    assert_includes html, %(for="email")
    assert_includes html, "pk-label"
  end

  def test_button_group_is_a_group
    assert_includes render(PhlexKit::ButtonGroup.new { "x" }), %(role="group")
  end

  def test_item_family
    html = render(PhlexKit::Item.new(variant: :outline) { "x" })
    assert_includes html, "pk-item outline"
    assert_raises(KeyError) { render(PhlexKit::Item.new(variant: :bad) { "x" }) }
    assert_includes render(PhlexKit::ItemContent.new { "x" }), "pk-item-content"
    # No role="list": Items carry no listitem role (audit round 4).
    assert_includes render(PhlexKit::ItemGroup.new { "x" }), "pk-item-group"
  end

  def test_input_group_addon_aligns
    assert_includes render(PhlexKit::InputGroup.new { "x" }), %(role="group")
    assert_includes render(PhlexKit::InputGroupAddon.new(align: :end) { "x" }), "pk-input-group-addon end"
    assert_raises(KeyError) { render(PhlexKit::InputGroupAddon.new(align: :middle) { "x" }) }
    assert_includes render(PhlexKit::InputGroupText.new { "@" }), "pk-input-group-text"
  end

  def test_radio_group_role
    assert_includes render(PhlexKit::RadioGroup.new { "x" }), %(role="radiogroup")
  end

  def test_scroll_area_is_focusable
    html = render(PhlexKit::ScrollArea.new { "x" })
    assert_includes html, "pk-scroll-area"
    assert_includes html, %(tabindex="0")
  end

  def test_slider_syncs_progress
    html = render(PhlexKit::Slider.new(min: 0, max: 200, value: 50, name: "volume"))
    assert_includes html, %(type="range")
    assert_includes html, "--pk-slider-progress: 25.0%"
    assert_includes html, "input->phlex-kit--slider#update"
  end

  def test_input_otp_wires_slots_and_hidden_value
    html = render(PhlexKit::InputOtp.new(length: 4, name: "code"))
    assert_includes html, %(data-phlex-kit--input-otp-length-value="4")
    assert_includes html, %(type="hidden")
    assert_includes render(PhlexKit::InputOtpGroup.new { "x" }), "pk-input-otp-group"
    slot = render(PhlexKit::InputOtpSlot.new)
    assert_includes slot, %(autocomplete="one-time-code")
    assert_includes slot, %(maxlength="1")
    assert_includes slot, "paste->phlex-kit--input-otp#onPaste"
  end

  def test_drawer_reuses_sheet_machinery
    html = render(PhlexKit::Drawer.new { "x" })
    assert_includes html, "phlex-kit--sheet"
    content = render(PhlexKit::DrawerContent.new { "body" })
    assert_includes content, "<template"
    assert_includes content, "pk-drawer-handle"
    assert_includes content, "click->phlex-kit--sheet-content#close"
    assert_includes content, %(role="dialog")
    assert_includes render(PhlexKit::DrawerTrigger.new { "t" }), "click->phlex-kit--sheet#open"
  end

  def test_resizable_group_direction_fails_loud
    html = render(PhlexKit::ResizablePanelGroup.new { "x" })
    assert_includes html, "phlex-kit--resizable"
    assert_includes html, "pk-resizable-group horizontal"
    assert_raises(KeyError) { render(PhlexKit::ResizablePanelGroup.new(direction: :diagonal) { "x" }) }
    assert_includes render(PhlexKit::ResizablePanel.new(default_size: 25) { "x" }), "flex-grow: 25"
    assert_includes render(PhlexKit::ResizableHandle.new), "pointerdown->phlex-kit--resizable#start"
  end

  def test_menubar_wiring
    assert_includes render(PhlexKit::Menubar.new { "x" }), %(role="menubar")
    assert_includes render(PhlexKit::MenubarMenu.new { "x" }), %(data-phlex-kit--menubar-target="menu")
    trigger = render(PhlexKit::MenubarTrigger.new { "File" })
    assert_includes trigger, "click->phlex-kit--menubar#toggle"
    assert_includes trigger, "mouseenter->phlex-kit--menubar#switch"
    assert_includes render(PhlexKit::MenubarContent.new { "x" }), %(class="pk-menubar-content" popover="manual")
    item = render(PhlexKit::MenubarItem.new(shortcut: "⌘T") { "New Tab" })
    assert_includes item, "pk-menubar-shortcut"
    assert_includes item, "click->phlex-kit--menubar#close"
  end

  def test_navigation_menu_hover_mode
    html = render(PhlexKit::NavigationMenu.new { "x" })
    assert_includes html, "phlex-kit--menubar"
    assert_includes html, "data-hover-open"
    assert_includes html, "mouseleave->phlex-kit--menubar#close"
    assert_includes render(PhlexKit::NavigationMenuItem.new { "x" }), %(data-phlex-kit--menubar-target="menu")
    assert_includes render(PhlexKit::NavigationMenuContent.new { "x" }), %(class="pk-navigation-menu-content" popover="manual")
    assert_includes render(PhlexKit::NavigationMenuLink.new(href: "/docs") { "Docs" }), %(href="/docs")
  end

  def test_attachment_family
    assert_includes render(PhlexKit::Attachment.new { "x" }), "pk-attachment"
    assert_includes render(PhlexKit::AttachmentMedia.new { "x" }), "pk-attachment-media"
    assert_includes render(PhlexKit::AttachmentTitle.new { "report.pdf" }), "pk-attachment-title"
    assert_includes render(PhlexKit::AttachmentDescription.new { "PDF · 2.4 MB" }), "pk-attachment-description"
    action = render(PhlexKit::AttachmentAction.new(aria: { label: "Remove report.pdf" }))
    assert_includes action, %(aria-label="Remove report.pdf")
    assert_includes action, "<svg" # default × icon
  end

  def test_avatar_group_overlaps
    assert_includes render(PhlexKit::AvatarGroup.new { "x" }), "pk-avatar-group"
  end

  def test_marker_variants_fail_loud
    assert_includes render(PhlexKit::Marker.new { "x" }), "pk-marker"
    assert_includes render(PhlexKit::Marker.new(variant: :border) { "x" }), "pk-marker border"
    assert_includes render(PhlexKit::Marker.new(variant: :separator) { "x" }), "pk-marker separator"
    assert_raises(KeyError) { render(PhlexKit::Marker.new(variant: :loud) { "x" }) }
    assert_includes render(PhlexKit::MarkerIcon.new { "✓" }), "pk-marker-icon"
    assert_includes render(PhlexKit::MarkerContent.new { "Done" }), "pk-marker-content"
  end

  def test_card_action_and_size
    assert_includes render(PhlexKit::CardAction.new { "x" }), "pk-card-action"
    assert_includes render(PhlexKit::Card.new(size: :sm) { "x" }), "pk-card sm"
    assert_raises(KeyError) { render(PhlexKit::Card.new(size: :xl) { "x" }) }
  end

  def test_alert_dialog_media_size_and_destructive_action
    assert_includes render(PhlexKit::AlertDialogMedia.new { "x" }), "pk-alert-dialog-media"
    assert_includes render(PhlexKit::AlertDialogContent.new(size: :sm) { "x" }), "pk-alert-dialog-panel sm"
    assert_raises(KeyError) { render(PhlexKit::AlertDialogContent.new(size: :xl) { "x" }) }
    assert_includes render(PhlexKit::AlertDialogAction.new(variant: :destructive) { "Delete" }), "pk-button destructive"
  end

  def test_alert_dialog_cancel_caller_data_merges_with_dismiss_action
    html = render(PhlexKit::AlertDialogCancel.new(data: { testid: "cancel" }) { "Cancel" })
    assert_includes html, "click->phlex-kit--alert-dialog#dismiss"
    assert_includes html, %(data-testid="cancel")
  end

  def test_attachment_states_sizes_orientation
    assert_includes render(PhlexKit::Attachment.new(state: :uploading) { "x" }), %(data-state="uploading")
    assert_includes render(PhlexKit::Attachment.new(size: :xs, orientation: :vertical) { "x" }), "pk-attachment xs vertical"
    assert_raises(KeyError) { render(PhlexKit::Attachment.new(state: :bad) { "x" }) }
    assert_includes render(PhlexKit::AttachmentMedia.new(variant: :image) { "x" }), "pk-attachment-media image"
    trigger = render(PhlexKit::AttachmentTrigger.new(as: :a, href: "/f.pdf", aria: { label: "Open f.pdf" }))
    assert_includes trigger, %(href="/f.pdf")
    group = render(PhlexKit::AttachmentGroup.new { "x" })
    assert_includes group, "phlex-kit--scroll-fade"
    assert_includes group, %(data-phlex-kit--scroll-fade-axis-value="x")
  end

  def test_dropdown_menu_shadcn_parts
    assert_includes render(PhlexKit::DropdownMenuGroup.new { "x" }), %(role="group")
    assert_includes render(PhlexKit::DropdownMenuShortcut.new { "⌘K" }), "pk-dropdown-menu-shortcut"
    assert_includes render(PhlexKit::DropdownMenuItem.new(variant: :destructive) { "Delete" }), "pk-dropdown-menu-item destructive"
    assert_raises(KeyError) { render(PhlexKit::DropdownMenuItem.new(variant: :loud) { "x" }) }
    cb = render(PhlexKit::DropdownMenuCheckboxItem.new(checked: true, name: "status") { "Status Bar" })
    assert_includes cb, %(role="menuitemcheckbox")
    assert_includes cb, "checked"
    radio = render(PhlexKit::DropdownMenuRadioItem.new(name: "pos", value: "top", checked: true) { "Top" })
    assert_includes radio, %(role="menuitemradio")
    assert_includes render(PhlexKit::DropdownMenuSubTrigger.new { "More" }), %(aria-haspopup="menu")
    assert_includes render(PhlexKit::DropdownMenuSubContent.new { "x" }), "pk-dropdown-menu-viewport"
    assert_includes render(PhlexKit::DropdownMenuContent.new(side: :right) { "x" }), "pk-dropdown-menu-content-right"
    assert_includes render(PhlexKit::DropdownMenuContent.new(side: :left) { "x" }), "pk-dropdown-menu-content-left"
    assert_raises(KeyError) { render(PhlexKit::DropdownMenuContent.new(side: :diagonal) { "x" }) }
  end

  def test_accordion_type_and_disabled
    assert_includes render(PhlexKit::Accordion.new { "x" }), %(data-type="single")
    assert_includes render(PhlexKit::Accordion.new(type: :multiple) { "x" }), %(data-type="multiple")
    assert_raises(KeyError) { render(PhlexKit::Accordion.new(type: :tabs) { "x" }) }
    assert_includes render(PhlexKit::AccordionItem.new(disabled: true) { "x" }), "data-disabled"
  end

  def test_stars_is_gone
    refute PhlexKit.const_defined?(:Stars), "stars was dropped in favour of shadcn parity"
  end
end
