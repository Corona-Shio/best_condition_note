class DailyRecord < ApplicationRecord
  belongs_to :user
  default_scope -> { order(date: :asc) }
  validates :date, presence: true, uniqueness: { scope: :user_id }
  validates :sleep,      presence: true, numericality: { in: 1..5 }
  validates :meal,       presence: true, numericality: { in: 1..5 }
  validates :mental,     presence: true, numericality: { in: 1..5 }
  validates :training,   presence: true, numericality: { in: 1..5 }
  validates :condition,  presence: true, numericality: { in: 1..5 }

  # 重みづけ定数
  SCORE_WEIGHTS = {
    sleep:     6 * 4,
    meal:      6 * 3,
    mental:    6 * 2,
    training:  6 * 1,
    condition: 6 * 0,
    date:      6 * 0,
  }

  # 期間でフィルタするスコープ
  scope :in_period, ->(period) {
    case period
    when 'month'
      where(date: 1.month.ago..Time.current)
    when 'three_months'
      where(date: 3.months.ago..Time.current)
    when 'year'
      where(date: 1.year.ago..Time.current)
    else
      where(date: 3.month.ago..Time.current)
    end
  }

  def self.aggregate_scores(records, attribute, view_type: 'daily')
    case view_type
    when 'daily'
      records.pluck(attribute)
    when 'weekly'
      if attribute == :date
        records
          .group_by { |record| record.date.beginning_of_week }
          .map { |week, _| week }
      else
        records
          .group_by { |record| record.date.beginning_of_week }
          .map do |_, weekly_records|
            average = weekly_records.sum { |r| r.send(attribute) }.to_f / weekly_records.size
            average.round(1)
          end
      end
    end
  end

end