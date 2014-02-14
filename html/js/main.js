$(function() {
  var $uploadStatus = $('#upload_status'),
    $showLevelButton = $('.show_level'),
    $hideLevelButton = $('.hide_level'),
    $level = $('.control_panel .level');


  window.microphone_recorder_events = function microphone_recorder_events() {
    $('#status').text("Microphone recorder event: " + arguments[0]);
    var name, $controls;
    switch(arguments[0]) {
      case "ready":
        var width = parseInt(arguments[1]);
        var height = parseInt(arguments[2]);
        FWRecorder.uploadFormId = "#uploadForm";
        FWRecorder.uploadFieldName = "upload_file[filename]";
        FWRecorder.connect("recorderApp", 0);
        FWRecorder.recorderOriginalWidth = width;
        FWRecorder.recorderOriginalHeight = height;
        $('.save_button').css({'width': width, 'height': height});
        break;

      case "no_microphone_found":
        break;

      case "microphone_user_request":
        FWRecorder.showPermissionWindow();
        break;

      case "microphone_connected":
        var mic = arguments[1];
        FWRecorder.defaultSize();
        FWRecorder.isReady = true;
        if(configureMicrophone) {
          configureMicrophone();
        }
        $uploadStatus.css({'color': '#000'}).text("Microphone: " + mic.name);
        break;

      case "microphone_not_connected":
        FWRecorder.defaultSize();
        break;

      case "microphone_activity":
        $('#activity_level').text(arguments[1]);
        break;

      case "recording":
        name = arguments[1];
        $controls = controlsEl(name);
        FWRecorder.hide();
        $controls.find('.record_button img').attr('src', 'images/stop.png');
        $controls.find('.play_button').hide();
        break;

      case "recording_stopped":
        name = arguments[1];
        $controls = controlsEl(name);
        var duration = arguments[2];
        FWRecorder.show();
        $controls.find('.record_button img').attr('src', 'images/record.png');
        $('#duration').text(duration.toFixed(4) + " seconds");
        $controls.find('.play_button').show();
        break;

      case "microphone_level":
        $level.css({width: arguments[1] * 50 + '%'});
        break;

      case "observing_level":
        $showLevelButton.hide();
        $hideLevelButton.show();
        break;

      case "observing_level_stopped":
        $showLevelButton.show();
        $hideLevelButton.hide();
        $level.css({width: 0});
        break;

      case "playing":
        name = arguments[1];
        $controls = controlsEl(name);
        $controls.find('.record_button img').attr('src', 'images/record.png');
        $controls.find('.play_button img').attr('src', 'images/stop.png');
        $controls.find('.pause_button').show();
        break;

      case "playback_started":
        name = arguments[1];
        var latency = arguments[2];
        break;

      case "stopped":
        name = arguments[1];
        $controls = controlsEl(name);
        $controls.find('.record_button img').attr('src', 'images/record.png');
        $controls.find('.play_button img').attr('src', 'images/play.png');
        $controls.find('.pause_button').hide();
        break;

      case "save_pressed":
        FWRecorder.updateForm();
        break;

      case "saving":
        name = arguments[1];
        break;

      case "saved":
        name = arguments[1];
        var data = $.parseJSON(arguments[2]);
        if(data.saved) {
          $('#upload_status').css({'color': '#0F0'}).text(name + " was saved");
        } else {
          $('#upload_status').css({'color': '#F00'}).text(name + " was not saved");
        }
        break;

      case "save_failed":
        name = arguments[1];
        var errorMessage = arguments[2];
        $uploadStatus.css({'color': '#F00'}).text(name + " failed: " + errorMessage);
        break;

      case "save_progress":
        name = arguments[1];
        var bytesLoaded = arguments[2];
        var bytesTotal = arguments[3];
        $uploadStatus.css({'color': '#000'}).text(name + " progress: " + bytesLoaded + " / " + bytesTotal);
        break;
    }
  };

  function controlsEl(name) {
    return $('.control_panel.'+name);
  }
});
