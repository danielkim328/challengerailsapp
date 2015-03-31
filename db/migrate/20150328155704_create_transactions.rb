class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :transaction_type
      t.decimal :amount

      t.timestamps null: false
    end
  end
end
