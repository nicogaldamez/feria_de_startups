# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ()->
  
  # ELIMINAR
  $('[data-toggle="confirmation"]').confirmation
    btnOkLabel: "Si"
    btnCancelLabel: "No"
    dataMethod: 'delete'
  
  # NUEVO PRODUCTO
  $("form.new_product").on "ajax:success", (event, data, status, xhr) ->
    $("form.new_product")[0].reset()
    $('#newproduct_modal').modal('hide')
    $('#error_explanation').hide()

  $("form.new_product").on "ajax:error", (event, xhr, status, error) ->
    errors = jQuery.parseJSON(xhr.responseText)
    $('#error_explanation').empty()
    
    $('#error_explanation').append('<ul>')
    $.each errors, (field, error) ->
      $('#error_explanation').append('<li>' + field.capitalize() + ' ' + error[0] + '</li>')
    $('#error_explanation').append('</ul>')
    $('#error_explanation').show()
    
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
    