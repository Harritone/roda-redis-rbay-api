# frozen_string_literal: true

module Items
  class ItemParams < ApplicationParams
    params do
      required(:name).filled(:string)
      required(:description).filled(:string)
      required(:image_url).filled(:string)
      required(:duration).filled(:integer)
    end
  end
end
