activate :autoprefixer do |prefix|
  prefix.browsers = "last 2 versions"
end

activate :blog do |blog|
  blog.calendar_template = "calendar.html"
  blog.paginate = true
  blog.tag_template = "tag.html"
end

activate :directory_indexes

page "/*.xml", layout: false
page "/*.json", layout: false
page "/*.txt", layout: false

configure :development do
  activate :external_pipeline, name: "gulp", command: "npm start", source: "./tmp/gulp", latency: 1
end

configure :build do
  set :build_dir, "public"

  activate :asset_hash
  activate :external_pipeline, name: "gulp", command: "NODE_ENV=production npm run build", source: "./tmp/gulp", latency: 1
  activate :gzip
  activate :minify_css
  activate :minify_javascript
  activate :relative_assets

  activate :imageoptim do |imageoptim|
    imageoptim.pngout = false
    imageoptim.svgo = false
  end

  ignore "stylesheets/compoents/*.css"
end
