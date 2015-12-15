class Movie < ActiveRecord::Base
  def self.all_ratings
    %w(G PG PG-13 NC-17 R)
  end

  def self.get_same_director(director)
    return [] unless director != ""
    self.where director: director
  end
end
