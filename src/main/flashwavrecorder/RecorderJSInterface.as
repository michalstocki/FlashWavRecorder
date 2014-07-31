package flashwavrecorder {

  import flash.display.DisplayObject;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.ProgressEvent;
  import flash.events.SecurityErrorEvent;
  import flash.external.ExternalInterface;
  import flash.media.Microphone;
  import flash.net.URLLoader;
  import flash.net.URLRequest;
  import flash.utils.ByteArray;

  import flashwavrecorder.events.MicrophoneLevelEvent;
  import flashwavrecorder.events.MicrophoneSamplesEvent;

  public class RecorderJSInterface {

    private static const READY:String = "ready";

    private static const NO_MICROPHONE_FOUND:String = "no_microphone_found";
    private static const MICROPHONE_USER_REQUEST:String = "microphone_user_request";
    private static const MICROPHONE_CONNECTED:String = "microphone_connected";
    private static const MICROPHONE_NOT_CONNECTED:String = "microphone_not_connected";
    private static const PERMISSION_PANEL_CLOSED:String = "permission_panel_closed";
    private static const MICROPHONE_ACTIVITY:String = "microphone_activity";
    private static const MICROPHONE_LEVEL:String = "microphone_level";
    private static const MICROPHONE_SAMPLES:String = "microphone_samples";

    private static const RECORDING:String = "recording";
    private static const RECORDING_STOPPED:String = "recording_stopped";

    private static const OBSERVING_LEVEL:String = "observing_level";
    private static const OBSERVING_LEVEL_STOPPED:String = "observing_level_stopped";

    private static const OBSERVING_SAMPLES:String = "observing_level";
    private static const OBSERVING_SAMPLES_STOPPED:String = "observing_level_stopped";

    private static const PLAYING:String = "playing";
    private static const STOPPED:String = "stopped"; // TODO: Rename to "playing_stopped"
    private static const PLAYING_PAUSED:String = "playing_paused";

    private static const SAVE_PRESSED:String = "save_pressed";
    private static const SAVING:String = "saving";
    private static const SAVED:String = "saved"; // TODO: Rename to "saving_succeeded" (?)
    private static const SAVE_FAILED:String = "save_failed"; // TODO: Rename to "saving_failed"
    private static const SAVE_PROGRESS:String = "save_progress"; // TODO: Rename to "saving_progress"

    private static const EVENT_HANDLER:String = "fwr_event_handler";

    public var saveButton:DisplayObject;
    
    private var _recorder:MicrophoneRecorder;
    private var _permissionPanel:MicrophonePermissionPanel;
    private var _uploadUrl:String;
    private var _uploadFormData:Array;
    private var _uploadFieldName:String;

    public function RecorderJSInterface(recorder:MicrophoneRecorder, permissionPanel:MicrophonePermissionPanel) {
      _recorder = recorder;
      _permissionPanel = permissionPanel;
      if(ExternalInterface.available && ExternalInterface.objectID) {
        ExternalInterface.addCallback("configure", configureMicrophone); // TODO: Rename to "configureMicrophone"
        ExternalInterface.addCallback("duration", getDuration); // TODO: Rename to "getDuration"
        ExternalInterface.addCallback("getBase64", getBase64);
        ExternalInterface.addCallback("getCurrentTime", getCurrentTime);
        ExternalInterface.addCallback("hide", hideButton); // TODO: Rename to "hideButton"
        ExternalInterface.addCallback("init", init);
        ExternalInterface.addCallback("isMicrophoneAccessible", isMicrophoneAccessible);
        ExternalInterface.addCallback("observeLevel", observeLevel);
        ExternalInterface.addCallback("observeSamples", observeSamples);
        ExternalInterface.addCallback("pausePlayBack", pausePlayback);
        ExternalInterface.addCallback("permit", requestMicrophoneAccess);
        ExternalInterface.addCallback("permitPermanently", requestPermanentMicrophoneAccess);
        ExternalInterface.addCallback("playBack", playback);
        ExternalInterface.addCallback("playBackFrom", playbackFrom);
        ExternalInterface.addCallback("record", record);
        ExternalInterface.addCallback("setLoopBack", setLoopBack);
        ExternalInterface.addCallback("setUseEchoSuppression", setUseEchoSuppression);
        ExternalInterface.addCallback("show", showButton); // TODO: Rename to "showButton"
        ExternalInterface.addCallback("stopObservingLevel", stopObservingLevel);
        ExternalInterface.addCallback("stopObservingSamples", stopObservingSamples);
        ExternalInterface.addCallback("stopPlayBack", stopPlayback);
        ExternalInterface.addCallback("stopRecording", stopRecording);
        ExternalInterface.addCallback("update", updateUploadForm); // TODO: Rename to "updateUploadForm"
      }
      _recorder.addEventListener(MicrophoneRecorder.SOUND_COMPLETE, playComplete);
      _recorder.addEventListener(MicrophoneRecorder.PLAYBACK_STARTED, playbackStarted);
      _recorder.addEventListener(MicrophoneRecorder.ACTIVITY, microphoneActivity);
      _recorder.levelForwarder.addEventListener(MicrophoneLevelEvent.LEVEL_VALUE, microphoneLevel);
      _recorder.samplesForwarder.addEventListener(MicrophoneSamplesEvent.RAW_SAMPLES_DATA, microphoneSamples);
      _permissionPanel.addEventListener(MicrophonePermissionPanel.PANEL_CLOSED, announcePanelClosed);
      _permissionPanel.addEventListener(MicrophonePermissionPanel.MICROPHONE_ALLOWED, announceMicrophoneConnected);
      _permissionPanel.addEventListener(MicrophonePermissionPanel.MICROPHONE_DENIED, announceMicrophoneNotConnected);
    }

    public function ready(width:int, height:int):void {
      ExternalInterface.call(EVENT_HANDLER, READY, width, height);
      if (isMicrophoneAccessible()) {
        announceMicrophoneConnected(new Event(MicrophonePermissionPanel.MICROPHONE_ALLOWED));
      }
    }

    private function init(url:String=null, fieldName:String=null, formData:Array=null):void {
      // TODO: Init with config object instead of list of args.
      _uploadUrl = url;
      _uploadFieldName = fieldName;
      updateUploadForm(formData);
    }

    private function microphoneActivity(event:Event):void {
      // TODO: Drop this function
      ExternalInterface.call(EVENT_HANDLER, MICROPHONE_ACTIVITY, _recorder.mic.getActivityLevel());
    }

//  Accessing microphone -----------------------------------------------------------------------------------------------

    private function isMicrophoneAccessible():Boolean {
      return isMicrophoneConnected() && !_recorder.mic.isMuted();
    }

    private function isMicrophoneConnected():Boolean {
      return Microphone.names.length > 0
    }

    private function announceMicrophoneInaccessibility():void {
      if (isMicrophoneConnected()) {
        ExternalInterface.call(EVENT_HANDLER, MICROPHONE_USER_REQUEST);
      } else {
        ExternalInterface.call(EVENT_HANDLER, NO_MICROPHONE_FOUND);
      }
    }

    private function requestMicrophoneAccess():void {
      _permissionPanel.showSimple();
    }

    private function requestPermanentMicrophoneAccess():void {
      _permissionPanel.showAdvanced();
    }

    private function announcePanelClosed(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, PERMISSION_PANEL_CLOSED);
    }

    private function announceMicrophoneConnected(event:Event):void {
      configureMicrophone();
      ExternalInterface.call(EVENT_HANDLER, MICROPHONE_CONNECTED);
    }

    private function announceMicrophoneNotConnected(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, MICROPHONE_NOT_CONNECTED);
    }

