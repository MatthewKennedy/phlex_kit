# frozen_string_literal: true

# Dev-only generator for lib/phlex_kit/icons/{lucide,tabler,phosphor,remix}.rb.
# Fetches each library's per-icon SVGs from GitHub (one git-trees API call per
# repo to resolve paths, then raw file downloads), extracts the geometry
# elements, and emits checked-in Ruby data modules keyed by PhlexKit's
# canonical glyph names. Run from the repo root:
#
#   ruby scripts/generate_icons.rb
#
# HugeIcons is deliberately absent: its free set's terms forbid editing and
# redistribution of the artwork, so it cannot ship inside this MIT gem.
#
# Fails loud: any glyph that can't be resolved in any library aborts the run
# (candidates are tried in order) — nothing is emitted from a partial fetch.

require "json"
require "net/http"
require "uri"

LIBRARIES = {
  lucide: {
    repo: "lucide-icons/lucide", branch: "main",
    prefer: %r{\Aicons/}, view_box: "0 0 24 24", mode: :stroke, stroke_width: 2,
    license: "ISC (some Feather-derived icons MIT)"
  },
  tabler: {
    repo: "tabler/tabler-icons", branch: "main",
    prefer: %r{outline/}, view_box: "0 0 24 24", mode: :stroke, stroke_width: 2,
    license: "MIT"
  },
  phosphor: {
    # assets/ holds the flattened single-path fills; raw/ is stroke primitives.
    repo: "phosphor-icons/core", branch: "main",
    prefer: %r{\Aassets/regular/}, view_box: "0 0 256 256", mode: :fill, stroke_width: nil,
    license: "MIT"
  },
  remix: {
    repo: "Remix-Design/RemixIcon", branch: "master",
    prefer: %r{\Aicons/}, view_box: "0 0 24 24", mode: :fill, stroke_width: nil,
    license: "Apache-2.0"
  }
}.freeze

