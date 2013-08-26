#(($) ->
#  initCkEditor = ->
#    CKEDITOR.replace('versioning[content]')
#
#  checkTextAreaAvailability = ->
#    $('textarea#content').length > 0
#
#  initEditPage = ->
#    if $('body.versionings-edit').length > 0
#      if checkTextAreaAvailability()
#        initCkEditor()
#
#  initListPage = ->
#    if $('body.versionings-index')
#      $('table.table-hover tbody tr').on 'click', ->
#        showLink = $(this).find('.show-link')
#        if showLink.length > 0
#          window.location = showLink
#
#  init = ->
#    if $('body.versionings')
#      initListPage()
#      initEditPage()
#      initListPage()
#
#  $(init)
#)(jQuery);
