class DailyRecordsController < ApplicationController
  
  def index
    
  end

  def show
    # @user = current_user
    @user = User.first
    @daily_records = @user.daily_records

    @sleep_scores     = @daily_records.map { |record| [record.date, record.sleep] }
    @meal_scores      = @daily_records.map { |record| [record.date, record.meal] }
    @mental_scores    = @daily_records.map { |record| [record.date, record.mental] }
    @training_scores  = @daily_records.map { |record| [record.date, record.training] }
    @condition_scores = @daily_records.map { |record| [record.date, record.condition] }
  end

  def edit
    
  end

  def new
    # @user = User.find(params[:id])
  end

  def create
    
  end

  def update
    
  end

  def destroy
    
  end

end
