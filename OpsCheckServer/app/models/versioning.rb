class Versioning < ActiveRecord::Base
  belongs_to :app

  validates :version, :build, :app_id, presence: true
end
