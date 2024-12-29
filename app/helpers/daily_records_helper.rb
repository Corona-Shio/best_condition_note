module DailyRecordsHelper

  def period_graph_link(label, period, view_type = 'daily')
    link_to(
      label,
      graph_daily_records_path(period:, view_type:),
      data: { turbo: false },
      class: period_link_class(period)
    )
  end

  def has_today_record?
    current_user.daily_records.where(date: Date.current).exists?
  end

  def weekend_day_class(date)
    case 
    when date.saturday?
      'saturday'
    when date.sunday?
      'sunday'
    else
      'weekday'
    end
  end

  private

  def period_link_class(period)
    base_classes = 'btn'
    @period == period ? "#{base_classes} btn-primary" : "#{base_classes} btn-default"
  end

end
