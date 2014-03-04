module VersioningsHelper

  def versioning_status(status)

    if status == 'WORKING'
      'success'
    elsif status == 'WARNING'
      'warning'
    elsif status == 'UPDATE'
      'danger'
    end

  end


end