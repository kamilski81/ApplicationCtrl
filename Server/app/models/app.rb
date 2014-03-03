class App < ActiveRecord::Base

  has_paper_trail

  belongs_to :team
  has_many :versionings

  validates :name,
            :identifier,
            :key,
            :app_type,
            :url,
            :team,
            presence: true


  before_validation :set_app_key, :on => :create

  private

    def set_app_key
      self.key = Digest::HMAC.hexdigest(self.name + Time.now.to_s, self.team.name, Digest::SHA1)
    end

end
