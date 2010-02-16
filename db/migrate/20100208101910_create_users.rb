class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email, :name, :hashed_password, :salt
      t.string :key
      t.boolean :is_active, :requested_new_password, :default => false
      t.datetime :created_at, :logged_at
    end
    
    u = User.new
    u.name = "Jamal"
    u.email = "test@test.dk"
    u.password = "testerne"
    u.password_confirmation = "testerne"
    u.key = "Jamal"
    u.is_active = true
    u.save

    u = User.new
    u.name = "Martin"
    u.email = "martin@test.dk"
    u.password = "testerne"
    u.password_confirmation = "testerne"
    u.key = "Martin"
    u.is_active = true
    u.save

    u = User.new
    u.name = "Thomas"
    u.email = "test@ttest.dk"
    u.password = "testerne"
    u.password_confirmation = "testerne"
    u.key = "Thomas"
    u.is_active = true
    u.save

    u = User.new
    u.name = "Niels"
    u.email = "test@atest.dk"
    u.password = "testerne"
    u.password_confirmation = "testerne"
    u.key = "Niels"
    u.is_active = true
    u.save
  end

  def self.down
    drop_table :users
  end
end
