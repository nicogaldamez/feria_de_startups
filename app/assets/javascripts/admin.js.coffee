@APP_ADMIN= {}
 
@APP_ADMIN.products = ->
  render: ->
    $(".publish_product_check").bind "change", ->
      $.ajax(
        url: "/admin/" + @value + "/toggle_published.json"
        type: "PUT"
        data:
          product:
            published: @checked
      ).fail((data) ->
        alert 'falló'
      ).done((data) ->
        show_alert('Actualizado', 'success')
      )
      return 