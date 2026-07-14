module PhlexKit
  # Labelled option group. Pass `label:` — it renders as aria-label (a bare
  # `label` attribute is invalid on <div> and silent to AT) plus data-label,
  # which CSS renders via ::before content(attr(data-label)). The group
  # auto-hides (pure CSS :has) when filtering leaves it with no visible items.
  # See combobox.rb.
  class ComboboxListGroup < BaseComponent
    def initialize(label: nil, **attrs)
      @label = label
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({
        class: "pk-combobox-group",
        role: "group",
        aria: { label: @label },
        data: { label: @label }
      }, @attrs), &)
    end
  end
end
