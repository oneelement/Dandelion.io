# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

jQuery ->
  $('#select-all').click (event) -> 
    if(this.checked)
      $(':checkbox').each ->
        this.checked = true   
        
$(document).ready ->
  $('#account-info').click ->
    $('#account-info').toggleClass('view')
    $('#mail').removeClass('view')
