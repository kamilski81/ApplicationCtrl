class AppType < ActiveRecord::Base
  validates :name, presence: true
  validates :identifier, presence: true
end
