class StaticPagesController < ApplicationController
  def home
    # defaultが走る => app/views/static_pages/home.html.erb
  end

  def help
    #app/views/static_pages/help.html.erb
  end
  
  def about
  end
end
