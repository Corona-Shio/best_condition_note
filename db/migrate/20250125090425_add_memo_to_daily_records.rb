class AddMemoToDailyRecords < ActiveRecord::Migration[7.0]
  def change
    add_column :daily_records, :memo, :text
  end
end
