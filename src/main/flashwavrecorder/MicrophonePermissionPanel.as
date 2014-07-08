package flashwavrecorder {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.StatusEvent;
  import flash.system.Security;
  import flash.system.SecurityPanel;

  public class MicrophonePermissionPanel extends EventDispatcher {

    public static const PANEL_CLOSED:String = "panel_closed";
    public static const MICROPHONE_ALLOWED:String = "microphone_allowed";
    public static const MICROPHONE_DENIED:String = "microphone_denied";
    private var _microphone:MicrophoneWrapper;

    public function MicrophonePermissionPanel(microphone:MicrophoneWrapper) {
      _microphone = microphone;
    }

    public function showSimple():void {
      if (_microphone.isMuted()) {
        _microphone.addEventListener(StatusEvent.STATUS, handleSimpleUserDecision);
        _microphone.setLoopBack(true);
      }
    }

    public function showAdvanced():void {
      _microphone.addEventListener(StatusEvent.STATUS, handleSimpleUserDecision);
      Security.showSettings(SecurityPanel.PRIVACY);
    }

    private function handleSimpleUserDecision(event:StatusEvent):void {
      _microphone.setLoopBack(false);
      _microphone.removeEventListener(StatusEvent.STATUS, handleSimpleUserDecision);
      announceUserDecision(event);
    }

    private function announceUserDecision(event:StatusEvent):void {
      if (event.code == "Microphone.Unmuted") {
        dispatchEvent(new Event(MICROPHONE_ALLOWED));
      }
    }

  }


}
