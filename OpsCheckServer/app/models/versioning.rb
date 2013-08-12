class Versioning < ActiveRecord::Base
  belongs_to :app

  validates :version, :build, :status, :app_id, presence: true
end
