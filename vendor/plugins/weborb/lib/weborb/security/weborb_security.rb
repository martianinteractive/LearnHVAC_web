class WebORBSecurity

  def WebORBSecurity.add_user( username, password, user_roles )
    @@user_to_password[ username ] = password
	@@user_to_roles[ username ] = user_roles
  end

  def WebORBSecurity.check_credentials( username, password )
    user_password = @@user_to_password[ username ]
    
    if(user_password.nil? or user_password != password)
      raise "Invalid credentials"
    end
  end

  def WebORBSecurity.secure_resource(destination_id)
    @@secure_resources[destination_id] = destination_id
  end
  
  def WebORBSecurity.resource_secure?(destination_id)
    !@@secure_resources[destination_id].nil?
  end
  
  def WebORBSecurity.set_auth_handler(handler)
    @@auth_handler = handler
  end

  def WebORBSecurity.get_auth_handler
    @@auth_handler
  end
  
  def WebORBSecurity.init
    @@user_to_password = Hash.new
	@@user_to_roles = Hash.new
	@@secure_resources = Hash.new
  end
end