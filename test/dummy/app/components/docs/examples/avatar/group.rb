# frozen_string_literal: true

module Docs
  module Examples
    module Avatar
      class Group < Phlex::HTML
        def view_template
          render PhlexKit::AvatarGroup.new do
            %w[CN MK PK +9].each do |initials|
              render PhlexKit::Avatar.new do
                render PhlexKit::AvatarFallback.new { initials }
              end
            end
          end
        end
      end
    end
  end
end
