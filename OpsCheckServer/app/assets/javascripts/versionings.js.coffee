(($) ->
  initCkEditor = ->
    CKEDITOR.replace('versioning[content]')

  checkTextAreaAvailability = ->
    $('textarea#content').length > 0

  initEditPage = ->
    if $('body.versionings-edit').length > 0
      if checkTextAreaAvailability()
        initCkEditor()


  init = ->
    if $('body.versionings')
      initEditPage()

  $(init)
)(jQuery);
