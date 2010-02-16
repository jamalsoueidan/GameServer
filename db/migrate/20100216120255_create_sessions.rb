class CreateSessions < ActiveRecord::Migration
  def self.up
    create_table :sessions do |t|
      t.integer :user_id, :lobby_id
      t.text :user_name
    end
  end

  def self.down
    drop_table :sessions
  end
end
