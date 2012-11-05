class BlogController < ApplicationController

  def index
    initalize_variables
  end

  def method_missing(method, *args, &block)
    initalize_variables
    if not @blog_posts[method].nil?
      @author = @blog_posts[method][:author]
      @title = @blog_posts[method][:title]
      @date = @blog_posts[method][:date]
      @body = @blog_posts[method][:body]
      render "blog_post"
    else
      render "404"
    end
  end

  private
    def initalize_variables
      @blog_posts = {
        parking: {
          author: "Zoltan Kiss (kissx012@umn.edu)",
          title: "Free Parking at the UofM",
          date: "Nov 4, 2012",
          body: """<p>
          Turns out, at the UofM there is not only an abundance of events with free food,
          there is also an abundance of places with free parking. Unfortunately I only discovered
          them my sophmore year. My Dad assumed that this obviously doesn't exist, and
          thus stopped me from bringing my car onto the campus my freshman year.
          Little did he, I, and a lot of people know that this is completely false.
          Here are some of my favorite spots. Please comment if I missed a spot.
          </p><br />
          <img src='#{view_context.asset_path('uofm_parking_spots.png')}' />
          """
        }
      }
    end


end
