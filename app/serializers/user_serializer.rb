# frozen_string_literal: true

class UserSerializer < ApplicationSerializer
  def to_json
    {
      user: user,
      tokens: @tokens
    }
  end

  private

  def user
    {
      id: @user[:id],
      username: @user[:username]
    }
  end
end
