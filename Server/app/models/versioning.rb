class Versioning < ActiveRecord::Base

  has_paper_trail

  belongs_to :app

  validates :profile, :build, :app_id, presence: true

  validates :status, :inclusion => Settings.version_status_codes
end
