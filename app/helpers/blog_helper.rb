module BlogHelper
  def blog_post author, title, date, body
    render 'blog_layout', author: author, title: title, date: date, body: body
  end
end
