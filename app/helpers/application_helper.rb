module ApplicationHelper
  def menu menu_items
    render 'shared/menu', :menu_items => menu_items
  end
end
