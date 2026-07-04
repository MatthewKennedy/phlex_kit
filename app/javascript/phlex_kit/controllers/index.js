// Register PhlexKit's Stimulus controllers under their phlex-kit--* identifiers.
// Call once from your app's Stimulus entrypoint:
//
//   import { Application } from "@hotwired/stimulus"
//   import { registerPhlexKitControllers } from "phlex_kit/controllers"
//   const application = Application.start()
//   registerPhlexKitControllers(application)
//
// The identifiers here MUST match the data-controller names emitted by the
// components (e.g. phlex-kit--dropdown-menu).
import AccordionController from "phlex_kit/controllers/accordion_controller"
import AlertDialogController from "phlex_kit/controllers/alert_dialog_controller"
import AvatarController from "phlex_kit/controllers/avatar_controller"
import CalendarController from "phlex_kit/controllers/calendar_controller"
import CalendarInputController from "phlex_kit/controllers/calendar_input_controller"
import CarouselController from "phlex_kit/controllers/carousel_controller"
import ChartController from "phlex_kit/controllers/chart_controller"
import ClipboardController from "phlex_kit/controllers/clipboard_controller"
import CollapsibleController from "phlex_kit/controllers/collapsible_controller"
import ComboboxController from "phlex_kit/controllers/combobox_controller"
import CommandController from "phlex_kit/controllers/command_controller"
import CommandDialogController from "phlex_kit/controllers/command_dialog_controller"
import ContextMenuController from "phlex_kit/controllers/context_menu_controller"
import DataTableController from "phlex_kit/controllers/data_table_controller"
import DataTableColumnVisibilityController from "phlex_kit/controllers/data_table_column_visibility_controller"
import DataTableSearchController from "phlex_kit/controllers/data_table_search_controller"
import DialogController from "phlex_kit/controllers/dialog_controller"
import DropdownMenuController from "phlex_kit/controllers/dropdown_menu_controller"
import FormFieldController from "phlex_kit/controllers/form_field_controller"
import HoverCardController from "phlex_kit/controllers/hover_card_controller"
import InputOtpController from "phlex_kit/controllers/input_otp_controller"
import MaskedInputController from "phlex_kit/controllers/masked_input_controller"
import MenubarController from "phlex_kit/controllers/menubar_controller"
import MessageScrollerController from "phlex_kit/controllers/message_scroller_controller"
import PopoverController from "phlex_kit/controllers/popover_controller"
import ResizableController from "phlex_kit/controllers/resizable_controller"
import ScrollFadeController from "phlex_kit/controllers/scroll_fade_controller"
import SelectController from "phlex_kit/controllers/select_controller"
import SelectItemController from "phlex_kit/controllers/select_item_controller"
import SheetController from "phlex_kit/controllers/sheet_controller"
import SheetContentController from "phlex_kit/controllers/sheet_content_controller"
import SidebarController from "phlex_kit/controllers/sidebar_controller"
import SliderController from "phlex_kit/controllers/slider_controller"
import TabsController from "phlex_kit/controllers/tabs_controller"
import ThemeToggleController from "phlex_kit/controllers/theme_toggle_controller"
import ToastController from "phlex_kit/controllers/toast_controller"
import ToasterController from "phlex_kit/controllers/toaster_controller"
import ToggleController from "phlex_kit/controllers/toggle_controller"
import ToggleGroupController from "phlex_kit/controllers/toggle_group_controller"

export function registerPhlexKitControllers(application) {
  application.register("phlex-kit--accordion", AccordionController)
  application.register("phlex-kit--alert-dialog", AlertDialogController)
  application.register("phlex-kit--avatar", AvatarController)
  application.register("phlex-kit--calendar", CalendarController)
  application.register("phlex-kit--calendar-input", CalendarInputController)
  application.register("phlex-kit--carousel", CarouselController)
  application.register("phlex-kit--chart", ChartController)
  application.register("phlex-kit--clipboard", ClipboardController)
  application.register("phlex-kit--collapsible", CollapsibleController)
  application.register("phlex-kit--combobox", ComboboxController)
  application.register("phlex-kit--command", CommandController)
  application.register("phlex-kit--command-dialog", CommandDialogController)
  application.register("phlex-kit--context-menu", ContextMenuController)
  application.register("phlex-kit--data-table", DataTableController)
  application.register("phlex-kit--data-table-column-visibility", DataTableColumnVisibilityController)
  application.register("phlex-kit--data-table-search", DataTableSearchController)
  application.register("phlex-kit--dialog", DialogController)
  application.register("phlex-kit--dropdown-menu", DropdownMenuController)
  application.register("phlex-kit--form-field", FormFieldController)
  application.register("phlex-kit--hover-card", HoverCardController)
  application.register("phlex-kit--input-otp", InputOtpController)
  application.register("phlex-kit--masked-input", MaskedInputController)
  application.register("phlex-kit--menubar", MenubarController)
  application.register("phlex-kit--message-scroller", MessageScrollerController)
  application.register("phlex-kit--popover", PopoverController)
  application.register("phlex-kit--resizable", ResizableController)
  application.register("phlex-kit--scroll-fade", ScrollFadeController)
  application.register("phlex-kit--select", SelectController)
  application.register("phlex-kit--select-item", SelectItemController)
  application.register("phlex-kit--sheet", SheetController)
  application.register("phlex-kit--sheet-content", SheetContentController)
  application.register("phlex-kit--sidebar", SidebarController)
  application.register("phlex-kit--slider", SliderController)
  application.register("phlex-kit--tabs", TabsController)
  application.register("phlex-kit--theme-toggle", ThemeToggleController)
  application.register("phlex-kit--toast", ToastController)
  application.register("phlex-kit--toaster", ToasterController)
  application.register("phlex-kit--toggle", ToggleController)
  application.register("phlex-kit--toggle-group", ToggleGroupController)
}
