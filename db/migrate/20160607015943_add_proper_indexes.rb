class AddProperIndexes < ActiveRecord::Migration
  def change
  	add_index :orders, :created_at
  	add_index :listings, :created_at
  end
end
