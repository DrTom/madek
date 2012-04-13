###

  Create new Media Sets (with a thumb box)

  This script provides functionalities for creating a set with a thumb box
 
###

jQuery ->
  $(".thumb_box_set.create_new").live "click", (event)->
    return false if $(this).find(".loading").length
    $(this).find("form").show()
    $(this).find("input").focus()
  $(".thumb_box_set.create_new input").live "blur", (event)->
    _this = this
    window.setTimeout ()->
      $(_this).closest(".thumb_box_set").find("form").hide()
    , 100
  $(".thumb_box_set form").live "ajax:beforeSend", (event)->
    $(this).closest(".thumb_box_set").find(".icon").hide()
    $(this).closest(".thumb_box_set").find(".icon").after $.tmpl("tmpl/loading_img")
    $(this).hide()
  $(".thumb_box_set form").live "ajax:success", (event)->
    $(this).hide()
    window.location = window.location
