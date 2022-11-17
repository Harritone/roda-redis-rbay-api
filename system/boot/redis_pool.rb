# frozen_string_literal: true

Application.boot(:redis_pool) do |container|
  init do
    require 'connection_pool'
  end

  start do
    redis_pool = ConnectionPool.new(size: 5) { container[:redis] }

    container.register(:redis_pool, redis_pool)
  end
end
