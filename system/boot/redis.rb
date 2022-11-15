# frozen_string_literal: true

Application.boot(:redis) do |container|
  # Load environment variables before setting up redis connection.
  use :environment_variables

  init do
    require 'redis'
    require 'connection_pool'
  end

  start do
    # Define Redis instance.
    redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

    # Register redis component.
    container.register(:redis, redis)
  end
end