# Canonical glyph => upstream name candidates per library (tried in order,
# ".svg" appended). The semantic-name → library-vocabulary mapping lives HERE,
# at generation time — the runtime registry only ever sees canonical names.
CURATED = {
  chevron_down: { lucide: %w[chevron-down], tabler: %w[chevron-down], phosphor: %w[caret-down], remix: %w[arrow-down-s-line] },
  chevron_up: { lucide: %w[chevron-up], tabler: %w[chevron-up], phosphor: %w[caret-up], remix: %w[arrow-up-s-line] },
  chevron_left: { lucide: %w[chevron-left], tabler: %w[chevron-left], phosphor: %w[caret-left], remix: %w[arrow-left-s-line] },
  chevron_right: { lucide: %w[chevron-right], tabler: %w[chevron-right], phosphor: %w[caret-right], remix: %w[arrow-right-s-line] },
  chevrons_up_down: { lucide: %w[chevrons-up-down], tabler: %w[selector], phosphor: %w[caret-up-down], remix: %w[expand-up-down-line] },
  check: { lucide: %w[check], tabler: %w[check], phosphor: %w[check], remix: %w[check-line] },
  x: { lucide: %w[x], tabler: %w[x], phosphor: %w[x], remix: %w[close-line] },
  search: { lucide: %w[search], tabler: %w[search], phosphor: %w[magnifying-glass], remix: %w[search-line] },
  ellipsis: { lucide: %w[ellipsis more-horizontal], tabler: %w[dots], phosphor: %w[dots-three], remix: %w[more-line] },
  arrow_left: { lucide: %w[arrow-left], tabler: %w[arrow-left], phosphor: %w[arrow-left], remix: %w[arrow-left-line] },
  arrow_right: { lucide: %w[arrow-right], tabler: %w[arrow-right], phosphor: %w[arrow-right], remix: %w[arrow-right-line] },
  loader: { lucide: %w[loader-circle loader-2], tabler: %w[loader-2], phosphor: %w[circle-notch spinner], remix: %w[loader-4-line] },
  circle_check: { lucide: %w[circle-check check-circle], tabler: %w[circle-check], phosphor: %w[check-circle], remix: %w[checkbox-circle-line] },
  circle_x: { lucide: %w[circle-x x-circle], tabler: %w[circle-x], phosphor: %w[x-circle], remix: %w[close-circle-line] },
  triangle_alert: { lucide: %w[triangle-alert alert-triangle], tabler: %w[alert-triangle], phosphor: %w[warning], remix: %w[alert-line] },
  info: { lucide: %w[info], tabler: %w[info-circle], phosphor: %w[info], remix: %w[information-line] },

  # Curated host-facing set (beyond the kit's own chrome glyphs).
  calendar: { lucide: %w[calendar], tabler: %w[calendar], phosphor: %w[calendar], remix: %w[calendar-line] },
  user: { lucide: %w[user], tabler: %w[user], phosphor: %w[user], remix: %w[user-line] },
  users: { lucide: %w[users], tabler: %w[users], phosphor: %w[users], remix: %w[group-line] },
  user_x: { lucide: %w[user-x], tabler: %w[user-x], phosphor: %w[user-circle-minus user-minus], remix: %w[user-unfollow-line user-forbid-line] },
  volume_off: { lucide: %w[volume-off volume-x], tabler: %w[volume-off volume-3], phosphor: %w[speaker-slash speaker-simple-slash], remix: %w[volume-mute-line] },
  settings: { lucide: %w[settings], tabler: %w[settings], phosphor: %w[gear], remix: %w[settings-3-line] },
  trash: { lucide: %w[trash-2 trash], tabler: %w[trash], phosphor: %w[trash], remix: %w[delete-bin-line] },
  plus: { lucide: %w[plus], tabler: %w[plus], phosphor: %w[plus], remix: %w[add-line] },
  minus: { lucide: %w[minus], tabler: %w[minus], phosphor: %w[minus], remix: %w[subtract-line] },
  home: { lucide: %w[house home], tabler: %w[home], phosphor: %w[house], remix: %w[home-line] },
  mail: { lucide: %w[mail], tabler: %w[mail], phosphor: %w[envelope], remix: %w[mail-line] },
  bell: { lucide: %w[bell], tabler: %w[bell], phosphor: %w[bell], remix: %w[notification-3-line] },
  eye: { lucide: %w[eye], tabler: %w[eye], phosphor: %w[eye], remix: %w[eye-line] },
  eye_off: { lucide: %w[eye-off], tabler: %w[eye-off], phosphor: %w[eye-slash], remix: %w[eye-off-line] },
  lock: { lucide: %w[lock], tabler: %w[lock], phosphor: %w[lock], remix: %w[lock-line] },
  unlock: { lucide: %w[lock-open unlock], tabler: %w[lock-open], phosphor: %w[lock-open], remix: %w[lock-unlock-line] },
  star: { lucide: %w[star], tabler: %w[star], phosphor: %w[star], remix: %w[star-line] },
  heart: { lucide: %w[heart], tabler: %w[heart], phosphor: %w[heart], remix: %w[heart-line] },
  download: { lucide: %w[download], tabler: %w[download], phosphor: %w[download-simple], remix: %w[download-line] },
  upload: { lucide: %w[upload], tabler: %w[upload], phosphor: %w[upload-simple], remix: %w[upload-line] },
  external_link: { lucide: %w[external-link], tabler: %w[external-link], phosphor: %w[arrow-square-out], remix: %w[external-link-line] },
  copy: { lucide: %w[copy], tabler: %w[copy], phosphor: %w[copy], remix: %w[file-copy-line] },
  pencil: { lucide: %w[pencil], tabler: %w[pencil], phosphor: %w[pencil], remix: %w[pencil-line] },
  filter: { lucide: %w[funnel filter], tabler: %w[filter], phosphor: %w[funnel], remix: %w[filter-line] },
  menu: { lucide: %w[menu], tabler: %w[menu-2], phosphor: %w[list], remix: %w[menu-line] },
  sun: { lucide: %w[sun], tabler: %w[sun], phosphor: %w[sun], remix: %w[sun-line] },
  moon: { lucide: %w[moon], tabler: %w[moon], phosphor: %w[moon], remix: %w[moon-line] },
  file: { lucide: %w[file], tabler: %w[file], phosphor: %w[file], remix: %w[file-line] },
  folder: { lucide: %w[folder], tabler: %w[folder], phosphor: %w[folder], remix: %w[folder-line] },
  image: { lucide: %w[image], tabler: %w[photo], phosphor: %w[image], remix: %w[image-line] },
  link: { lucide: %w[link], tabler: %w[link], phosphor: %w[link], remix: %w[link] },
  globe: { lucide: %w[globe], tabler: %w[world], phosphor: %w[globe], remix: %w[global-line] },
  clock: { lucide: %w[clock], tabler: %w[clock], phosphor: %w[clock], remix: %w[time-line] },
  refresh: { lucide: %w[refresh-cw], tabler: %w[refresh], phosphor: %w[arrows-clockwise], remix: %w[refresh-line] },
  log_in: { lucide: %w[log-in], tabler: %w[login login-2], phosphor: %w[sign-in], remix: %w[login-box-line] },
  log_out: { lucide: %w[log-out], tabler: %w[logout logout-2], phosphor: %w[sign-out], remix: %w[logout-box-line] },
  send: { lucide: %w[send], tabler: %w[send], phosphor: %w[paper-plane-tilt], remix: %w[send-plane-line] },
  share: { lucide: %w[share-2 share], tabler: %w[share], phosphor: %w[share-network], remix: %w[share-line] },
  bookmark: { lucide: %w[bookmark], tabler: %w[bookmark], phosphor: %w[bookmark-simple], remix: %w[bookmark-line] },
  tag: { lucide: %w[tag], tabler: %w[tag], phosphor: %w[tag], remix: %w[price-tag-3-line] },
  shopping_cart: { lucide: %w[shopping-cart], tabler: %w[shopping-cart], phosphor: %w[shopping-cart], remix: %w[shopping-cart-line] },
  credit_card: { lucide: %w[credit-card], tabler: %w[credit-card], phosphor: %w[credit-card], remix: %w[bank-card-line] },
  chart: { lucide: %w[chart-column bar-chart-3 chart-bar], tabler: %w[chart-bar], phosphor: %w[chart-bar], remix: %w[bar-chart-line] },
  database: { lucide: %w[database], tabler: %w[database], phosphor: %w[database], remix: %w[database-2-line] },
  terminal: { lucide: %w[terminal], tabler: %w[terminal], phosphor: %w[terminal], remix: %w[terminal-line] },
  code: { lucide: %w[code], tabler: %w[code], phosphor: %w[code], remix: %w[code-s-slash-line] },
  cloud: { lucide: %w[cloud], tabler: %w[cloud], phosphor: %w[cloud], remix: %w[cloud-line] },
  shield: { lucide: %w[shield], tabler: %w[shield], phosphor: %w[shield], remix: %w[shield-line] },
  circle_alert: { lucide: %w[circle-alert alert-circle], tabler: %w[alert-circle], phosphor: %w[warning-circle], remix: %w[error-warning-line] },
  thumbs_up: { lucide: %w[thumbs-up], tabler: %w[thumb-up], phosphor: %w[thumbs-up], remix: %w[thumb-up-line] },
  message: { lucide: %w[message-square message-circle], tabler: %w[message message-circle], phosphor: %w[chat chat-circle], remix: %w[chat-1-line message-2-line] },
  phone: { lucide: %w[phone], tabler: %w[phone], phosphor: %w[phone], remix: %w[phone-line] },
  map_pin: { lucide: %w[map-pin], tabler: %w[map-pin], phosphor: %w[map-pin], remix: %w[map-pin-line] },
  camera: { lucide: %w[camera], tabler: %w[camera], phosphor: %w[camera], remix: %w[camera-line] },
  mic: { lucide: %w[mic], tabler: %w[microphone], phosphor: %w[microphone], remix: %w[mic-line] },
  play: { lucide: %w[play], tabler: %w[player-play], phosphor: %w[play], remix: %w[play-line] },
  pause: { lucide: %w[pause], tabler: %w[player-pause], phosphor: %w[pause], remix: %w[pause-line] },
  grip: { lucide: %w[grip-vertical], tabler: %w[grip-vertical], phosphor: %w[dots-six-vertical], remix: %w[draggable] }
}.freeze

