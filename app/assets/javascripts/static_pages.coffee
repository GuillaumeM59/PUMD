# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

messageCallback = ->
    $(".message").animate
      height: 0
      opacity: 0
    , 350
    , ->
      $(this).remove()

$ ->
    $(".message").bind 'click', (ev) =>
        messageCallback()
    setTimeout messageCallback, 6000
