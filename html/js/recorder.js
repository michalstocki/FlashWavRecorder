


function microphone_recorder_events()
{
  $('#status').text("Microphone recorder event: " + arguments[0]);
  var name, $controls;
  switch(arguments[0]) {
  case "ready":
    var width = parseInt(arguments[1]);
    var height = parseInt(arguments[2]);
    Recorder.uploadFormId = "#uploadForm";
    Recorder.uploadFieldName = "upload_file[filename]";
    Recorder.connect("recorderApp", 0);
    Recorder.recorderOriginalWidth = width;
    Recorder.recorderOriginalHeight = height;
    $('.save_button').css({'width': width, 'height': height});
  break;

  case "no_microphone_found":
    break;

  case "microphone_user_request":
    Recorder.showPermissionWindow();
    break;

  case "microphone_connected":
    var mic = arguments[1];
    Recorder.defaultSize();
    Recorder.isReady = true;
    if(configureMicrophone) {
      configureMicrophone();
    }
    $('#upload_status').css({'color': '#000'}).text("Microphone: " + mic.name);
    break;

  case "microphone_not_connected":
    Recorder.defaultSize();
    break;

  case "microphone_activity":
    $('#activity_level').text(arguments[1]);
    break;

  case "recording":
    name = arguments[1];
    $controls = controlsEl(name);
    Recorder.hide();
    $controls.find('.record_button img').attr('src', 'images/stop.png');
    $controls.find('.play_button').hide();
    break;

  case "recording_stopped":
    name = arguments[1];
    $controls = controlsEl(name);
    var duration = arguments[2];
    Recorder.show();
    $controls.find('.record_button img').attr('src', 'images/record.png');
    $('#duration').text(duration.toFixed(4) + " seconds");
    $controls.find('.play_button').show();
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
    Recorder.updateForm();
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
    $('#upload_status').css({'color': '#F00'}).text(name + " failed: " + errorMessage);
    break;

  case "save_progress":
    name = arguments[1];
    var bytesLoaded = arguments[2];
    var bytesTotal = arguments[3];
    $('#upload_status').css({'color': '#000'}).text(name + " progress: " + bytesLoaded + " / " + bytesTotal);
    break;
  }
}

function controlsEl(name) {
  return $('.control_panel.'+name);
}

(function() {
  window.Recorder = {
    recorder: null,
    recorderOriginalWidth: 0,
    recorderOriginalHeight: 0,
    uploadFormId: null,
    uploadFieldName: null,
    isReady: false,

    connect: function(name, attempts) {
      if(navigator.appName.indexOf("Microsoft") != -1) {
        Recorder.recorder = window[name];
      } else {
        Recorder.recorder = document[name];
      }

      if(attempts >= 40) {
        return;
      }

      // flash app needs time to load and initialize
      if(Recorder.recorder && Recorder.recorder.init) {
        Recorder.recorderOriginalWidth = Recorder.recorder.width;
        Recorder.recorderOriginalHeight = Recorder.recorder.height;
        if(Recorder.uploadFormId && $) {
          var frm = $(Recorder.uploadFormId); 
          Recorder.recorder.init(frm.attr('action').toString(), Recorder.uploadFieldName, frm.serializeArray());
        }
        return;
      }

      setTimeout(function() {Recorder.connect(name, attempts+1);}, 100);
    },

    playBack: function(name) {
      Recorder.recorder.playBack(name);
    },

    pausePlayBack: function(name) {
      Recorder.recorder.pausePlayBack(name);
    },
    
    playBackFrom: function(name, time) {
    	Recorder.recorder.playBackFrom(name, time);
    },

    record: function(name, filename) {
      Recorder.recorder.record(name, filename);
    },

    resize: function(width, height) {
      Recorder.recorder.width = width + "px";
      Recorder.recorder.height = height + "px";
    },

    defaultSize: function(width, height) {
      Recorder.resize(Recorder.recorderOriginalWidth, Recorder.recorderOriginalHeight);
    },

    show: function() {
      Recorder.recorder.show();
    },

    hide: function() {
      Recorder.recorder.hide();
    },

    duration: function(name) {
      return Recorder.recorder.duration(name || Recorder.uploadFieldName);
    },

    updateForm: function() {
      var frm = $(Recorder.uploadFormId); 
      Recorder.recorder.update(frm.serializeArray());
    },

    showPermissionWindow: function() {
      Recorder.resize(240, 160);
      // need to wait until app is resized before displaying permissions screen
      setTimeout(function(){Recorder.recorder.permit();}, 1);
    },

    configure: function(rate, gain, silenceLevel, silenceTimeout) {
      rate = parseInt(rate || 22);
      gain = parseInt(gain || 100);
      silenceLevel = parseInt(silenceLevel || 0);
      silenceTimeout = parseInt(silenceTimeout || 4000);
      switch(rate) {
      case 44:
      case 22:
      case 11:
      case 8:
      case 5:
        break;
      default:
        throw("invalid rate " + rate);
      }

      if(gain < 0 || gain > 100) {
        throw("invalid gain " + gain);
      }

      if(silenceLevel < 0 || silenceLevel > 100) {
        throw("invalid silenceLevel " + silenceLevel);
      }

      if(silenceTimeout < -1) {
        throw("invalid silenceTimeout " + silenceTimeout);
      }

      Recorder.recorder.configure(rate, gain, silenceLevel, silenceTimeout);
    },

    setUseEchoSuppression: function(val) {
      if(typeof(val) != 'boolean') {
        throw("invalid value for setting echo suppression, val: " + val);
      }

      Recorder.recorder.setUseEchoSuppression(val);
    },

    setLoopBack: function(val) {
      if(typeof(val) != 'boolean') {
        throw("invalid value for setting loop back, val: " + val);
      }

      Recorder.recorder.setLoopBack(val);
    }
  };
})();