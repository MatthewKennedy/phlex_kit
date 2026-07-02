# frozen_string_literal: true

module Docs
  module Pages
    class Empty < Docs::BasePage
      self.description = "Use the Empty component to display an empty state."
      def demos
        demo Docs::Examples::Empty::Default, title: "No projects"
      end
    end
  end
end
