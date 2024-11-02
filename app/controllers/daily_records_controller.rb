class DailyRecordsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :update, :destroy]

  def index
    @daily_records = current_user.daily_records
    @date     = @daily_records.map { |record| [record.date, record.sleep] }
    @sleep_scores     = @daily_records.map { |record| [record.date, record.sleep] }
    @meal_scores      = @daily_records.map { |record| [record.date, record.meal] }
    @mental_scores    = @daily_records.map { |record| [record.date, record.mental] }
    @training_scores  = @daily_records.map { |record| [record.date, record.training] }
    @condition_scores = @daily_records.map { |record| [record.date, record.condition] }
  end
  
  def show
    @daily_records = current_user.daily_records
    @sleep_scores     = @daily_records.map { |record| [record.date, record.sleep] }
    @meal_scores      = @daily_records.map { |record| [record.date, record.meal] }
    @mental_scores    = @daily_records.map { |record| [record.date, record.mental] }
    @training_scores  = @daily_records.map { |record| [record.date, record.training] }
    @condition_scores = @daily_records.map { |record| [record.date, record.condition] }
  end

  def new
    # @daily_record = current_user.daily_records.build
    @daily_record = current_user.daily_records.new(
      date: Date.today,
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

end