# Geometry attributes worth keeping (styling comes from library metadata at
# render time). Underscored symbol keys — Phlex re-hyphenates on emit.
KEEP_ATTRS = %w[d points cx cy r rx ry x y x1 x2 y1 y2 width height fill-rule clip-rule].freeze
ELEMENTS = %w[path polyline polygon circle line rect].freeze

def get(url)
  uri = URI(url)
  res = Net::HTTP.get_response(uri)
  res = Net::HTTP.get_response(URI(res["location"])) if res.is_a?(Net::HTTPRedirection)
  raise "GET #{url} -> #{res.code}" unless res.is_a?(Net::HTTPSuccess)
  res.body
end

def tree_index(repo, branch, prefer)
  body = JSON.parse(get("https://api.github.com/repos/#{repo}/git/trees/#{branch}?recursive=1"))
  raise "tree for #{repo} truncated" if body["truncated"]
  index = {}
  body["tree"].each do |entry|
    next unless entry["type"] == "blob" && entry["path"].end_with?(".svg")
    base = File.basename(entry["path"], ".svg")
    # Prefer the canonical directory (outline/assets/icons) on basename clashes;
    # never let a non-preferred path displace a preferred one.
    if index[base].nil? || (entry["path"].match?(prefer) && !index[base].match?(prefer))
      index[base] = entry["path"]
    end
  end
  index
