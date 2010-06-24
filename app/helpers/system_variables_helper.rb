module SystemVariablesHelper
  def paginate_renderer
    params[:filter].present? ? 'PostLinkRenderer' : 'WillPaginate::ViewHelpers::LinkRenderer' 
  end
end
