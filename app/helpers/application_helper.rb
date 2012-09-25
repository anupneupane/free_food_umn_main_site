module ApplicationHelper
  def menu menu_items
    render 'shared/menu', :menu_items => menu_items
  end

  def menu_with_link menu_items
    render 'shared/menu_with_links', :menu_items => menu_items
  end

  def menu_item_matches_request request, menu_item
    if menu_item.has_key?(:regex)
      menu_item[:regex].match(request) ? true : false
    else
      menu_item[:url] == request
    end
  end

  def format_hours date
    return date.strftime("%l:%M %P")
  end

  def flexible_line_height_link_to text, href
    render partial: 'shared/paragraph_hyper_link', locals: { href: href, text: text }
  end

  def next_month month
    month_adjusted_for_modulous = month - 1
    month_adjusted_for_modulous += 1
    month_adjusted_for_modulous_mod = month_adjusted_for_modulous % 12
    return month_adjusted_for_modulous_mod + 1
  end

  def previous_month month
    month_adjusted_for_modulous = month - 1
    month_adjusted_for_modulous -= 1
    month_adjusted_for_modulous = 11 if month_adjusted_for_modulous < 0
    month_adjusted_for_modulous_mod = month_adjusted_for_modulous % 12
    return month_adjusted_for_modulous_mod + 1
  end

  def next_months_year month, year
    month == 12 ? year + 1 : year
  end


  def previous_months_year month, year
    month == 1 ? year - 1 : year
  end

end
