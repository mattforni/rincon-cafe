class ChangeAdminToBarista < ActiveRecord::Migration
  def change
    rename_column :users, :admin, :barista
  end
end

