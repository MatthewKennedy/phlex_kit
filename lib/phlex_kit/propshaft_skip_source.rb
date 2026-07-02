# frozen_string_literal: true

# The gem puts app/components on Propshaft's asset load path so component CSS can
# sit beside its .rb (see PhlexKit::Engine). Propshaft indexes EVERY non-dotfile
# in a path directory — it only skips dotfiles, with no extension allowlist — so
# it would otherwise digest our Ruby source into public/assets/ and serve it as a
# static file. Teach the load path to skip source files as well as dotfiles.
#
# This hooks a PRIVATE Propshaft method; test/assets/asset_load_path_test.rb (and
# the same guard in a host app) fails loudly if a Propshaft upgrade breaks it.
module PhlexKit
  module PropshaftSkipSourceFiles
    SOURCE_EXTENSIONS = %w[.rb .erb .haml .slim .rbi].freeze

    private def without_dotfiles(files)
      super.reject { |file| SOURCE_EXTENSIONS.include?(file.extname) }
    end
  end
end

require "propshaft/load_path"
Propshaft::LoadPath.prepend(PhlexKit::PropshaftSkipSourceFiles)
