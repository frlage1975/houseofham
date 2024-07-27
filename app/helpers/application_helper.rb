module ApplicationHelper
  def flash_class(level)
    case level
    when 'notice' then 'blue'
    when 'success' then 'green'
    when 'error' then 'red'
    when 'alert' then 'yellow'
    else 'blue'
    end
  end
end
