class HomeController < ApplicationController
  layout 'layout' #kind of a cheat so we don't need to use a layouts directory in the themes folders
  
  skip_before_filter :config, :only => :config_error
  before_filter :prepend_theme, :except => :config_error # applies a theme
  before_filter :load_pages
  
  caches_page :index
  
  def config_error
    render :layout => false, :template =>  '/config_error.html'
  end
  
  # landing page
  def index
    @page_title = @config.home_page_title ||= 'Photographer'
    @galleries = @config.galleries.find :all
    render :template => '/home'
  end
  
  def not_found
    render :template => '/404', :status => :not_found
  end
  
  # if you're not getting a lot of traffic you can setup a cron to hit
  #  /timestamp every minute which will keep passeger spooled up without the
  #  need to increase timeouts.
  def timestamp
    render :text => Time.now
  end
  
  private #------
  
    # prepend the chosen (or default) theme
    def prepend_theme
      #session[:preview] = params[:preview] if params[:preview]
      #self.prepend_view_path(config.theme_path(session[:preview]))
      #flash[:notice] = "You're in preview mode" if session[:preview]
      self.prepend_view_path(config.theme_path)
    end
    
    def load_pages
      @pages = Page.find :all, :order => 'position'
      @quotes = Quote.find :all, :order => 'position'
    end
    
end