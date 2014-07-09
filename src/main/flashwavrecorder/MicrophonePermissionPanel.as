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
    private var _panelObserver:SettingsPanelObserver;

    public function MicrophonePermissionPanel(microphone:MicrophoneWrapper, panelObserver:SettingsPanelObserver) {
      _microphone = microphone;
      _panelObserver = panelObserver;
      _panelObserver.addEventListener(SettingsPanelObserver.PANEL_CLOSED, handlePanelClosed);
    }

    public function showSimple():void {
      if (_microphone.isMuted()) {
        _panelObserver.startListeningPanelClose();
        _microphone.addEventListener(StatusEvent.STATUS, handleMicrophoneStatus);
        _microphone.setLoopBack(true);
      }
    }

    public function showAdvanced():void {
      _panelObserver.startListeningPanelClose();
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

    private function handlePanelClosed(event:Event):void {
      _panelObserver.stopListeningPanelClose();
      if (_microphone.isMuted()) {
        dispatchEvent(new Event(MICROPHONE_DENIED));
      }
      dispatchEvent(new Event(PANEL_CLOSED));
    }

  }


}
