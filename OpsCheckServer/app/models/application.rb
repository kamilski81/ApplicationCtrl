class Application < ActiveRecord::Base
  belongs_to :app_type
  validates :app_type_id, presence: true
end
