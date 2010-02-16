class CreateGames < ActiveRecord::Migration
  def self.up
    create_table :games do |t|
      t.string :name
      t.timestamps
    end
    
    g = Game.new
    g.name = "Card game"
    g.save
  end

  def self.down
    drop_table :games
  end
end
