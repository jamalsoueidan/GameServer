class CreatePlayers < ActiveRecord::Migration
  def self.up
    create_table :players do |t|
      t.integer :user_id, :room_id 
      t.text :user_name
    end
  end

  def self.down
    drop_table :players
  end
end
