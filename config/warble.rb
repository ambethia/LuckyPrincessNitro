# Disable Rake-environment-task framework detection by uncommenting/setting to false
# Warbler.framework_detection = false

# Warbler web application assembly configuration file
Warbler::Config.new do |config|
  config.features = %w(compiled)
  config.dirs = %w(bin lib vendor)
  config.includes = FileList["assets/*"] - ["assets/source"]
  config.jar_name = "Nitro"
end
