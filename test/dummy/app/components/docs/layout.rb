# frozen_string_literal: true

module Docs
  # Site chrome: PhlexKit sidebar listing every documented component, content
  # inset, theme toggle. The docs site IS a PhlexKit app — the menu, tabs and
  # code blocks are the kit's own components.
  class Layout < Phlex::HTML
    include Phlex::Rails::Helpers::StylesheetLinkTag
    include Phlex::Rails::Helpers::JavaScriptImportmapTags
    include Phlex::Rails::Helpers::JavaScriptIncludeTag

    def initialize(current:)
      @current = current
    end

    def view_template(&block)
      doctype
      html(data_theme: "dark") do
        head do
          title { "#{Docs::Registry.all.dig(@current, :title)} — PhlexKit" }
          meta(charset: "utf-8")
          meta(name: "viewport", content: "width=device-width,initial-scale=1")
          stylesheet_link_tag "phlex_kit/phlex_kit"
          javascript_include_tag "chartjs.umd"
          javascript_importmap_tags
          style { docs_css }
        end
        body do
          render PhlexKit::SidebarWrapper.new(class: "docs-shell") do
            render PhlexKit::Sidebar.new(class: "docs-sidebar") do
              render PhlexKit::SidebarHeader.new do
                a(href: "/", class: "docs-brand") { "PhlexKit" }
                render PhlexKit::ThemeToggle.new { "🌓" }
              end
              render PhlexKit::SidebarContent.new do
                render PhlexKit::SidebarGroup.new do
                  render PhlexKit::SidebarMenu.new do
                    Docs::Registry.all.each do |slug, entry|
                      render PhlexKit::SidebarMenuItem.new do
                        render PhlexKit::SidebarMenuButton.new(as: :a, href: "/docs/#{slug}", active: slug == @current) do
                          entry[:title]
                        end
                      end
                    end
                  end
                end
              end
              render PhlexKit::SidebarFooter.new do
                a(href: "/gallery", class: "docs-footer-link") { "Kitchen-sink gallery →" }
              end
            end
            render PhlexKit::SidebarInset.new(class: "docs-main") do
              yield if block
              render PhlexKit::ToastRegion.new(close_button: true)
            end
          end
        end
      end
    end

    private

    def docs_css
      <<~CSS
        body { margin: 0; background: var(--pk-bg); color: var(--pk-text);
               font: 15px/1.6 system-ui, -apple-system, sans-serif; }
        .docs-shell { min-height: 100vh; }
        .docs-sidebar { position: sticky; top: 0; height: 100vh; overflow-y: auto; width: 240px; flex: none; }
        .docs-sidebar a { text-decoration: none; }
        .docs-brand { font-weight: 700; color: var(--pk-text); text-decoration: none; margin-right: auto; }
        .docs-footer-link { color: var(--pk-muted); text-decoration: none; font-size: .8rem; }
        .docs-main { flex: 1; min-width: 0; padding: 2.5rem clamp(1.5rem, 5vw, 4rem) 6rem; max-width: 960px; }
        .docs-page-header { margin-bottom: 2rem; }
        .docs-page-header h1 { margin: 0 0 .5rem; font-size: 1.875rem; letter-spacing: -.025em; }
        .docs-page-description { margin: 0; color: var(--pk-muted); font-size: 1.05rem; }
        .docs-demo { margin-bottom: 2.5rem; }
        .docs-demo-title { font-size: 1.125rem; font-weight: 600; margin: 0 0 .75rem; }
        .docs-demo-preview { display: flex; flex-wrap: wrap; align-items: center; justify-content: center;
                             gap: 1rem; min-height: 9rem; padding: 2.5rem 2rem;
                             border: 1px solid var(--pk-border); border-radius: calc(var(--pk-radius) + 4px); }
        .docs-demo-code pre { max-height: 28rem; overflow: auto; margin: 0; }
        .stack { display: flex; flex-direction: column; gap: .75rem; }
        .row { display: flex; align-items: center; gap: .5rem; }
        .docs-slide { display: flex; align-items: center; justify-content: center; height: 130px;
                      border: 1px solid var(--pk-border); border-radius: var(--pk-radius);
                      font-size: 2rem; font-weight: 600; }
        .docs-panel { display:flex; align-items:center; justify-content:center; height:100%; font-size:.875rem; font-weight:600; }
        .docs-repo-row { border: 1px solid var(--pk-border); border-radius: var(--pk-radius); padding: .5rem .75rem; font-size: .875rem; font-family: ui-monospace, monospace; }
        .w-sm { width: 300px; max-width: 100%; } .w-md { width: 380px; max-width: 100%; } .w-lg { width: 560px; max-width: 100%; }
      CSS
    end
  end
end
