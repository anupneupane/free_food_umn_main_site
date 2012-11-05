module BlogHelper
  def blog_post author, title, date, body, path
    render 'blog_layout', author: author, title: title, date: date, body: body, path: path
  end
end
