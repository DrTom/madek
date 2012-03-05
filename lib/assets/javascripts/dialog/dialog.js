/*
 * Dialog
 *
 * This script setups the dialog jqueryui element with predefined settings
 * so you dont have to call all the options when you just open a dialog
 *
 * @name Dialog
 * @dependencies jQuery.UI (Dialog)
*/

var Dialog = new Dialog();

function Dialog() {
  
    this.followViewPortDelayTimer;
    this.followViewPortDelay = 115;
    this.followViewPortAnimationTime = 400;
    this.min_padding = 20;
    this.checkOnScroll = true;
  
    this.add = function(_params) {
        if(_params.trigger == undefined) _params.trigger = $("body");
        var _dialog = $(document.createElement("div")).addClass("dialog").html(_params.content);
        $("body").append(_dialog);
        $(_dialog).data("startLeft", ($(_params.trigger).offset().left + $(_params.trigger).width()/2));
        $(_dialog).data("startTop", ($(_params.trigger).offset().top + $(_params.trigger).height()/2));
        $(_dialog).data("callback", _params.callback);
        $(_dialog).data("trigger", _params.trigger);
        $(_dialog).data("padding", Dialog.default_padding);
        Dialog.setup(_dialog);
        _dialog.dialog(_params);
        return _dialog;
    }
    
    this.autofocus = function(dialog) {
      $(dialog).find(".focus").focus();
    }
    
    this.checkPosition = function() {
      clearTimeout(Dialog.followViewPortDelayTimer);
      Dialog.checkScale($(".dialog"));
      Dialog.setPosition();
    }
    
    this.setPosition = function() {
      Dialog.followViewPortDelayTimer = setTimeout(function() {
        var _top = $(".dialog").data("padding") + window.pageYOffset;
        if(_top < 0){_top = 1;}
        var _left = ( ( $(window).width()/2 ) - ( $(".ui-dialog ").width()/2 ) + window.pageXOffset );
        $(".ui-dialog").animate({
            top: _top,
            left: _left,
        }, {queue: false, duration: Dialog.followViewPortAnimationTime});
      }, Dialog.followViewPortDelay);
    }
    
    this.checkScale = function(dialog) {
      // prepare heights
      $(dialog).closest(".ui-dialog").css("height", "auto");
      $(dialog).data("total_height", $(dialog).outerHeight());
      $(dialog).data("total_scalable_height", $(dialog).find(".scalable").outerHeight());
      
      if($(window).height() < parseInt($(dialog).data("total_height") + Dialog.min_padding*2)) {
        // dialog is bigger than viewport
        $(dialog).data("padding", Dialog.min_padding);
        var _staticHeight = $(dialog).data("total_height") - $(dialog).data("total_scalable_height");
        var _newHeight = $(window).height() - $(dialog).data("padding")*2;
        var _scalableHeight = _newHeight - _staticHeight;
        $(dialog).find(".scalable").css("overflow-y", "scroll").height(_scalableHeight);
        $(dialog).parent().height(_newHeight);
        
        if($(window).height() < parseInt($(dialog).data("total_height") + Dialog.min_padding*2)) {
          // dialog is still not fitting inside viewport
          $(dialog).data("padding", parseInt(($(window).height()-$(dialog).data("total_height"))/4));
          $(dialog).parent().height($(dialog).data("total_height"));
          $(dialog).find(".scalable").height("auto").css("overflow-y", "auto");
          $(window).unbind("scroll", Dialog.checkPosition);
          Dialog.checkOnScroll = false;
        }
      } else {
        // dialog fits viewport
        $(dialog).data("padding", parseInt(($(window).height()-$(dialog).data("total_height"))/4));
        $(dialog).parent().height($(dialog).data("total_height"));
        $(dialog).find(".scalable").height("auto").css("overflow-y", "auto");
        
        // reset scroll binding
        if(!Dialog.checkOnScroll) {
          $(window).bind("scroll", Dialog.checkPosition);
          Dialog.checkOnScroll = true;
        }
      }
    }
    
    this.setup = function(_dialog) {
        $(_dialog).bind("dialogcreate", function(event, ui) {
            $(this).dialog("option", "modal", true);
            $(this).dialog("option", "draggable", false);
            $(this).dialog("option", "resizable", false);
            $(this).parent().css({opacity: 0});
            $(this).data("padding", Dialog.min_padding);
        });
        
        $(_dialog).bind("dialogopen", function(event, ui) {
          // bind scroll and resize
          $(window).bind("resize scroll", Dialog.checkPosition);
          
          // popup animation
          $(this).parent().offset({left: ( $(this).data("startLeft") - ( $(this).parent().width()/2 )), top: ( $(this).data("startTop") - $(this).parent().height()/2)});
          
          // check scale
          Dialog.checkScale($(this));
          
          // reset modal overlay height
          $(".ui-widget-overlay").height($(window).height());
          
          // animate
          var _top = $(this).data("padding") + window.pageYOffset;
          if(_top < 0){_top = 1;}
          var _left = ( ( $(window).width()/2 ) - ( $(this).parent().width()/2 ) + window.pageXOffset );
          $(this).parent().hide().fadeIn().animate({
              top: _top,
              left: _left,
              opacity: 1
          }, {
            queue: false,
            complete: function() {
              Dialog.autofocus(this);
              if($(".dialog #fullcalendar").length > 0) BookingCalendar.setup();
              
              // correct modal overlay height
              $(".ui-widget-overlay").height($(document).height());
            }
          });
        });
        
        $(_dialog).bind("dialogclose", function(event, ui) {
          // unbind scroll and resize
          $(window).unbind("resize scroll", Dialog.checkPosition);
          
          // call back
          if ($(this).data("callback")) $(this).data("callback").apply();
            
          // remove dialog on close
          $(this).remove();
        });
    }
    
}