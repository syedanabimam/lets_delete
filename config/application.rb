require_relative 'boot'

require 'rails/all'

Bundler.require(*Rails.groups)

module LetsDelete
  class Application < Rails::Application
    config.load_defaults 5.2

    config.generators do |g|
      g.test_framework :rspec,
        view_specs: false,
        helper_specs: false,
        routing_specs: false,
        request_specs: false
      g.factory_bot dir: 'spec/factories'
    end
  end
end
