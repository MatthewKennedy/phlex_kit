# frozen_string_literal: true

module Docs
  # One docs page per component, shadcn-style: a title + intro + a DemoFrame
  # per use case. Subclasses set `title`/`description` and implement `demos`
  # with `demo ExampleClass, title: "…"` calls.
  class BasePage < Phlex::HTML
    class << self
      attr_writer :title, :description

      def title = @title ||= name.demodulize.titleize
      def description = @description
      def slug = name.demodulize.underscore.dasherize
    end

    def view_template
      article(class: "docs-page") do
        header(class: "docs-page-header") do
          h1 { self.class.title }
          p(class: "docs-page-description") { self.class.description } if self.class.description
        end
        demos
      end
    end

    private

    def demo(example, title: nil)
      render Docs::DemoFrame.new(example, title: title)
    end
  end
end
