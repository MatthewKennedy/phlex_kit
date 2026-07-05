# frozen_string_literal: true

module Docs
  module Pages
    class Command < Docs::BasePage
      self.description = "Fast, composable command palette. Fuzzy filtering, ⌘K to open."

      def demos
        demo Docs::Examples::Command::Basic, title: "Basic"
        demo Docs::Examples::Command::Shortcuts, title: "Shortcuts"
        demo Docs::Examples::Command::Groups, title: "Groups"
        demo Docs::Examples::Command::Scrollable, title: "Scrollable"
        demo Docs::Examples::Command::Dialog, title: "Command dialog (⌘K)"
      end
    end
  end
end
