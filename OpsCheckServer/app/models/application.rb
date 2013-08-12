class Application < ActiveRecord::Base
  belongs_to :app_type
  validates :name, :key, :app_type_id, :user_id, presence: true
end
