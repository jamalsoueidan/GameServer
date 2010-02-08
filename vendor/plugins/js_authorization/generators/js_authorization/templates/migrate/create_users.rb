class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :name, :hashed_password, :salt
      t.boolean :is_active, :requested_new_password, :default => false
      t.datetime :created_at, :logged_at
    end
  end

  def self.down
    drop_table :users
  end
end
