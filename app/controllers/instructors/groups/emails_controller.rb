class Instructors::Groups::EmailsController < Instructors::Groups::BaseController
  
  def index
    @emails = @group.notification_emails.paginate(:page => params[:page], :per_page => 25, :order => "id desc")
  end

  def show
    @email = @group.notification_emails.find(params[:id])
  end

  def new
    @email = @group.notification_emails.new
  end
  
  def create
    @email = @group.notification_emails.new(params[:class_notification_email])
    
    if @email.save
      redirect_to instructors_group_email_path(@group, @email), :notice => "The notification email has been sent"
    else
      render :action => :new
    end
  end
  
end