//  Configuring microphone ---------------------------------------------------------------------------------------------

    private function configureMicrophone(rate:int=22, gain:int=100, silenceLevel:Number=0, silenceTimeout:int=4000):void {
      // TODO: configure microphone with configuration object instead of list of args
      _recorder.mic.setRate(rate);
      _recorder.mic.setGain(gain);
      _recorder.mic.setSilenceLevel(silenceLevel, silenceTimeout);
    }

    private function setUseEchoSuppression(useEchoSuppression:Boolean):void {
      // TODO: move this under "configureMicrophone" method
      _recorder.mic.setUseEchoSuppression(useEchoSuppression);
    }

    private function setLoopBack(state:Boolean):void {
      // TODO: move this under "configureMicrophone" method
      _recorder.mic.setLoopBack(state);
    }

//  Recording and playing actions --------------------------------------------------------------------------------------

    private function record(name:String, filename:String=null):Boolean {
      if (isMicrophoneAccessible()) {
        stopRecording();
        _recorder.record(name, filename);
        ExternalInterface.call(EVENT_HANDLER, RECORDING, _recorder.currentSoundName);
        return _recorder.recording;
      } else {
        announceMicrophoneInaccessibility();
        return false;
      }
    }

    private function stopRecording():void {
      if(_recorder.recording) {
        _recorder.stop();
        ExternalInterface.call(EVENT_HANDLER, RECORDING_STOPPED, _recorder.currentSoundName, _recorder.duration());
      }
    }

    private function playback(name:String):Boolean {
      stopPlayback();
      _recorder.playBack(name);
      ExternalInterface.call(EVENT_HANDLER, PLAYING, _recorder.currentSoundName);
      return _recorder.playing;
    }

    private function playbackFrom(name:String, time:Number):Boolean {
      stopPlayback();
      _recorder.playBackFrom(name, time);
      if (_recorder.playing) {
        ExternalInterface.call(EVENT_HANDLER, PLAYING, _recorder.currentSoundName);
      }
      return _recorder.playing;
    }

    private function pausePlayback(name:String):void {
      if(_recorder.playing) {
        _recorder.pause(name);
        ExternalInterface.call(EVENT_HANDLER, PLAYING_PAUSED, _recorder.currentSoundName);
      }
    }

    private function stopPlayback():void {
      if(_recorder.playing) {
        _recorder.stop();
        ExternalInterface.call(EVENT_HANDLER, STOPPED, _recorder.currentSoundName);
      }
    }

    private function playbackStarted(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, MicrophoneRecorder.PLAYBACK_STARTED, _recorder.currentSoundName, _recorder.latency);
    }

    private function playComplete(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, STOPPED, _recorder.currentSoundName);
    }

