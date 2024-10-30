class AddIndexToDailyRecords < ActiveRecord::Migration[7.0]
  def change
    add_index :daily_records, [:user_id, :date], unique: true
  end
end
