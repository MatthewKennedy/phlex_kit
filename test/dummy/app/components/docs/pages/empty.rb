# frozen_string_literal: true

module Docs
  module Pages
    class Empty < Docs::BasePage
      self.description = "Use the Empty component to display an empty state."

      def demos
        demo Docs::Examples::Empty::Default, title: "Default"
        demo Docs::Examples::Empty::Outline, title: "Outline"
        demo Docs::Examples::Empty::Background, title: "Background"
        demo Docs::Examples::Empty::WithAvatar, title: "Avatar"
        demo Docs::Examples::Empty::WithAvatarGroup, title: "Avatar Group"
        demo Docs::Examples::Empty::WithInputGroup, title: "InputGroup"
      end
    end
  end
end
