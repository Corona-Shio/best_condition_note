module DailyRecordsHelper

  def period_graph_link(label, period, view_type = 'daily')
    link_to(
      label,
      graph_daily_records_path(period:, view_type:),
      data: { turbo: false },
      class: period_link_class(period)
    )
  end

  private

  def period_link_class(period)
    base_classes = 'btn'
    @period == period ? "#{base_classes} btn-primary" : "#{base_classes} btn-default"
  end

end