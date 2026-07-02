# frozen_string_literal: true

module Docs
  module Pages
    class Command < Docs::BasePage
      self.description = "Fast, composable command palette. Fuzzy filtering, ⌘K to open."
      def demos
        demo Docs::Examples::Command::Dialog, title: "Command dialog (⌘K)"
      end
    end
  end
end
