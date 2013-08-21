class App < ActiveRecord::Base
  belongs_to :user

  validates :name, :identifier, :key, :app_type, :url, :user_id, presence: true
  has_many :versionings

  before_validation :set_app_key, :on => :create

  private
    def set_app_key
      self.key = Digest::HMAC.hexdigest(self.name + Time.now.to_s, self.user.email, Digest::SHA1)
    end

end
