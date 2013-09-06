(($) ->

  initTableInteraction = ->
    if $('table.table-hover')
      $('table.table-hover tbody tr').on 'click', ->
        showLink = $(this).find('.show-link a')
        if showLink.length > 0
          href = showLink.attr('href')
          window.location.href = href

  init = ->
    initTableInteraction()

  $(init)
)(jQuery);