package flashwavrecorder.events {

  import flash.events.Event;

  public class MicrophoneLevelEvent extends Event {

    public static const LEVEL_VALUE:String = 'level_value';
    private var _levelValue:Number;

    public function MicrophoneLevelEvent(levelValue:Number) {
      super(MicrophoneLevelEvent.LEVEL_VALUE);
      this._levelValue = levelValue;
    }

    public function get levelValue():Number {
      return _levelValue;
    }

  }
}