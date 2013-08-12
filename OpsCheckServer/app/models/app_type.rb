class AppType < ActiveRecord::Base
  validates :name, :identifier, presence: true
end
