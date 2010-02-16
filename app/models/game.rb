class Game < ActiveRecord::Base
  has_many :lobbies
  has_many :rooms, :through => :lobbies
end
