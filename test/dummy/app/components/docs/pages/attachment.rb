# frozen_string_literal: true

module Docs
  module Pages
    class Attachment < Docs::BasePage
      self.description = "A file chip with preview, name, size and actions — for AI-chat style uploads."
      def demos
        demo Docs::Examples::Attachment::Default, title: "Default"
        demo Docs::Examples::Attachment::ImagePreview, title: "Image preview"
      end
    end
  end
end
