# --------------------------------------------------------------------------------------------------
# Helpers
# --------------------------------------------------------------------------------------------------

helpers do
  # Helpers are defined in and can be added to `helpers/custom_helpers.rb`.
  # In case you require helpers within `config.rb`, they can be added here.

  def watch_link(slug)
    "/watch/#{slug}"
  end
  def category_link(video)
    "/videos/#{video[:category]}s"
  end
  def series_link(series)
    "/series/#{series}"
  end
  def crew_link(crew)
    "/about/#{crew[:slug]}"
  end
end

# --------------------------------------------------------------------------------------------------
# Extensions
# --------------------------------------------------------------------------------------------------

# Use LiveReload
activate :livereload

# Use Search Engine Sitemap
set :url_root, data.config.site.root_url
activate :search_engine_sitemap

# User Bower to manage vendor scripts
activate :bower

# Automatic image dimensions on image_tag helper (only works with local images)
# activate :automatic_image_sizes

# Split up each required asset into its own script/style tag instead of combining them
set :debug_assets, true

# Use OGP
activate :ogp do |ogp|
  ogp.namespaces = {
    fb: data.ogp.fb,
    og: data.ogp.og,
    twitter: data.ogp.twitter
  }
  ogp.base_url = 'http://carpoolcrew.co'
end

data.videos.each do | slug, video |
  proxy "/watch/#{slug}.html", "/watch/template.html", :locals => { slug: slug, video: video }, :ignore => true
  proxy "/videos/#{video[:category]}s.html", "/videos/category.html", :locals => { slug: slug, category: video.category }, :ignore => true
end

data.podcast.each do | episode |
  proxy "/podcast/episode-#{episode.number}.html", "/podcast/template.html", :locals => { :episode => episode }, :ignore => true
end

data.series.each do | series |
  proxy "/series/#{series.slug}.html", "/series/template.html", :locals => { :series => series }, :ignore => true
end

data.crew.each do | crew |
  proxy "/about/#{crew[:slug]}.html", "/about/template.html", :locals => { :crew => crew }, :ignore => true
end

# --------------------------------------------------------------------------------------------------
# Paths
# --------------------------------------------------------------------------------------------------

set :css_dir,     'stylesheets'
set :fonts_dir,   'fonts'
set :images_dir,  'images'
set :js_dir,      'javascripts'

# Pretty URLs - See https://middlemanapp.com/advanced/pretty_urls/
activate :directory_indexes

# --------------------------------------------------------------------------------------------------
# Build configuration
# --------------------------------------------------------------------------------------------------

configure :build do
  # Exclude any vendor components (bower or custom builds) in the build
  ignore 'stylesheets/vendor/*'
  ignore 'javascripts/vendor/*'

  activate :autoprefixer do |config|
    config.browsers = ['last 2 versions', 'Explorer >= 9', 'Firefox 15']
    config.cascade  = true
  end

  activate :gzip

  # Minify CSS
  activate :minify_css

  # Minify Javascript
  activate :minify_javascript

  # Minify HTML
  activate :minify_html, remove_http_protocol: false,
                         remove_https_protocol: false,
                         remove_input_attributes: false,
                         remove_quotes: false

  # Compress images (default)
  require 'middleman-smusher'
  activate :smusher

  # Compress ALL images (advanced)
  # Before activating the below, follow setup instructions on https://github.com/toy/image_optim
  # activate :imageoptim do |options|
  #   options.pngout = false # set to true when pngout is also installed
  # end

  # Uniquely-named assets (cache buster)
  # Exception: svg & png in images folder because they need to be interchangeable by JS
  # activate :asset_hash, ignore: [%r{images/(.*\.png|.*\.svg)$}i]

  activate :build_cleaner
end

# --------------------------------------------------------------------------------------------------
# Github Pages Deploy
# --------------------------------------------------------------------------------------------------

activate :deploy do |deploy|
  deploy.build_before = true
  deploy.method = :git
end
