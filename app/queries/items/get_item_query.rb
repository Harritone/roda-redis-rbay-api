# frozen_string_literal: true

module Items
  class GetItemQuery
    include Redisable

    def initialize(id)
      @id = id
    end

    def call
      item = redis_hgetall(items_key(@id))
      raise Exceptions::NotFound unless item.present?
      item.symbolize_keys.merge(id: @id)
    end
  end
end
