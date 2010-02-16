class CreateLobbies < ActiveRecord::Migration
  def self.up
    create_table :lobbies do |t|
      t.integer :game_id
      t.string :name
      t.string :key
      t.integer :max_sessions, :default => 300
      t.integer :joined_sessions, :default => 0
      t.timestamps
    end
    
    l = Game.first.lobbies.create
    l.name = "Fed spil"
    l.key = "debug"
    l.save
  end

  def self.down
    drop_table :lobbies
  end
end
