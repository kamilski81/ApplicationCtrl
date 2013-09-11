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

  def role?(role)
    return !!self.roles.where(name: role)
  end

end
