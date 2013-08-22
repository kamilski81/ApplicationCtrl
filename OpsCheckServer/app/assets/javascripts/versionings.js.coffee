$(document).ready ->
  if $('textarea#content').length > 0
    CKEDITOR.replace('versioning[content]')