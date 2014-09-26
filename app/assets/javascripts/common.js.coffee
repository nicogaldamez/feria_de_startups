String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)
  
@show_alert = (text, type) ->
  content = '<button type="button" class="close" data-dismiss="alert"> '
  content += '<span aria-hidden="true">&times;</span>'
  content += '<span class="sr-only">Cerrar</span></button>' + text
  content = '<div class="alert-dismissible alert alert-'+type+'"> ' + content + '</div>'
  $('#alerts').html(content) 
  
@openModal = (size, url, title, options={})->  
  modal = "#" + size + '_modal'
  
  modalOptions = {}
  if options.closeDisabled
    modalOptions .keyboard = false
    modalOptions .backdrop = 'static'
    $(modal + " .close").hide()
  else
    $(modal + " .close").show()
  
  
  # load the url and show modal on success
  $(modal + " .modal-body").load url, ->
    $(modal + " .modal-title").html title
    $(modal).modal modalOptions
    return

# AGREGO HTTP AL VALOR INGRESADO EN UN INPUT TYPE URL    
@addHttp = (input) ->    
  string = input.value
  return false unless string != ''
  
  if (!(/^http:\/\//.test(string)) && (!(/^https:\/\//.test(string))))
      string = "http://" + string
  input.value = string

@initialize_modals = ->
  $("a[data-target=#modal]").click (ev) ->
    ev.preventDefault()
    target = $(this).attr("href")
  
    size = $(this).data('modalsize')
    title= $(this).data('modaltitle')
    
    options = {closedDisabled: $(this).data('closeDisabled')}  
    
    openModal(size, target, title, options)
    
    return
    
@initialize_tooltips = ->
  $("[data-toggle~=tooltip]").tooltip()
  
$ ()->
  
  initialize_modals()
  initialize_tooltips()