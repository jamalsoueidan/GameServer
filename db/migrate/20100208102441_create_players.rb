class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players, :id => false do |t|
      t.integer :user_id, :session_id, :game_id 
    end
  end

  def self.down
    drop_table :players
  end
end
