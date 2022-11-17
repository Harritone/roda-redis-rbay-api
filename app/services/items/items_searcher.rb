# frozen_string_literal: true

module Items
  class ItemsSearcher
    include Redisable
    include Import['redis.search']

    def call(term:)
      cleaned =
        term
        .gsub(/[^a-zA-Z0-9 ]/, '')
        .strip
        .split
        .map { |word| word ? "%#{word}%" : '' }
        .join(' ')

      query = "(@name:(#{cleaned}) => { $weight: 5.0 }) | (@description:(#{cleaned}))"
      result = search.search(query, limit: [0, 5])
      result.map do |item|
        item['id'] = item['id'].split('#')[1]
        item
      end
    end
  end
end
