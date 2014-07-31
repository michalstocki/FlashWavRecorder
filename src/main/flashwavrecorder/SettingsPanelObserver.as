package flashwavrecorder {

  import flash.display.BitmapData;
  import flash.display.Stage;
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.TimerEvent;
  import flash.utils.Timer;

  public class SettingsPanelObserver extends EventDispatcher {

    public static const PANEL_CLOSED:String = "panel_closed";
    private var _timer:Timer;
    private var _stage:Stage;
    private static const PANEL_VISIBILITY_CHECK_DELAY:Number = 100;

    public function SettingsPanelObserver(stage:Stage) {
      _stage = stage;
      _timer = new Timer(PANEL_VISIBILITY_CHECK_DELAY);
      _timer.addEventListener(TimerEvent.TIMER, checkPanelVisibility);
    }

    public function startListeningPanelClose():void {
      _timer.start();
    }

    public function stopListeningPanelClose():void {
      _timer.stop();
    }

    private function checkPanelVisibility(event:TimerEvent):void {
      if (isPanelClosed()) {
        dispatchEvent(new Event(PANEL_CLOSED));
      }
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
