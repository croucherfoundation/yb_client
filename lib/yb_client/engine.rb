require_relative "../../app/helpers/yb_client_helper"

module YbClient
  class Engine < ::Rails::Engine

    config.generators do |g|
      g.test_framework :rspec
      g.fixture_replacement :factory_girl, :dir => 'spec/factories'
    end

    initializer "yb_client.integration" do
      ActiveSupport.on_load :action_controller do
        helper ::YbClientHelper
      end
    end

  end
end
