# frozen_string_literal: true

class ItemSerializer < ApplicationSerializer
  def to_json
    {
      item: @item,
      history: Items::GetBidsHistoryQuery.new(@item[:id]).call,
      user_likes: Items::GetUserLikesItemQuery.new(@item[:id], @user_id).call
    }
  end
end
