# frozen_string_literal: true

class UserShowSerializer < ApplicationSerializer
  def to_json
    {
      username: @user[:username],
      shared_items: shared_items,
      liked: liked
    }
  end

  private

  def shared_items
    Items::GetCommonLikedItemsQuery.new(@current_user_id, @user[:id]).call
  end

  def liked
    Items::GetLikedItemsQuery.new(@user[:id]).call
  end
end
