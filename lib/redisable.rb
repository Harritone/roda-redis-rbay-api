# frozen_string_literal: true

module Redisable
  def self.included(klass)
    klass.include(InstanceMethods)
    klass.extend(ClassMethods)
  end

  module CommonMethods
    def redis_hset(key, options)
      redis_pool.with { |conn| conn.hset(key, options) }
    end

    def redis_sadd(key, value)
      redis_pool.with { |conn| conn.sadd(key, value) }
    end

    def redis_zadd(key, score, value)
      redis_pool.with { |conn| conn.zadd(key, score, value) }
    end

    def redis_sismember(key, value)
      redis_pool.with { |conn| conn.sismember(key, value) }
    end

    def redis_zscore(key, value)
      redis_pool.with { |conn| conn.zscore(key, value) }
    end

    def redis_hgetall(key)
      redis_pool.with { |conn| conn.hgetall(key) }
    end

    def redis_srem(key, value)
      redis_pool.with { |conn| conn.srem(key, value) }
    end

    def redis_multi(&block)
      redis_pool.with do |conn|
        conn.multi(&block)
      end
    end

    # KEYS
    def uniq_auth_tokens_key
      'auth_tokens:unique'
    end

    def usernames_uniq_key
      'usernames:unique'
    end

    def users_key(id)
      "users##{id}"
    end

    def items_key(id)
      "items##{id}"
    end

    def items_by_views_key
      'items:views'
    end

    def items_by_ending_at_key
      'items:ending_at'
    end

    def items_by_price_key
      'items:price'
    end

    def tokens_key(_token)
      'tokens'
    end

    def usernames_key
      'usernames'
    end
  end

  module InstanceMethods
    include CommonMethods

    def redis_pool
      ConnectionPool.new(size: 5) { Redis.new(port: ENV['REDIS_PORT'], host: ENV['REDIS_HOST']) }
    end
  end

  module ClassMethods
    include CommonMethods

    def redis_pool
      ConnectionPool.new(size: 5) { Redis.new(port: ENV['REDIS_PORT'], host: ENV['REDIS_HOST']) }
    end
  end
end
