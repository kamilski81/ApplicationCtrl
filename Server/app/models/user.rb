class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  has_many :user_groups
  has_many :groups, through: :user_groups

  has_many :positions
  has_many :roles, through: :positions


  # next step is to merge user_group table with position
  # we can define a different role for each group
  def role?(role)
    role_result = self.roles.where(name: role)
    return !role_result.blank?
  end

end
