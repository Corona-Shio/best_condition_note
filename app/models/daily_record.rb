class DailyRecord < ApplicationRecord
  belongs_to :user
  validates :date, presence: true
  validates :sleep,     numericality: { in: 1..5 }
  validates :meal,      numericality: { in: 1..5 }
  validates :mental,    numericality: { in: 1..5 }
  validates :training,  numericality: { in: 1..5 }
  validates :condition, numericality: { in: 1..5 }
end