end

def parse_elements(svg)
  svg.scan(%r{<(#{ELEMENTS.join("|")})\b([^>]*?)/?>}m).filter_map do |tag, raw_attrs|
    attrs = raw_attrs.scan(/([\w-]+)="([^"]*)"/).to_h
    # Drop invisible placeholders: tabler's bounding-box path and any
    # fill="none" element (phosphor's 256×256 rect) — under the fill-mode
    # svg's fill="currentColor" those would paint solid.
    next if attrs["d"]&.start_with?("M0 0h24v24H0z")
    next if attrs["fill"] == "none"
    kept = attrs.slice(*KEEP_ATTRS).transform_keys { |k| k.tr("-", "_").to_sym }
    next if kept.empty?
    [ tag.to_sym, kept ]
  end
end

failures = []
data = {}

LIBRARIES.each do |lib, meta|
  puts "== #{lib} (#{meta[:repo]})"
  index = tree_index(meta[:repo], meta[:branch], meta[:prefer])
  data[lib] = {}
  CURATED.each do |canonical, aliases|
    candidates = aliases.fetch(lib)
    path = candidates.filter_map { |c| index[c] }.first
    unless path
      failures << "#{lib}: #{canonical} (tried #{candidates.join(', ')})"
      next
    end
    # Remix nests icons in category dirs with spaces/ampersands ("User & Faces").
    encoded = path.split("/").map { |seg| URI.encode_uri_component(seg) }.join("/")
    svg = get("https://raw.githubusercontent.com/#{meta[:repo]}/#{meta[:branch]}/#{encoded}")
    elements = parse_elements(svg)
    if elements.empty?
      failures << "#{lib}: #{canonical} — no geometry parsed from #{path}"
      next
    end
    data[lib][canonical] = elements
    puts "   #{canonical} <- #{path} (#{elements.size} el)"
  end
end

abort("\nFAILED:\n  " + failures.join("\n  ")) if failures.any?

data.each do |lib, icons|
  meta = LIBRARIES.fetch(lib)
  body = +"# frozen_string_literal: true\n\n"
  body << "# GENERATED by scripts/generate_icons.rb — do not hand-edit; re-run the\n"
  body << "# generator to refresh or expand. Path data (c) #{lib.capitalize} contributors,\n"
  body << "# #{meta[:license]} — see THIRD_PARTY_LICENSES. Source: github.com/#{meta[:repo]}.\n"
  body << "module PhlexKit\n  module Icons\n    module #{lib.capitalize}\n"
  body << "      VIEW_BOX = #{meta[:view_box].inspect}\n"
  body << "      MODE = #{meta[:mode].inspect}\n"
  body << "      STROKE_WIDTH = #{meta[:stroke_width].inspect}\n"
  body << "      ICONS = {\n"
  icons.each do |canonical, elements|
    els = elements.map { |tag, attrs| "[ :#{tag}, { #{attrs.map { |k, v| "#{k}: #{v.inspect}" }.join(', ')} } ]" }
    body << "        #{canonical}: [ #{els.join(', ')} ],\n"
  end
  body << "      }.freeze\n    end\n  end\nend\n"
  out = File.expand_path("../lib/phlex_kit/icons/#{lib}.rb", __dir__)
  File.write(out, body)
  puts "wrote #{out} (#{icons.size} glyphs, #{File.size(out)} bytes)"
end
