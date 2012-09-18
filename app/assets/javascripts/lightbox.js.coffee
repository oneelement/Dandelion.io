# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://jashkenas.github.com/coffee-script/

#LIGHTBOX JS CODE


$(document).ready ->
  $('.lightbox-backdrop').click ->
    $('.lightbox').removeClass('show')
    $('.lightbox').removeClass('map')
    $('.lightbox').removeClass('avatar')
    $('.lightbox').removeClass('settings')
    $('.lightbox').removeClass('social')
    $('.lightbox').css('display', 'none')
    $('.lightbox').html('')
    $('#merge-lightbox').css('display', 'none')
    $('#phone-lightbox-container').css('display', 'none')    
    $('#phone-lightbox-value').css('display', 'none')
    $('#phone-lightbox-value').html('')
    $('#phone-lightbox-value').css('font-size', '10px')
    $('.lightboxmap').removeClass('show')
    $('.lightboxmap').removeClass('map')
    $('.lightboxmap').css('display', 'none')
    $('.lightboxmap').html('<div id="expanded-map"></div>')
    $('.lightbox-backdrop').css('display', 'none')
    
  $('#flash-right .dicon-cancel').click ->
    $('#global-flashes').css('display', 'none')
    $('#flash-content').html('')
