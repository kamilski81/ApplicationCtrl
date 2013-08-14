class AppType < ActiveRecord::Base
  validates :name, presence: true
end
