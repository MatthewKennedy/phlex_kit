# frozen_string_literal: true

module Docs
  module Examples
    module Combobox
      class CustomItems < Phlex::HTML
        USERS = [
          %w[shadcn shadcn@vercel.com CN],
          %w[maxleiter maxleiter@vercel.com LR],
          %w[evilrabbit evilrabbit@vercel.com ER]
        ].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Combobox.new do
              render PhlexKit::ComboboxInputTrigger.new(placeholder: "Assign to...")
              render PhlexKit::ComboboxPopover.new do
                render PhlexKit::ComboboxList.new do
                  USERS.each do |username, email, initials|
                    render PhlexKit::ComboboxItem.new do
                      # data-text scopes filtering to the username, not the whole row.
                      render PhlexKit::ComboboxRadio.new(name: "cb-assignee", value: username, data: { text: username })
                      render PhlexKit::Avatar.new(size: :sm) do
                        render PhlexKit::AvatarImage.new(src: "https://github.com/#{username}.png", alt: "@#{username}")
                        render PhlexKit::AvatarFallback.new { initials }
                      end
                      div(style: "display: flex; flex-direction: column; min-width: 0;") do
                        span { username }
                        span(style: "font-size: .75rem; color: var(--pk-muted);") { email }
                      end
                      render PhlexKit::ComboboxItemIndicator.new
                    end
                  end
                  render PhlexKit::ComboboxEmptyState.new { "No people found." }
                end
              end
            end
          end
        end
      end
    end
  end
end
