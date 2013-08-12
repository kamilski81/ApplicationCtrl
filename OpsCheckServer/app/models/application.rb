class Application < ActiveRecord::Base
  belongs_to :app_type
  belongs_to :user
  validates :name, :key, :identifier, :app_type_id, :user_id, presence: true
  has_many :versionings
end
