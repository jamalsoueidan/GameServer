class Room < ActiveRecord::Base
  has_many :players
  belongs_to :game
  
  def is_full?
    joined_players >= max_players
  end
end
