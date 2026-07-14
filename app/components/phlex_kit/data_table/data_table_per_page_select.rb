module PhlexKit
  # Per-page NativeSelect in a GET form that self-submits on change (targeting
  # the table's turbo-frame when `frame_id:` is given). Extra filter params
  # (search/sort/direction/...) survive via `preserved_params:` hidden inputs,
  # mirroring DataTableSearch. See data_table.rb.
  class DataTablePerPageSelect < BaseComponent
    def initialize(path:, name: "per_page", value: nil, frame_id: nil, options: [ 5, 10, 25, 50 ], preserved_params: {}, **attrs)
      @path = path
      @name = name
      @value = value
      @frame_id = frame_id
      @options = options
      @preserved_params = preserved_params
      @attrs = attrs
    end

    def view_template
      form_attrs = {
        class: "pk-data-table-per-page",
        action: @path,
        method: "get",
        # Reuse the search controller for its CSP-safe #submitNow action.
        data: { controller: "phlex-kit--data-table-search" }
      }
      form_attrs[:data][:turbo_frame] = @frame_id if @frame_id

      form(**mix(form_attrs, @attrs)) do
        render NativeSelect.new(name: @name, data: { action: "change->phlex-kit--data-table-search#submitNow" }) do
          @options.each do |opt|
            option_attrs = { value: opt.to_s }
            option_attrs[:selected] = true if opt.to_s == @value.to_s
            option(**option_attrs) { plain opt.to_s }
          end
        end
        @preserved_params.each do |k, v|
          next if v.nil? || (v.respond_to?(:empty?) && v.empty?)
          next if k.to_s == @name
          input(type: :hidden, name: k.to_s, value: v.to_s)
        end
      end
    end
  end
end
