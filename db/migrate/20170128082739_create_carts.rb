class CreateCarts < ActiveRecord::Migration
  def change
    create_table :carts do |t|
      t.string :order_id
      t.decimal :amount, precision: 12, scale: 3
      t.boolean :status
      t.date  :payment_date
      t.timestamps
    end
  end
end
