module ApplicationHelper

  # ページごとの完全なタイトルを返す
  def full_title(page_title = '')
    base_title = "Best Condition Note"
    if page_title.empty?
      base_title
    else
      "#{page_title} | #{base_title}"
    end
  end

  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash"
  end

end
