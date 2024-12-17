class DailyRecordsController < ApplicationController
  before_action :logged_in_user,      only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,        only: [:show, :edit, :update, :destroy]
  before_action :check_direct_access, only: [:show, :edit, :empty]

  def index
    @target_month = params[:month].present? ? parse_month_param(params[:month]) : Date.current
  
    @month_start = @target_month.beginning_of_month
    @month_end   = @target_month.end_of_month
    
    @calendar_dates = (@month_start..@month_end).to_a
    
    @daily_records = current_user.daily_records
                      .where(date: @month_start..@month_end)
                      .index_by(&:date)
  end

  def show
    @daily_record = current_user.daily_records.find(params[:id])
  end

  def empty
    @date = params[:date]
  end

  def new
    @date = params[:date].present? ? Date.parse(params[:date]) : Date.current
    @daily_record = current_user.daily_records.new(
      date: @date, sleep: 3, meal: 3, mental: 3, training: 3, condition: 3
    )
  end

  def create
    @daily_record = current_user.daily_records.build(daily_record_params)

    respond_to do |format|
      if @daily_record.save
        
        format.html do # 通常はこちら
          flash[:success] = "Daily record created!"
          redirect_to root_path 
        end
        
        format.turbo_stream do # Turbo Streamsリクエストはこちら
          flash.now[:success] = "Daily_records created!"
        end

      else
        format.html         { render :new, status: :unprocessable_entity }
        format.turbo_stream { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit
    @daily_record = current_user.daily_records.find(params[:id])
  end

  def update
    @daily_record = current_user.daily_records.find(params[:id])

    respond_to do |format|
      if @daily_record.update(daily_record_params)
        flash.now[:success] = "Daily record updated"
        format.html { redirect_to daily_records_path }
        format.turbo_stream
      else
        format.html         { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
    end
  end

  def graph
    @period    = params[:period]    || 'month'
    @view_type = params[:view_type] || 'daily'

    @daily_records = current_user.daily_records
                                .in_period(@period)
                                .order(date: :asc) 
    
    @sleep     = DailyRecord.aggregate_scores2(@daily_records, :sleep,     view_type: @view_type)
    @meal      = DailyRecord.aggregate_scores2(@daily_records, :meal,      view_type: @view_type)
    @mental    = DailyRecord.aggregate_scores2(@daily_records, :mental,    view_type: @view_type)
    @training  = DailyRecord.aggregate_scores2(@daily_records, :training,  view_type: @view_type)
    @condition = DailyRecord.aggregate_scores2(@daily_records, :condition, view_type: @view_type)
    @date      = DailyRecord.aggregate_scores2(@daily_records, :date,      view_type: @view_type)
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
  
    def check_direct_access
      unless turbo_frame_request?
        flash[:warning] = "直接のアクセスはサポートされていません"
        redirect_to daily_records_path
      end
    end

end