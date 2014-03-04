module VersioningsHelper

  def versioning_status(status)
    if status == 0
      'success'
    elsif status == 1
      'warning'
    elsif status == 2
      'danger'
    end
  end
end