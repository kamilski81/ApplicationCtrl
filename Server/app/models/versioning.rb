class Versioning < ActiveRecord::Base

  @@status_codes

  has_paper_trail

  belongs_to :app

  validates :profile, :build, :app_id, presence: true

  validate :validate_status_code

  def validate_status_code
    @@status_codes ||= Settings.version_status.map { |status| status.code }
    errors.add(:base, "Status code needs to be one of the following values [0, 1, 2]") unless @@status_codes.include?(self.status)
  end

  Settings.version_status.each do |version_status|
    method_name = version_status.label.downcase
    define_method("#{method_name}?") {
      status == method_name
    }
  end


end
