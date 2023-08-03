class SetStatusValueDefaultInSessions < ActiveRecord::Migration[7.0]
  def change
    change_column :sessions, :status, :boolean, default: true, null: false
  end
end
