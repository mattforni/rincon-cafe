class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      # References
      t.references :user, null: false

      # Required
      t.string :beverage, null: false, limit: 50
      t.string :location, null: false, limit: 10
      t.string :temperature, null: false, limit: 10

      # Optional
      t.string :decaf, default: nil, limit: 10
      t.string :milk, default: nil, limit: 10
      t.text :notes, default: nil
      t.decimal :shots, default: nil, precision: 1
      t.string :status, default: 'pending', limit: 25

      t.timestamps null: false
    end

    # Unique index
    add_index :orders, [:user_id, :created_at], unique: true

    # Foreign key
    if Rails.env.production?
      execute <<-SQL
        ALTER TABLE orders
          ADD CONSTRAINT fk_orders_users
          FOREIGN KEY (user_id)
          REFERENCES users(id)
      SQL
    end
  end
end

