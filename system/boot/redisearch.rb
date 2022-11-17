# frozen_string_literal: true

Application.boot(:redis_search) do |container|
  init do
    require 'redisearch-rb'
  end

  start do
    indexes = container[:redis].call('FT._LIST')
    exists = indexes.find { |idx| idx == 'idx:items' }
    msg = 'In order to create index you need to run '\
          '`FT.CREATE idx:items ON HASH prefix 1 items# '\
          'SCHEMA name TEXT SORTABLE description TEXT owner_id TAG '\
          'ending_at NUMERIC SORTABLE bids NUMERIC SORTABLE '\
          'views NUMERIC SORTABLE price NUMERIC SORTABLE likes NUMERIC SORTABLE`'\
          ' in redis'

    fail msg unless exists

    redisearch_client = RediSearch.new('idx:items', container[:redis])

    container.register('redis.search', redisearch_client)
  end
end
