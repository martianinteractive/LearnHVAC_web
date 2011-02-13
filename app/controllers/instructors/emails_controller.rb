class Instructors::EmailsController < Instructors::ApplicationController
  before_filter :find_group
  
  def index
    @emails = @group.notification_emails.paginate(:page => params[:page], :per_page => 25, :order => "id desc")
    add_crumb "Emails", instructors_class_emails_path(@group)
  end

  def show
    @email = @group.notification_emails.find(params[:id])
  end

  def new
    @email = @group.notification_emails.new
    add_crumb "New Email", new_instructors_class_email_path(@group)
  end
  
  def create
    @email = @group.notification_emails.new(params[:class_notification_email])
    
    if @email.save
      redirect_to instructors_class_email_path(@group, @email), :notice => "The notification email has been sent"
    else
      render :action => :new
    end
  end
  
  private
  
  def find_group
    @group = current_user.managed_groups.find(params[:class_id])
    add_crumb @group.name, instructors_class_path(@group)
  end
  
end
