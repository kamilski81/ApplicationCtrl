class App < ActiveRecord::Base
  belongs_to :app_type
  belongs_to :user

  validates :name, :key, :identifier, :app_type_id, :user_id, presence: true
  has_many :versionings

  before_validation :set_app_key, :on => :create

  private
    def set_app_key
      self.key = Digest::HMAC.hexdigest(self.name + Time.now.to_s, self.user.email, Digest::SHA1)
    end

end
