class DailyRecord < ApplicationRecord
  belongs_to :user
  default_scope -> { order(date: :asc) }
  validates :date, presence: true, 
             uniqueness: { scope: :user_id, message: "has already been taken" }
  validates :sleep,      presence: true, numericality: { in: 1..5 }
  validates :meal,       presence: true, numericality: { in: 1..5 }
  validates :mental,     presence: true, numericality: { in: 1..5 }
  validates :training,   presence: true, numericality: { in: 1..5 }
  validates :condition,  presence: true, numericality: { in: 1..5 }
end
  