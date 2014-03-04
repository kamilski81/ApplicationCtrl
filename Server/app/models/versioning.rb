class Versioning < ActiveRecord::Base

  has_paper_trail

  belongs_to :app

  validates :profile, :build, :app_id, presence: true
end
