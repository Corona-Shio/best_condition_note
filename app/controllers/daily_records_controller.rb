class DailyRecordsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  # def index
  #   if params[:start_date].present? && params[:end_date].present?
  #     @daily_records = current_user.daily_records.where(date: params[:start_date]..params[:end_date])
  #   else
  #     @daily_records = current_user.daily_records
  #   end
  #   @sleep_scores     = @daily_records.pluck(:date, :sleep)
  #   @meal_scores      = @daily_records.pluck(:date, :meal)
  #   @mental_scores    = @daily_records.pluck(:date, :mental)
  #   @training_scores  = @daily_records.pluck(:date, :training)
  #   @condition_scores = @daily_records.pluck(:date, :condition)
  # end
  # 
  def index  
    if params[:start_date].present? && params[:end_date].present?
      @daily_records2 = current_user.daily_records.where(date: params[:start_date]..params[:end_date])
    else
      @daily_records2 = current_user.daily_records
    end
    @sleep_scores     = @daily_records2.pluck(:date, :sleep)
    @meal_scores      = @daily_records2.pluck(:date, :meal)
    @mental_scores    = @daily_records2.pluck(:date, :mental)
    @training_scores  = @daily_records2.pluck(:date, :training)
    @condition_scores = @daily_records2.pluck(:date, :condition)

    @date = params[:date] ? Date.parse(params[:date]) : Date.current
    @start_date = @date.beginning_of_month
    @end_date = @date.end_of_month
    
    # 月の全日付を生成
    @dates = (@start_date..@end_date).to_a
    
    # 指定月のレコードを取得
    @daily_records = current_user.daily_records
                                .where(date: @start_date..@end_date)
                                .index_by(&:date)
  end

  def graph
    @period    = params[:period]    || 'month'
    @view_type = params[:view_type] || 'daily'

    @daily_records = current_user.daily_records
                                .where(date: date_range)
                                .order(date: :asc)

    @scores = {
      sleep:     aggregate_scores(:sleep),
      meal:      aggregate_scores(:meal),
      mental:    aggregate_scores(:mental),
      training:  aggregate_scores(:training),
      condition: aggregate_scores(:condition)
    }

    @scores2 = {
      sleep:      aggregate_scores(:sleep).map     { |date, score| [date, score + 6 * 4] },
      meal:       aggregate_scores(:meal).map      { |date, score| [date, score + 6 * 3] },
      mental:     aggregate_scores(:mental).map    { |date, score| [date, score + 6 * 2] },
      training:   aggregate_scores(:training).map  { |date, score| [date, score + 6 * 1] },
      condition:  aggregate_scores(:condition).map { |date, score| [date, score + 6 * 0] }
    }


  end
  
  def show
    @daily_records = current_user.daily_records
    @sleep_scores     = @daily_records.pluck(:date, :sleep)
    @meal_scores      = @daily_records.pluck(:date, :meal)
    @mental_scores    = @daily_records.pluck(:date, :mental)
    @training_scores  = @daily_records.pluck(:date, :training)
    @condition_scores = @daily_records.pluck(:date, :condition)
  end

  def new
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @daily_record = current_user.daily_records.new(
      date: @date,
      sleep:     3,
      meal:      3,
      mental:    3,
      training:  3,
      condition: 3
    )
    @is_edit = false
  end

  def create
    @daily_record = current_user.daily_records.build(daily_record_params)
    if @daily_record.save
      flash[:success] = "Daily_records created!"
      redirect_to daily_records_path
    else
      render 'daily_records/new', status: :unprocessable_entity
    end
  end

  def edit
    @daily_record = current_user.daily_records.find(params[:id])
    @is_edit = true
  end

  def update
    @daily_record = current_user.daily_records.find(params[:id])
    if @daily_record.update(daily_record_params)
      flash[:success] = "Daily record updated"
      redirect_to daily_records_path
    else
      render 'edit', status: :unprocessable_entity
    end
  end

  private

  def daily_record_params
    params.require(:daily_record).permit(:date,   :sleep,    :meal,
                                         :mental, :training, :condition)
  end

  def correct_user
    @daily_record = current_user.daily_records.find_by(id: params[:id])
    redirect_to daily_records_path if @daily_record.nil?
  end

  def date_range
    case @period
    when 'month'
      1.month.ago.beginning_of_day..Time.current
    when 'three_months'
      3.months.ago.beginning_of_day..Time.current
    when 'year'
      1.years.ago.beginning_of_day..Time.current
    else
      1.month.ago.beginning_of_day..Time.current
    end
  end
  
  def aggregate_scores(attribute)
    case @view_type
    when 'daily'
      @daily_records.pluck(:date, attribute)
    when 'weekly'
      @daily_records
        .group_by { |record| record.date.beginning_of_week }
        .map do |week, records|
          # 平均値を手動で計算
          average = records.sum { |r| r.send(attribute) }.to_f / records.size
          [week, average.round(1)]
        end
    end
  end
end