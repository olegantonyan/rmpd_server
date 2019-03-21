module Paginateble
  extend ActiveSupport::Concern

  def limit
    [(params[:limit] || default_limit).to_i, max_limit].min
  end

  def offset
    params[:offset].to_i * limit
  end

  def default_limit
    20
  end

  def max_limit
    150
  end
end
