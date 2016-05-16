class User < ActiveRecord::Base
  #before_create :set_user_type
  has_many :assignments
  #has_many :pathways
  belongs_to :department
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  ## Scope
  scope :user_except_content_admin, -> (user) { where('type NOT IN (?) and department_id in (?)', ["ContentAdmin","SuperAdmin"], user.department.group.departments.pluck(:id)) }
  scope :users_from_same_group, -> (user) { where('department_id in (?)', user.department.group.departments.pluck(:id))}
  scope :user_except_super_admin, -> (user) { where('type NOT IN (?)', ["SuperAdmin"]) }
  #validation
  # validates :first_name, presence:true
  # validates :last_name, presence:true
  # validates :title, presence:true
  # validates :mobile_number, presence:true , :length=>{:in => 10..13}
  
  #Helper method to check current_user is super_admin, content_admin , local_admin or user
  def super_admin?
    self.type=="SuperAdmin"
  end
  def content_admin?
  	self.type=="ContentAdmin" 
  end
  def local_admin?
  	self.type=="LocalAdmin" 
  end
  def user?
  	self.type=="LocalUser" 
  end

  #Helper method to set user type default as user
  # def set_user_type
  #   self.type="LocalUser" 
  # end

  def fullname
    "#{self.first_name} #{self.last_name}"
  end

end
