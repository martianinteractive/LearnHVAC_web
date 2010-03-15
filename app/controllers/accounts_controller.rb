class AccountsController < ApplicationController
  before_filter :require_no_user
  layout 'user_sessions'
  
  def new
    @account = User.new
  end
  
  def create
    
  end
  
end
