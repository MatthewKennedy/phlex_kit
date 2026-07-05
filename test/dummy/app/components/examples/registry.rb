# frozen_string_literal: true

module Examples
  # Ordered map of the admin-UI example pages (an explicit constant map, not a
  # filesystem glob like Docs::Registry — order here mirrors the source
  # layouts in grid-layout/admin-ui, and the slugs are the routes).
  module Registry
    def self.all
      @all ||= {
        "dashboard-cards" => {
          title: "Dashboard",
          layout: "sidebar + bento grid",
          blurb: "KPI row and a bento grid of charts, feeds and tables inside the kit's sidebar shell.",
          page: Examples::Pages::DashboardCards
        },
        "sidebar-header" => {
          title: "Orders",
          layout: "sidebar + header",
          blurb: "The classic app frame: nav rail, header with search, tabbed table and pagination.",
          page: Examples::Pages::SidebarHeader
        },
        "master-detail" => {
          title: "Orders inbox",
          layout: "master–detail",
          blurb: "A list pane beside a pinned-header detail pane with its own scrolling body.",
          page: Examples::Pages::MasterDetail
        },
        "holy-grail" => {
          title: "Customer profile",
          layout: "holy grail",
          blurb: "Header, section nav, content and a widget aside in the three-column classic.",
          page: Examples::Pages::HolyGrail
        },
        "header-top" => {
          title: "Reports",
          layout: "top nav",
          blurb: "No sidebar — a top navigation bar over summary cards and a full-width chart.",
          page: Examples::Pages::HeaderTop
        },
        "settings-form" => {
          title: "Settings",
          layout: "sticky rail + form",
          blurb: "A sticky section rail beside stacked, responsive form sections with a save bar.",
          page: Examples::Pages::SettingsForm
        }
      }.freeze
    end
  end
end