//  Getting recording info ---------------------------------------------------------------------------------------------

    private function getDuration(name:String):Number {
      return _recorder.duration(name);
    }

    private function getCurrentTime(name:String):Number {
      return _recorder.getCurrentTime(name);
    }

    private function getBase64(name:String):Object {
      var data:ByteArray;
      try {
        data = _recorder.convertToWav(name);
      } catch (e:Error) {
        data = new ByteArray();
      }
      return MultiPartFormUtil.base64_encdode(data);
    }

//  Frequent events observing ------------------------------------------------------------------------------------------

    private function observeLevel():Boolean {
      var succeed:Boolean = enableEventObservation(_recorder.levelObserverAttacher);
      if (succeed) {
        ExternalInterface.call(EVENT_HANDLER, OBSERVING_LEVEL);
      }
      return succeed;
    }

    private function stopObservingLevel():Boolean {
      var succeed:Boolean = disableEventObservation(_recorder.levelObserverAttacher);
      if (succeed) {
        ExternalInterface.call(EVENT_HANDLER, OBSERVING_LEVEL_STOPPED);
      }
      return succeed;
    }

    private function observeSamples():Boolean {
      var succeed:Boolean = enableEventObservation(_recorder.samplesObserverAttacher);
      if (succeed) {
        ExternalInterface.call(EVENT_HANDLER, OBSERVING_SAMPLES);
      }
      return succeed;
    }

    private function stopObservingSamples():Boolean {
      var succeed:Boolean = disableEventObservation(_recorder.samplesObserverAttacher);
      if (succeed) {
        ExternalInterface.call(EVENT_HANDLER, OBSERVING_SAMPLES_STOPPED);
      }
      return succeed;
    }

    private function enableEventObservation(eventObserverAttacher:MicrophoneEventObserverAttacher):Boolean {
      if (isMicrophoneAccessible()) {
        if (!eventObserverAttacher.observing) {
          eventObserverAttacher.startObserving();
        }
        return eventObserverAttacher.observing;
      } else {
        announceMicrophoneInaccessibility();
        return false;
      }
    }

    private function disableEventObservation(eventObserverAttacher:MicrophoneEventObserverAttacher):Boolean {
      if (eventObserverAttacher.observing) {
        eventObserverAttacher.stopObserving();
      }
      return !eventObserverAttacher.observing;
    }


    private function microphoneLevel(event:MicrophoneLevelEvent):void {
      ExternalInterface.call(EVENT_HANDLER, MICROPHONE_LEVEL, event.levelValue);
    }

    private function microphoneSamples(event:MicrophoneSamplesEvent):void {
      ExternalInterface.call(EVENT_HANDLER, MICROPHONE_SAMPLES, event.samples);
    }

