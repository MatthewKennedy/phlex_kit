# frozen_string_literal: true

PhlexKit.configure do |c|
  # Enable phlex-reactive integration. :auto turns it on iff the gem is loaded;
  # set true to require it, false to force it off.
  c.reactive = :auto

  # Alias `UI` to `PhlexKit` so you can write `UI::Button` instead of
  # `PhlexKit::Button`. Off by default to avoid claiming a generic constant.
  c.define_ui_alias = false
end
