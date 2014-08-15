String::capitalize = ->
  @charAt(0).toUpperCase() + @slice(1)
  
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
  
$ ()->
  
  # MIS DATOS
  $("a[data-target=#modal]").click (ev) ->
    ev.preventDefault()
    target = $(this).attr("href")
  
    size = $(this).data('modalsize')
    title= $(this).data('modaltitle')
    
    options = {closedDisabled: $(this).data('closeDisabled')}  
    
    openModal(size, target, title, options)
    
    return
  