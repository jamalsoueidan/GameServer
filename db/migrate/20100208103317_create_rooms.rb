class CreateRooms < ActiveRecord::Migration
  def self.up
    create_table :rooms do |t|
      t.string :salt
      t.integer :max_players 
      t.integer :joined_players, :default => 0
      t.timestamps
    end
    
    room = Room.new
    room.salt = "jamal"
    room.max_players = 2
    room.save
  end

  def self.down
    drop_table :rooms
  end
end
