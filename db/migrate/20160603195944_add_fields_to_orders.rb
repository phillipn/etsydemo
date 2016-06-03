class AddFieldsToOrders < ActiveRecord::Migration
  def change
    add_column :orders, :buyer_id, :integer, index: true
    add_column :orders, :seller_id, :integer, index: true
  end
end
