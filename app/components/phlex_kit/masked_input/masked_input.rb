module PhlexKit
  # Text input with an inline mask. Ported from ruby_ui's RubyUI::MaskedInput —
  # ruby_ui uses the `maska` JS lib; PhlexKit ships a small dependency-free mask
  # controller (#=digit, A=letter, *=any) driven by a data-mask attribute. Swap in
  # maska by replacing masked_input_controller.js if you need its full feature set.
  class MaskedInput < BaseComponent
    def initialize(**attrs) = (@attrs = attrs)
    def view_template
      render PhlexKit::Input.new(type: "text", **mix({ data: { controller: "phlex-kit--masked-input" } }, @attrs))
    end
  end
end
