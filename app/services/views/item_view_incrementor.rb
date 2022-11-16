# frozen_string_literal: true

module Views
  class ItemViewIncrementor
    include Redisable

    def initialize(item_id, user_id)
      @item_id = item_id
      @user_id = user_id
    end

    def call
      script = <<-EOF
      local items_views_key = KEYS[1]
      local items_key = KEYS[2]
      local items_by_views_key = KEYS[3]
      local item_id = ARGV[1]
      local user_id = ARGV[2]

      local inserted = redis.call('PFADD', items_views_key, user_id)

      if inserted == 1 then
        redis.call('HINCRBY', items_key, 'views', 1)
        redis.call('ZINCRBY', items_by_views_key, 1, item_id)
      end
      EOF

      redis_eval(script, keys: [items_views_key(@item_id), items_key(@item_id), items_by_views_key], argv: [@item_id, @user_id])
    end
  end
end
