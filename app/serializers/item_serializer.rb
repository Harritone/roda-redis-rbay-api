# frozen_string_literal: true

class ItemSerializer < ApplicationSerializer
  def to_json
    {
      item: @item,
      history: Items::GetBidsHistoryQuery.new(@item[:id]).call,
      user_likes: Items::GetUserLikesItemQuery.new(@item[:id], @user_id).call,
      user_has_highest_bid: @item[:highest_bid_user_id] == @user_id
    }
  end
end
