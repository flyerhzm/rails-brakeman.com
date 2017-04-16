module ApplicationHelper
  ALERT_CLASS_NAMES = {
    notice: :success,
    alert: :danger,
    error: :danger
  }
  def notice_message
    flash_messages = []

    flash.each do |type, message|
      type = ALERT_CLASS_NAMES[type.to_sym] || type.to_sym
      text = content_tag(:div, message, class: "alert alert-#{type}")
      flash_messages << text if message
    end

    flash_messages.join("\n").html_safe
  end

  def latest_repositories
    Repository.latest.limit(10)
  end
end
