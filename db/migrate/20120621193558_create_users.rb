class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.integer :likes, default: 50

      t.timestamps
    end
  end
end
