class Lobby < ActiveRecord::Base
  belongs_to :game
  has_many :rooms
  has_many :sessions
  
  def is_full?
    joined_sessions >= max_sessions
  end
end
