class CreateUsers < ActiveRecord::Migration
  def up
    create_table :users do |t|
      t.text :uid, :null => false
      t.text :nickname, :null => false
      t.text :name
      t.text :email
      t.text :avatar_url
      t.timestamps
    end
  end

  def down
    drop_table :users
  end
end
