# NUEVO PRODUCTO
@newProduct = ->
  $("form.new_product").on "ajax:success", (event, data, status, xhr) ->
    $("form.new_product")[0].reset()
    $('form.new_product').closest('.modal').modal('hide')
    $('#error_explanation').hide()
    
    if $('#admin-products-container').length == 0
      # Estoy en la pantalla de productos principal
      $('#products .list').prepend(data)
      productsListEvents()
      initialize_modals()
    else
      $('#admin-products-container table tbody').html('');
      $.getScript('/admin/products');      
  
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

  initialize_modals();
    
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
  
  if $('#infinite-scrolling').size() > 0
    $(window).on 'scroll', ->
      more_products_url = $('.pagination a.next_page').attr('href')
      if more_products_url  && $(window).scrollTop() > $(document).height() - $(window).height() - 60
        $('.pagination').html('<div id="loading_products"> Cargando más productos... </div>')
        $.getScript more_products_url 
      return
    return
  
    