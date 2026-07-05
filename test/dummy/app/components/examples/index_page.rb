# frozen_string_literal: true

module Examples
  # /examples — the gallery of Harbor screens. One card per example page.
  class IndexPage < BasePage
    private

    def page_title = "Admin UI examples"

    def body_content
      div(class: "adm-page") do
        harbor_topbar do
          div(class: "adm-topbar-spacer")
          a(href: "/", class: "adm-footer-link") { "← Docs" }
        end
        main(class: "adm-index") do
          header(class: "adm-index-head") do
            h1(class: "adm-page-title") { "Admin UI examples" }
            p(class: "adm-page-sub") do
              plain "Six full-page admin screens for Harbor, a fictional commerce app — "
              plain "every visible element is a PhlexKit component; each page recreates one "
              plain "classic app frame."
            end
          end
          div(class: "adm-index-grid") do
            Examples::Registry.all.each do |slug, entry|
              render PhlexKit::Card.new(class: "adm-index-card") do
                render PhlexKit::CardHeader.new do
                  render PhlexKit::CardTitle.new { entry[:title] }
                  render PhlexKit::CardDescription.new { entry[:blurb] }
                  render PhlexKit::CardAction.new do
                    render PhlexKit::Badge.new(variant: :outline, size: :sm) { entry[:layout] }
                  end
                end
                render PhlexKit::CardFooter.new do
                  render PhlexKit::Button.new(variant: :outline, size: :sm, href: "/examples/#{slug}") do
                    plain "Open"
                    icon(:arrow_right, size: 14)
                  end
                end
              end
            end
          end
        end
        harbor_footer "Harbor is fictional — these screens exist to show PhlexKit composing into real layouts."
      end
    end

    def local_css
      <<~CSS
        .adm-index { width: min(64rem, 100% - 3rem); margin: 0 auto; padding: 3rem 0 4rem;
                     display: flex; flex-direction: column; gap: 2rem; }
        .adm-index-head .adm-page-title { font-size: 1.75rem; }
        .adm-index-head .adm-page-sub { max-width: 44rem; font-size: .875rem; margin-top: .5rem; }
        .adm-index-grid { display: grid; grid-template-columns: repeat(auto-fit, minmax(280px, 1fr)); gap: 1rem; }
        .adm-index-card { display: flex; flex-direction: column; }
        .adm-index-card .pk-card-footer { margin-top: auto; }
      CSS
    end
  end
end
