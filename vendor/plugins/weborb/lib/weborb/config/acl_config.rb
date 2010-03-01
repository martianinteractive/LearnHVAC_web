class AclConfig
  def AclConfig.configure(config_element)
    acl_element = config_element.elements['acl']
    
    acl_element.elements.each( 'user' ) do | user_element |
      name_element = user_element.elements['name']
      password_element = user_element.elements['password']
      username = name_element.get_text.to_s
      password = password_element.get_text.to_s
      user_roles = Array.new
      user_element.elements.each('role') {|role_element| user_roles.push(role_element.get_text.to_s)}
      WebORBSecurity.add_user( username, password, user_roles )
    end
  end
end