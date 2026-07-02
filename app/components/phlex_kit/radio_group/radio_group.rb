module PhlexKit
  # Radio list wrapper, ported from shadcn/ui's RadioGroup: a role=radiogroup
  # grid of (RadioButton + Label) rows sharing a `name`. The kit's RadioButton
  # is the item. `.pk-radio-group` (radio_group.css).
  class RadioGroup < BaseComponent
    def initialize(**attrs)
      @attrs = attrs
    end

    def view_template(&)
      div(**mix({ class: "pk-radio-group", role: "radiogroup" }, @attrs), &)
    end
  end
end
