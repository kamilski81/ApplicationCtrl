module VersioningsHelper

  def versioning_status(versioning)
    if (not versioning.warning) && (not versioning.force_update)
      'success'
    elsif versioning.warning && (not versioning.force_update)
      'warning'
    elsif versioning.warning && versioning.force_update
      'danger'
    end
  end


end