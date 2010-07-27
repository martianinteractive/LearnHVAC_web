class Admins::Groups::EmailsController < Admins::Groups::BaseController
    
  def index
  end

  def show
  end

  def new
    @email = @group.notification_emails.new
  end

end
