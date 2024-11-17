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
  # def graph
  #   @scores = {
  #     sleep:     aggregate_scores(:sleep),
  #     meal:      aggregate_scores(:meal),
  #     mental:    aggregate_scores(:mental),
  #     training:  aggregate_scores(:training),
  #     condition: aggregate_scores(:condition)
  #   }
  # end

  def index  
  @target_month = params[:month].present? ? parse_month_param(params[:month]) : Date.current

  @month_start = @target_month.beginning_of_month
  @month_end   = @target_month.end_of_month
  
  @calendar_dates = (@month_start..@month_end).to_a
  
  @daily_records = current_user.daily_records
                     .where(date: @month_start..@month_end)
                     .index_by(&:date)
  end

  def graph
    @period    = params[:period]    || 'month'
    @view_type = params[:view_type] || 'daily'

    @daily_records = current_user.daily_records
                                .in_period(@period)
                                .order(date: :asc) 

    # @scores = {
    #   sleep:      DailyRecord.aggregate_scores(@daily_records, :sleep,     view_type: @view_type),
    #   meal:       DailyRecord.aggregate_scores(@daily_records, :meal,      view_type: @view_type),
    #   mental:     DailyRecord.aggregate_scores(@daily_records, :mental,    view_type: @view_type),
    #   training:   DailyRecord.aggregate_scores(@daily_records, :training,  view_type: @view_type),
    #   condition:  DailyRecord.aggregate_scores(@daily_records, :condition, view_type: @view_type)
    # }
    
    @sleep     = DailyRecord.aggregate_scores(@daily_records, :sleep,     view_type: @view_type)
    @meal      = DailyRecord.aggregate_scores(@daily_records, :meal,      view_type: @view_type)
    @mental    = DailyRecord.aggregate_scores(@daily_records, :mental,    view_type: @view_type)
    @training  = DailyRecord.aggregate_scores(@daily_records, :training,  view_type: @view_type)
    @condition = DailyRecord.aggregate_scores(@daily_records, :condition, view_type: @view_type)
    @date      = DailyRecord.aggregate_scores(@daily_records, :date,      view_type: @view_type)
    # @date_labels = @date.map { |date| date.strftime('%m-%d') }
    
    @sleep2     = DailyRecord.aggregate_scores2(@daily_records, :sleep,     view_type: @view_type)
    @meal2      = DailyRecord.aggregate_scores2(@daily_records, :meal,      view_type: @view_type)
    @mental2    = DailyRecord.aggregate_scores2(@daily_records, :mental,    view_type: @view_type)
    @training2  = DailyRecord.aggregate_scores2(@daily_records, :training,  view_type: @view_type)
    @condition2 = DailyRecord.aggregate_scores2(@daily_records, :condition, view_type: @view_type)
    @date2      = DailyRecord.aggregate_scores2(@daily_records, :date,      view_type: @view_type)
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

  def parse_month_param(month_param)
    Date.parse("#{month_param}-01")
  rescue ArgumentError
    Date.current
  end
  
end