# frozen_string_literal: true

require "bundler/gem_tasks"
require "rake/testtask"

# Fast unit suite — no Rails boot, no browser. Excludes test/system.
Rake::TestTask.new(:test) do |t|
  t.libs << "test"
  t.libs << "lib"
  t.test_files = FileList["test/**/*_test.rb"].exclude("test/system/**/*_test.rb")
  t.warning = false
end

namespace :test do
  # Browser suite — boots the test/dummy app under Capybara + Cuprite
  # (headless Chrome) and exercises the Stimulus controllers end-to-end
  # against the gallery and /docs/<component> pages.
  Rake::TestTask.new(:system) do |t|
    t.libs << "test"
    t.libs << "lib"
    t.test_files = FileList["test/system/**/*_test.rb"]
    t.warning = false
  end
end

task default: :test
