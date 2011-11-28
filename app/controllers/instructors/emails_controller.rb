class Instructors::EmailsController < Instructors::ApplicationController

  layout 'bootstrap'

  before_filter :find_group

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
      redirect_to instructors_class_email_path(@group, @email), :notice => "The notification email has been sent"
    else
      render :action => :new
    end
  end

  private

  def find_group
    @group = current_user.managed_groups.find(params[:class_id])
  end

end
