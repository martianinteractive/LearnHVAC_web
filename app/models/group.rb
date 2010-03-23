class Group < ActiveRecord::Base
  belongs_to :instructor, :class_name => "User", :foreign_key => "instructor_id"
  has_many :memberships, :dependent => :destroy
  has_many :students, :through => :memberships
  
  validates :name, :presence => true, :length => { :maximum => 200 }, :uniqueness => true
  validates :code, :presence => true, :length => { :maximum => 200 }, :uniqueness => true, :on => :update
  validates :instructor, :presence => true
  
  after_create :set_code
    
  private
  
  def set_code
    rcode = secure_rand
    while(rcode)
      self.code = rcode
      rcode = Group.find_by_code(rcode) ? secure_rand : nil
    end
    self.save(:validate => false)
  end
  
  def secure_rand
    ActiveSupport::SecureRandom.hex(3)
  end
  
end
