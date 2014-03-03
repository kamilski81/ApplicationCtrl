class Team < ActiveRecord::Base

  has_paper_trail

  has_many :users
  has_many :apps

end
