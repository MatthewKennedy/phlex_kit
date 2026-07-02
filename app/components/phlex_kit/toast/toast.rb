module PhlexKit
  # Flash-key → toast-variant mapping, ported from ruby_ui's RubyUI::Toast.
  # Used by PhlexKit::ToastRegion when rendering `flash:` server-side:
  # `PhlexKit::Toast.flash_variant(:notice) #=> :info`. Unknown keys fall back
  # to :default (flash keys are app-defined, so this map is deliberately
  # permissive — unlike the component VARIANTS, which fail loud).
  module Toast
    FLASH_VARIANTS = {
      "notice" => :info,
      "alert" => :warning,
      "success" => :success,
      "error" => :error,
      "warning" => :warning,
      "info" => :info
    }.freeze

    def self.flash_variant(key)
      FLASH_VARIANTS[key.to_s] || :default
    end
  end
end
