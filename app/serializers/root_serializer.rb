# frozen_string_literal: true

class RootSerializer < ApplicationSerializer
  def to_json
    {
      ending_soonest: ending_soonest,
      most_views: most_views,
      highest_price: highest_price
    }
  end

  private

  def ending_soonest
    Items::GetEndingSoonestQuery.new(0, 10).call
  end

  def most_views
    Items::GetMostViewedQuery.new('DESC', 0, 10).call
  end

  def highest_price
    Items::GetMostExpensiveQuery.new('DESC', 0, 10).call
  end
end
