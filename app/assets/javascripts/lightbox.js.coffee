# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#LIGHTBOX JS CODE


$(document).ready ->
  $('.lightbox-backdrop').click ->
    $('.lightbox').removeClass('show')
    $('.lightbox').removeClass('map')
    $('.lightbox').css('display', 'none')
    $('.lightbox-backdrop').css('display', 'none')
