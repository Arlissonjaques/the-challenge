class SetDefaultValueToRoleColumn < ActiveRecord::Migration[7.0]
  def change
    change_column :users, :role, :integer, default: 1, null: false
  end
end
