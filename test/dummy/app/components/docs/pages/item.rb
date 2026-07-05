# frozen_string_literal: true

module Docs
  module Pages
    class Item < Docs::BasePage
      self.description = "A flexible list row: media, content, and actions."

      def demos
        demo Docs::Examples::Item::Variant, title: "Variant"
        demo Docs::Examples::Item::Size, title: "Size"
        demo Docs::Examples::Item::WithIcon, title: "Icon"
        demo Docs::Examples::Item::WithAvatar, title: "Avatar"
        demo Docs::Examples::Item::WithImage, title: "Image"
        demo Docs::Examples::Item::Group, title: "Group"
        demo Docs::Examples::Item::Header, title: "Header"
        demo Docs::Examples::Item::Link, title: "Link"
        demo Docs::Examples::Item::Dropdown, title: "Dropdown"
      end
    end
  end
end
