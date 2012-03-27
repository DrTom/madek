###

  Media Resource Selection

  This script provides functionalities for working with selections of media resources 
  and setups interactivity for switching between multiple views for selected media resources (media and table)
 
###

jQuery ->
  $(".media_resource_selection_view_switch a").live "click", (event)->
    $(this).parent().find("a").removeClass("active")
    $(this).addClass("active")
    $(".media_resource_selection.switchable .active").removeClass("active")
    $($(this).data("switch_target")).addClass("active")

class MediaResourceSelection
  
  @setup = (options)->
  
window.MediaResourceSelection = MediaResourceSelection 