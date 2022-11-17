# frozen_string_literal: true

Application.boot(:redis) do |container|
  # Load environment variables before setting up redis connection.
  use :environment_variables

  init do
    require 'redis'
  end

  start do
    # Define Redis instance.
    redis = Redis.new(host: ENV['REDIS_HOST'], port: ENV['REDIS_PORT'])

    # Get indexes
    # indexes = redis.call('FT._LIST')
    # exists = indexes.find { |idx| idx == 'idx:items' }

    # # # Create index if not exists
    # unless exists
    #   schema = [
    #     'name', 'TEXT', 'SORTABLE',
    #     'description', 'TEXT',
    #     'owner_id', 'TAG',
    #     'ending_at', 'NUMERIC', 'SORTABLE',
    #     'bids', 'NUMERIC', 'SORTABLE',
    #     'views', 'NUMERIC', 'SORTABLE',
    #     'price', 'NUMERIC', 'SORTABLE',
    #     'likes', 'NUMERIC', 'SORTABLE'
    #   ]
    #   command = 'FT.CREATE idx:items '\
    #             'ON HASH prefix 1 items# '\
    #             'SCHEMA name TEXT SORTABLE '\
    #             'description TEXT '\
    #             'owner_id TAG '\
    #             'ending_at NUMERIC SORTABLE '\
    #             'bids NUMERIC SORTABLE '\
    #             'views NUMERIC SORTABLE '\
    #             'price NUMERIC SORTABLE '\
    #             'likes NUMERIC SORTABLE'

    # Register redis component.
    container.register(:redis, redis)
  end
end
