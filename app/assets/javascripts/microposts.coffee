# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/
$ ->
  MICROPOST_CONTENT_MAXIMUM = 140
  count = $('span#micropost_form_input_count')
  count.text("文字数：" + $('textarea#micropost_content').val().length.toString() + " / " + MICROPOST_CONTENT_MAXIMUM.toString())

  recalc = (textarea) ->
    count.text("文字数：" + textarea.val().length.toString() + " / " + MICROPOST_CONTENT_MAXIMUM.toString())

  $('textarea#micropost_content').keyup ->
    recalc($(this))
