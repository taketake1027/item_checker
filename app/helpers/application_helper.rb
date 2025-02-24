require 'cgi' # CGIモジュールを使用するために追加

module ApplicationHelper
  def google_calendar_url(event)
    start_time = event.start_date.strftime("%Y%m%dT%H%M%S")
    end_time = event.end_date.strftime("%Y%m%dT%H%M%S")
    
    # 各パラメータをURLエンコード
    name = CGI.escape(event.name)
    details = CGI.escape(event.introduction)
    location = CGI.escape(event.location)

    "https://www.google.com/calendar/render?action=TEMPLATE&text=#{name}&dates=#{start_time}/#{end_time}&details=#{details}&location=#{location}"
  end
end
