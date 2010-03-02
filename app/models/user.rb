class User < ActiveRecord::Base
  ROLES = { :guest => 0, :student => 1, :instructor => 2, :administrator => 3, :superadmin => 4 }
  acts_as_authentic
end
