class GalleriesController < HomeController
  inherit_resources
  actions :index, :show
  respond_to :html, :xml
  
  caches_page :show
  caches_action :index
  
  # set the initial the background image
  def index
    index! do |format|
      format.html do
        redirect_to gallery_path(@config.galleries.categories.first)
        return
      end
      format.xml { render :template => '/galleries', :layout => false }
    end
  end
  
  def show
    show! do
      @page_title = "#{@gallery.title} Gallery"
      @page_keywords = @gallery.keywords.blank? ? "#{@gallery.title.downcase}, gallery, photography, portraits, professional" : @gallery.keywords
      @page_description = @gallery.description
      @galleries = @config.galleries.categories
      render :template => '/gallery'
      return
    end
  end
  
  private #-------
    # Defining the collection explicitly for ordering
    def collection
      @galleries ||= @config.galleries.categories
    end
  
end
