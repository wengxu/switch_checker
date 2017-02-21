# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

#clearInterval(my_interval)

$(document).on 'turbolinks:load', -> 
  check_btn_element = $('.check-btn').first()
  waiting = false
  update_label = -> 
    check_btn_element = document.getElementsByClassName('check-btn')[0]
    label = check_btn_element.innerHTML
    if waiting
      console.log waiting
      if label == 'check'
        check_btn_element.innerHTML = 'checking.  '
      else if label == 'checking...'
        check_btn_element.innerHTML = 'checking.  '
      else if label == 'checking.. '
        check_btn_element.innerHTML = 'checking...'
      else
        check_btn_element.innerHTML = 'checking.. '
    else 
      check_btn_element.innerHTML = 'check'
  console.log check_btn_element
  my_interval = setInterval update_label, 1000 

  mark_aval_values = -> 
    aval_values = $('.aval-value')
    mark_aval_value = (index) -> 
      $(this).html 'unknown'
      return
    aval_values.each(mark_aval_value)
    return

  populate_aval_values = (responseText) -> 
    status_obj = JSON.parse responseText
    console.log('populate_aval_values is called')
    console.log('responseText is ' + responseText)
    console.log('status_obj is ' + status_obj)
    for key, value of status_obj
      aval_value = $('#' + key + '-aval-value')
      aval_value.html value.toString() 
      window.mye = aval_value 
  
  get_status_url = window.location.origin + '/check/get_status'
  get_status = -> 
    xhttp = new XMLHttpRequest()
    xhttp.onreadystatechange = -> 
      if (this.readyState == 4 && this.status == 200) 
        console.log 'response received'
        console.log this.responseText
        waiting = false
        mark_aval_values()
        populate_aval_values this.responseText
        return
      else if this.status != 200
        alert 'error processing'
    xhttp.open("GET", get_status_url, true);
    xhttp.send(); 
  
  

  check_btn_element.on 'click', (event) -> 
    event.preventDefault()
    waiting = true
    get_status()
    mark_aval_values
    return
