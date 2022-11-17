# frozen_string_literal: true

Application.boot(:redlock) do |container|
  init do
    require 'redlock'
  end

  start do
    lock_manager =
      Redlock::Client.new(
        [container[:redis]],
        retry_count: 20,
        retry_delay: 100
      )

    container.register('redis.redlock', lock_manager)
  end
end
