require File.dirname(__FILE__) + '/../test_helper'

class UserTest < Test::Unit::TestCase
  
  fixtures :users

  def test_should_create_user
    assert_difference 'User.count' do
      user = create_user
      assert !user.new_record?, "#{user.errors.full_messages.to_sentence}"
    end
  end

  def test_should_require_login
    assert_no_difference 'User.count' do
      u = create_user(:login => nil)
      assert u.errors.on(:login)
    end
  end

  def test_should_require_password
    assert_no_difference 'User.count' do
      u = create_user(:password => nil)
      assert u.errors.on(:password)
    end
  end

  def test_should_require_password_confirmation
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => nil)
      assert u.errors.on(:password_confirmation)
    end
  end
  
  def test_should_require_password_and_confirmation_to_match
    assert_no_difference 'User.count' do
      u = create_user(:password_confirmation => 'phoneybaloney')
      assert u.errors.on(:password)
    end
  end

  def test_should_require_email
    assert_no_difference 'User.count' do
      u = create_user(:email => nil)
      assert u.errors.on(:email)
    end
  end

  def test_should_reset_password
    users(:daniel).update_attributes(:password => 'new password', :password_confirmation => 'new password')
    assert_equal users(:daniel), User.authenticate('daniel', 'new password')
  end

  def test_should_not_rehash_password
    users(:daniel).update_attributes(:login => 'daniel2')
    assert_equal users(:daniel), User.authenticate('daniel2', 'cruz')
  end

  def test_should_authenticate_user
    assert_equal users(:daniel), User.authenticate('daniel', 'cruz')
  end
  

protected
  def create_user(options = {})
    
    @superadmin = Role.find_by_name('superadmin')
    
    record = User.new({ :login => 'testperson', 
                        :email => 'testperson@example.com', 
                        :password => 'testperson', 
                        :password_confirmation => 'testperson',
                        :role_id => @superadmin.id, 
                        :institution_id => 1
                         }.merge(options))
    record.save
    record
  end
end
