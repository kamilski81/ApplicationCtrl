(($) ->

  initIndexPage = ->
    if $('body.versionings-index')
      $('table.table-hover tbody tr').on 'click', ->
        showLink = $(this).find('.show-link a')
        if showLink.length > 0
          href = showLink.attr('href')
          window.location.href = href

  init = ->
    if $('body.apps')
      initIndexPage()

  $(init)
)(jQuery);