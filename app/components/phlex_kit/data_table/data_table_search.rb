module PhlexKit
  # Debounced GET search form targeting the table's turbo-frame. Extra filter
  # params survive via `preserved_params:` hidden inputs; focus/caret survive the
  # frame swap (see the search controller). See data_table.rb.
  class DataTableSearch < BaseComponent
    # method:/action: are kit-owned (a GET form targeting `path:`) — named
    # kwargs so a caller override lands in @method/@action directly instead
    # of fusing with the generated defaults via `mix` ("get post").
    def initialize(path:, name: "search", value: nil, frame_id: nil, placeholder: "Search...", debounce: 300, preserved_params: {}, method: "get", action: nil, **attrs)
      @path = path
      @name = name
      @value = value
      @frame_id = frame_id
      @placeholder = placeholder
      @debounce = debounce
      @preserved_params = preserved_params
      @method = method
      @action = action || @path
      @attrs = attrs
    end

    def view_template
      form(**mix({ class: "pk-data-table-search", method: @method, action: @action, data: form_data }, @attrs)) do
        render Input.new(
          type: :search,
          name: @name,
          value: @value,
          placeholder: @placeholder,
          autocomplete: "off"
        )
        @preserved_params.each do |k, v|
          next if v.nil? || (v.respond_to?(:empty?) && v.empty?)
          next if k.to_s == @name
          input(type: :hidden, name: k.to_s, value: v.to_s)
        end
      end
    end

    private

    def debounce_enabled?
      @debounce && @debounce.to_i > 0
    end

    def form_data
      base = {}
      base[:turbo_frame] = @frame_id if @frame_id
      if debounce_enabled?
        base[:controller] = "phlex-kit--data-table-search"
        base[:"phlex-kit--data-table-search-delay-value"] = @debounce.to_i
        base[:action] = "input->phlex-kit--data-table-search#submit"
      end
      base
    end
  end
end
