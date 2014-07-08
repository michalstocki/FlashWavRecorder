package flashwavrecorder {

  import flash.display.BitmapData;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.StatusEvent;
  import flash.events.TimerEvent;
  import flash.system.Security;
  import flash.system.SecurityPanel;
  import flash.utils.Timer;

  public class MicrophonePermissionPanel extends EventDispatcher {

    public static const PANEL_CLOSED:String = "panel_closed";
    public static const MICROPHONE_ALLOWED:String = "microphone_allowed";
    public static const MICROPHONE_DENIED:String = "microphone_denied";
    private var _microphone:MicrophoneWrapper;
    private var _timer:Timer;
    private var _stage:Stage;
    private static const PANEL_VISIBILITY_CHECK_DELAY:Number = 100;

    public function MicrophonePermissionPanel(microphone:MicrophoneWrapper, stage:Stage) {
      _microphone = microphone;
      _stage = stage;
      _timer = new Timer(PANEL_VISIBILITY_CHECK_DELAY);
      _timer.addEventListener(TimerEvent.TIMER, checkPanelVisibility);
    }

    public function showSimple():void {
      if (_microphone.isMuted()) {
        listenPanelClose();
        _microphone.addEventListener(StatusEvent.STATUS, handleMicrophoneStatus);
        _microphone.setLoopBack(true);
      }
    }

    public function showAdvanced():void {
      listenPanelClose();
      _microphone.addEventListener(StatusEvent.STATUS, handleMicrophoneStatus);
      Security.showSettings(SecurityPanel.PRIVACY);
    }

    private function handleMicrophoneStatus(event:StatusEvent):void {
      _microphone.setLoopBack(false);
      _microphone.removeEventListener(StatusEvent.STATUS, handleMicrophoneStatus);
      if (event.code == "Microphone.Unmuted") {
        dispatchEvent(new Event(MICROPHONE_ALLOWED));
      }
    }

    private function listenPanelClose():void {
      _timer.start();
    }

    private function checkPanelVisibility(event:TimerEvent):void {
      if (isPanelClosed()) {
        stopListeningPanelClose();
        if (_microphone.isMuted()) {
          dispatchEvent(new Event(MICROPHONE_DENIED));
        }
        dispatchEvent(new Event(PANEL_CLOSED));
      }
    }

    private function stopListeningPanelClose():void {
      _timer.stop();
    }

    private function isPanelClosed():Boolean {
      var closed:Boolean = true;
      var dummy:BitmapData;
      dummy = new BitmapData(1, 1);

      try {
        // Try to capture the stage: triggers a Security error when the settings dialog box is open
        dummy.draw(_stage);
      } catch (error:Error) {
        closed = false;
      }

      dummy.dispose();
      return closed;
    }

  }


}
