class CreateDailyRecords < ActiveRecord::Migration[7.0]
  def change
    create_table :daily_records do |t|
      t.references :user, null: false, foreign_key: true
      t.date :date
      t.integer :sleep
      t.integer :meal
      t.integer :mental
      t.integer :training
      t.integer :condition

      t.timestamps
    end
  end
end
