# frozen_string_literal: true

module Docs
  module Pages
    class Collapsible < Docs::BasePage
      self.description = "An interactive component which expands/collapses a panel."

      def demos
        demo Docs::Examples::Collapsible::Basic, title: "Basic"
        demo Docs::Examples::Collapsible::SettingsPanel, title: "Settings Panel"
        demo Docs::Examples::Collapsible::FileTree, title: "File Tree"
      end
    end
  end
end
