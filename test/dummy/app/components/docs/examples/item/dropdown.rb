# frozen_string_literal: true

module Docs
  module Examples
    module Item
      class Dropdown < Phlex::HTML
        def view_template
          div(class: "w-sm") do
            render PhlexKit::Item.new(variant: :outline) do
              render PhlexKit::ItemMedia.new do
                render PhlexKit::Avatar.new do
                  render PhlexKit::AvatarImage.new(src: "https://github.com/shadcn.png", alt: "@shadcn")
                  render PhlexKit::AvatarFallback.new { "CN" }
                end
              end
              render PhlexKit::ItemContent.new do
                render PhlexKit::ItemTitle.new { "shadcn" }
                render PhlexKit::ItemDescription.new { "shadcn@vercel.com" }
              end
              render PhlexKit::ItemActions.new do
                render PhlexKit::DropdownMenu.new do
                  render PhlexKit::DropdownMenuTrigger.new do
                    render PhlexKit::Button.new(variant: :ghost, icon: true, aria: { label: "Open menu" }) do
                      render PhlexKit::Icon.new(:ellipsis, size: nil)
                    end
                  end
                  render PhlexKit::DropdownMenuContent.new do
                    render PhlexKit::DropdownMenuItem.new(href: "#") { "View profile" }
                    render PhlexKit::DropdownMenuItem.new(href: "#") { "Message" }
                    render PhlexKit::DropdownMenuSeparator.new
                    render PhlexKit::DropdownMenuItem.new(href: "#", variant: :destructive) { "Remove" }
                  end
                end
              end
            end
          end
        end
      end
    end
  end
end
