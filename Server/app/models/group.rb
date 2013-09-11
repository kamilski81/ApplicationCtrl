class Group < ActiveRecord::Base
  has_many :applications

  has_many :positions
  has_many :users, through: :positions

end
