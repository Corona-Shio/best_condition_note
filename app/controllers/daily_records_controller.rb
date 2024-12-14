class DailyRecordsController < ApplicationController
  before_action :logged_in_user, only: [:index, :show, :edit, :update, :destroy]
  before_action :correct_user,   only: [:edit, :show, :update, :destroy]

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
  
    respond_to do |format|
      format.html do
        if turbo_frame_request?
          # # 空のレコード用のturbo_stream応答を追加
          # render turbo_stream: turbo_stream.replace(
          #   "record_new", 
          #   partial: "empty_record", 
          #   locals: { date: @daily_record.date }
          # )
          # format.turbo_stream
        else
          redirect_to daily_records_path
        end
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
        # 通常はこちら
        format.html do
          flash[:success] = "Daily record created!"
          redirect_to root_path 
        end
        # Turbo frameリクエストはこちら
        format.turbo_stream do
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

    # URLで直接/editに遷移した場合はindexにリダイレクトする
    respond_to do |format|
      format.html do
        if turbo_frame_request?
          format.turbo_stream
        else
          redirect_to daily_records_path
        end
      end
    end
  end

  def update
    @daily_record = current_user.daily_records.find(params[:id])

    respond_to do |format|
      if @daily_record.update(daily_record_params)
        flash.now[:success] = "Daily record updated"
        format.html { redirect_to daily_records_path } # 通常はこちら
        format.turbo_stream # turboはこちら：update.turbo_stream.erbを参照
      else
        format.html         { render :edit, status: :unprocessable_entity }
        format.turbo_stream { render :edit, status: :unprocessable_entity }
      end
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