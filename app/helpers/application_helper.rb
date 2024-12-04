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

  # ヘッダーのテキストをサイズによって切り替える
  def responsive_text(full_text, short_text = nil)
    short_text ||= full_text # short_textが指定されていない場合、full_textをそのまま使用
    
    content_tag(:span) do
      concat(content_tag(:span, full_text,  class: 'full-text'))
      concat(content_tag(:span, short_text, class: 'short-text'))
    end
  end

  def turbo_stream_flash
    turbo_stream.update "flash", partial: "shared/flash"
  end

end
