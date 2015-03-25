require 'sidekiq'
require 'sidekiq-status'


Sidekiq.configure_client do |config|
  config.redis = { :size => 1 }
end

require 'sidekiq/web'
require 'sidekiq-status/web'
run Sidekiq::Web
