package flashwavrecorder {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.StatusEvent;
  import flash.system.SecurityPanel;

  import flashwavrecorder.wrappers.MicrophoneWrapper;
  import flashwavrecorder.wrappers.SecurityWrapper;

  public class MicrophonePermissionPanel extends EventDispatcher {

    public static const PANEL_CLOSED:String = "panel_closed";
    public static const MICROPHONE_ALLOWED:String = "microphone_allowed";
    public static const MICROPHONE_DENIED:String = "microphone_denied";
    private var _microphone:MicrophoneWrapper;
    private var _panelObserver:SettingsPanelObserver;
    private var _security:SecurityWrapper;

    public function MicrophonePermissionPanel(microphone:MicrophoneWrapper, panelObserver:SettingsPanelObserver, security:SecurityWrapper) {
      _microphone = microphone;
      _panelObserver = panelObserver;
      _security = security;
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
      _security.showSettings(SecurityPanel.PRIVACY);
    }

    private function handleMicrophoneStatus(event:StatusEvent):void {
      if (event.code == "Microphone.Unmuted") {
        _microphone.setLoopBack(false);
        _microphone.removeEventListener(StatusEvent.STATUS, handleMicrophoneStatus);
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
