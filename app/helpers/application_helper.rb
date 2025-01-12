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

  def default_meta_tags
    {
      site: 'Best Condition Note',
      description: '日々の記録が、未来のあなたをデザインする。Best Condition Noteは、あなたの日々の体調の記録を簡単に残せる記録アプリです。',
      reverse: true,
      separator: '|',
      og: default_og,
      # twitter: default_twitter_card
    }
  end
  
  private
  
  def default_og
    {
      title: :full_title,
      description: :description,
      url: request.url,
      image: asset_url('ogp/720p.png'),
      type: 'website',
      site_name: 'Best Condition Note'
    }
  end
  
  # def default_twitter_card
  #   {
  #     card: 'summary_large_image',
  #     site: '@hogehoge'
  #   }
  # end

end
