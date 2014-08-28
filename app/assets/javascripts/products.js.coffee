# NUEVO PRODUCTO
@newProduct = ->
  $("form.new_product").on "ajax:success", (event, data, status, xhr) ->
    $("form.new_product")[0].reset()
    $('form.new_product').closest('.modal').modal('hide')
    $('#error_explanation').hide()
    $('#products .list').prepend(data)
    productsListEvents()

  $("form.new_product").on "ajax:error", (event, xhr, status, error) ->
    errors = jQuery.parseJSON(xhr.responseText)
    $('#error_explanation').empty()
    
    $('#error_explanation').append('<ul>')
    $.each errors, (field, error) ->
      $('#error_explanation').append('<li>' + error[0] + '</li>')
    $('#error_explanation').append('</ul>')
    $('#error_explanation').show()

@viewProductEvents = ->
  $('.popup_like').bind 'ajax:success', (event, data, status, xhr)->
    id = data.id
    votes = data.votes_count
    
    if $(event.target).html() == 'Me gusta'
      $(event.target).html('Ya te gusta')
    else
      $(event.target).html('Me gusta')
    
    # Actualizo la cantidad de votos
    $('#product_'+id+' .votes_count').html votes
    $('#popup_product_'+id+' .votes_count').html(votes + ' votos')   
    
# EVENTOS LISTADO DE PRODUCTOS
@productsListEvents = ->
  
  # ELIMINAR PRODUCTO
  $('[data-toggle="confirmation"]').confirmation
    btnOkLabel: "Si"
    btnCancelLabel: "No"
    dataMethod: 'delete'
  
  # ME GUSTA
  $('.like').bind 'ajax:success', (event, data, status, xhr)->
    id = data.id
    votes = data.votes_count
    $(event.target).toggleClass 'highlight'
    
    # Actualizo la cantidad de votos
    $('#product_'+id+' .votes_count').html votes
    $('#product_'+id+' .initial').addClass 'spin'
    setTimeout (->
      $('#product_'+id+' .initial').removeClass 'spin'
      return
    ), 100
  
  
    
    
# ON READY
$ ()->
  productsListEvents()
  
    