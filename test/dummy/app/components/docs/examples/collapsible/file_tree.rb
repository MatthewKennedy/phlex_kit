# frozen_string_literal: true

module Docs
  module Examples
    module Collapsible
      class FileTree < Phlex::HTML
        TREE = [
          [ "components", [
            [ "ui", [ "button.rb", "card.rb", "dialog.rb", "input.rb", "select.rb", "table.rb" ] ],
            "login_form.rb", "register_form.rb"
          ] ],
          [ "lib", [ "utils.rb", "api.rb" ] ],
          [ "config", [ "routes.rb", "importmap.rb" ] ],
          "app.rb", "Gemfile", "README.md", ".gitignore"
        ].freeze

        def view_template
          div(class: "w-sm") do
            render PhlexKit::Card.new(size: :sm) do
              render PhlexKit::CardContent.new do
                div(style: "display: flex; flex-direction: column; gap: .25rem;") { TREE.each { |item| tree_item(item) } }
              end
            end
          end
        end

        private

        def tree_item(item)
          name, children = item.is_a?(Array) ? item : [ item, nil ]
          if children
            render PhlexKit::Collapsible.new do
              render PhlexKit::CollapsibleTrigger.new do
                render PhlexKit::Button.new(variant: :ghost, size: :sm, style: "width: 100%; justify-content: flex-start;") do
                  render PhlexKit::Icon.new(:chevron_right, size: nil, class: "pk-collapsible-chevron", style: "--pk-collapsible-rotate: 90deg")
                  render PhlexKit::Icon.new(:folder, size: nil)
                  plain name
                end
              end
              render PhlexKit::CollapsibleContent.new(style: "margin: .25rem 0 0 1.25rem; display: flex; flex-direction: column; gap: .25rem;") do
                children.each { |child| tree_item(child) }
              end
            end
          else
            render PhlexKit::Button.new(variant: :ghost, size: :sm, style: "width: 100%; justify-content: flex-start; padding-left: 2rem;") do
              render PhlexKit::Icon.new(:file, size: nil)
              plain name
            end
          end
        end
      end
    end
  end
end
