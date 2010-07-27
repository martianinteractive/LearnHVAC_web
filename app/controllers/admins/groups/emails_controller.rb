class Admins::Groups::EmailsController < Admins::Groups::BaseController
    
  def index
  end

  def show
  end

  def new
    @email = @group.notification_emails.new
  end
  
  def create
    @email = @group.notification_emails.new(params[:class_email_notification])
    
    if @email.save
      redirect_to admins_group_email_path(@group, @email), :notice => "The notification email has been sent"
    else
      render :action => :new
    end
  end

end
