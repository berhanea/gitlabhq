Rails.application.configure do
  WEBPACK_DEV_PORT = `cat ../webpack_port 2>/dev/null || echo '3808'`.to_i

  # Settings specified here will take precedence over those in config/application.rb

  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Raise an error on page load if there are pending migrations
  config.active_record.migration_error = :page_load

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Enable webpack dev server
  config.webpack.dev_server.enabled = true
  config.webpack.dev_server.port = WEBPACK_DEV_PORT
  config.webpack.dev_server.manifest_port = WEBPACK_DEV_PORT

  # Do not compress assets
  config.assets.compress = false

  # Expands the lines which load the assets
  # config.assets.debug = true

  # Adds additional error checking when serving assets at runtime.
  # Checks for improperly declared sprockets dependencies.
  # Raises helpful error messages.
  config.assets.raise_runtime_errors = true

  # For having correct urls in mails
  config.action_mailer.default_url_options = { host: 'localhost', port: 3000 }
  # Open sent mails in browser
  config.action_mailer.delivery_method = :letter_opener_web
  # Don't make a mess when bootstrapping a development environment
  config.action_mailer.perform_deliveries = (ENV['BOOTSTRAP'] != '1')
  config.action_mailer.preview_path = 'spec/mailers/previews'

  config.eager_load = false

  # Do not log asset requests
  config.assets.quiet = true
end
