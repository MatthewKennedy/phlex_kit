module PhlexKit
  # Per-page NativeSelect in a GET form that self-submits on change (targeting
  # the table's turbo-frame when `frame_id:` is given). See data_table.rb.
  class DataTablePerPageSelect < BaseComponent
    def initialize(path:, name: "per_page", value: nil, frame_id: nil, options: [ 5, 10, 25, 50 ], **attrs)
      @path = path
      @name = name
      @value = value
      @frame_id = frame_id
      @options = options
      @attrs = attrs
    end

    def view_template
      form_attrs = { class: "pk-data-table-per-page", action: @path, method: "get" }
      form_attrs[:data] = { turbo_frame: @frame_id } if @frame_id

      form(**mix(form_attrs, @attrs)) do
        render NativeSelect.new(name: @name, onchange: safe("this.form.requestSubmit()")) do
          @options.each do |opt|
            option_attrs = { value: opt.to_s }
            option_attrs[:selected] = true if opt.to_s == @value.to_s
            option(**option_attrs) { plain opt.to_s }
          end
        end
      end
    end
  end
end
