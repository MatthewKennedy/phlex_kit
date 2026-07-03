# frozen_string_literal: true

module Docs
  module Pages
    class Attachment < Docs::BasePage
      self.description = "Displays a file or image attachment with media, metadata, upload state, and actions."
      def demos
        demo Docs::Examples::Attachment::Default, title: "Default"
        demo Docs::Examples::Attachment::ImagePreview, title: "Image"
        demo Docs::Examples::Attachment::States, title: "States"
        demo Docs::Examples::Attachment::Sizes, title: "Sizes"
        demo Docs::Examples::Attachment::Group, title: "Group"
        demo Docs::Examples::Attachment::Trigger, title: "Trigger"
      end
    end
  end
end
