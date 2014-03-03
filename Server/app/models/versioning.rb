class Versioning < ActiveRecord::Base

  has_paper_trail

  belongs_to :app

  validates :version, :build, :app_id, presence: true
end
