# frozen_string_literal: true

module PhlexKit
  # Runtime configuration. Everything has a sane default so the gem works with
  # zero setup; hosts tune it in an initializer:
  #
  #   PhlexKit.configure do |c|
  #     c.reactive = true          # opt into phlex-reactive integration
  #     c.define_ui_alias = true   # expose `UI::Button` as an alias for `PhlexKit::Button`
  #   end
  class Configuration
    # :auto (default) enables reactive helpers only when phlex-reactive is
    # loaded; true forces on (raises if the gem is absent); false forces off.
    attr_accessor :reactive

    # When true, `UI` is aliased to `PhlexKit`, so revue-style `UI::Button`
    # call sites work unchanged. Off by default to avoid owning a generic const.
    attr_accessor :define_ui_alias

    def initialize
      @reactive = :auto
      @define_ui_alias = false
    end
  end

  class << self
    def config
      @config ||= Configuration.new
    end

    def configure
      yield config
    end

    # True when reactive helpers should be active. :auto follows availability.
    def reactive?
      case config.reactive
      when :auto then defined?(Phlex::Reactive)
      when true
        defined?(Phlex::Reactive) or
          raise "PhlexKit.config.reactive = true but phlex-reactive is not loaded — add it to your Gemfile"
      else false
      end
    end
  end
end
