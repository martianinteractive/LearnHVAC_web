require 'digest/sha1'

class User < ActiveRecord::Base
	include SavageBeast::UserInit
	belongs_to :institution
  belongs_to :role
  has_many :activities
  attr_protected :id, :salt
  
  # Virtual attribute for the unencrypted password
  attr_accessor :password, :password_confirmation
  
  validates_length_of :login, :within => 3..40, :message => "Login must be between 3 and 40 characters."
  validates_format_of :email, :with => /^([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})$/i, :message => "Invalid email"  
  validates_uniqueness_of :login, :on => :create, :message => "That login name is already taken. Please choose another login name."
  
  validates_presence_of :password, :on=>:create, :if => :password_required?, :message => "Password must be between 5 and 20 characters."
  validates_presence_of :password_confirmation, :on=>:create, :if => :password_required?, :message => "Please enter the password in the confirmation field."
  validates_length_of :password, :on=>:create, :within => 5..20, :message => "Password must be between 5 and 20 characters."
  validates_confirmation_of :password, :on => :create, :message => "Please make sure the password and password confirmation match."
  
  before_save :encrypt_password
  cattr_accessor :current_user
  

  def self.authenticate(login, password)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end  
  
  # This is the authentication routine used by the Flex client via remoting. 
  def self.remote_authenticate(login, pass)
    u = find_by_login(login) # need to get the salt
    u && u.authenticated?(password) ? u : nil
  end 


  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest(salt+password)
  end
  
  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end
  
  def authenticated?(password)
    hashed_password == encrypt(password)
  end
  
  def authorize()    
    self.role.name=="administrator"
  end

  def send_new_password
    new_pass = User.random_string(10)
    self.password = self.password_confirmation = new_pass
    self.save
    Notifications.deliver_forgot_password(self.email, self.login, new_pass)
  end
  
  def display_name
    "#{first_name.capitalize} #{last_name.capitalize}"
  end

  protected

     # before filter 
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.hashed_password = encrypt(password)
    end
    
    def password_required?
      hashed_password.blank? || !password.blank?
    end

	
end