//  Saving recording ---------------------------------------------------------------------------------------------------

    private function showButton():void {
      if(saveButton) {
        saveButton.visible = true;
      }
    }

    private function hideButton():void {
      if(saveButton) {
        saveButton.visible = false;
      }
    }

    private function updateUploadForm(formData:Array=null):void {
      _uploadFormData = [];
      if(formData) {
        for(var i:int=0; i<formData.length; i++) {
          var data:Object = formData[i];
          _uploadFormData.push(MultiPartFormUtil.nameValuePair(data.name, data.value));
        }
      }
    }

    public function save():Boolean {
      ExternalInterface.call(EVENT_HANDLER, SAVE_PRESSED, _recorder.currentSoundName);
      try {
        sendForm(_recorder.currentSoundName, _recorder.currentSoundFilename);
        ExternalInterface.call(EVENT_HANDLER, SAVING, _recorder.currentSoundName);
      } catch(e:Error) {
        ExternalInterface.call(EVENT_HANDLER, SAVE_FAILED, _recorder.currentSoundName, e.message);
        return false;
      }
      return true;
    }

    private function sendForm(name:String, filename:String):void {

      MultiPartFormUtil.boundary();

      _uploadFormData.push(MultiPartFormUtil.fileField(_uploadFieldName, _recorder.convertToWav(name), filename, "audio/wav"));
      var request:URLRequest = MultiPartFormUtil.request(_uploadFormData);
      _uploadFormData.pop();

      request.url = _uploadUrl;

      var loader:URLLoader = new URLLoader();
      loader.addEventListener(Event.COMPLETE, onSaveComplete);
      loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
      loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onSecurityError);
      loader.addEventListener(ProgressEvent.PROGRESS, onProgress);
      loader.load(request);
    }

    private function onSaveComplete(event:Event):void {
      var loader:URLLoader = URLLoader(event.target);
      ExternalInterface.call(EVENT_HANDLER, SAVED, _recorder.currentSoundName, loader.data);
    }

    private function onIOError(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, SAVE_FAILED, _recorder.currentSoundName, IOErrorEvent(event).text);
    }

    private function onSecurityError(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, SAVE_FAILED, _recorder.currentSoundName, SecurityErrorEvent(event).text);
    }

    private function onProgress(event:Event):void {
      ExternalInterface.call(EVENT_HANDLER, SAVE_PROGRESS, _recorder.currentSoundName, ProgressEvent(event).bytesLoaded, ProgressEvent(event).bytesTotal);
    }
  }
}
