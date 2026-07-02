module PhlexKit
  # Labelled option group. Pass `label:` as a plain attribute — CSS renders it via
  # ::before content(attr(label)), and the group auto-hides (pure CSS :has) when
  # filtering leaves it with no visible items. See combobox.rb.
  class ComboboxListGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-combobox-group", role: "group" }, @attrs), &)
    end
  end
end
