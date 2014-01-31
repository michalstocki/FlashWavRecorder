package flashwavrecorder {
import flash.events.Event;

public class MicrophoneLevelEvent extends Event {

  public static const LEVEL_VALUE:String = 'level_value';
  private var levelValue:Number;

  public function MicrophoneLevelEvent(levelValue:Number) {
    super(MicrophoneLevelEvent.LEVEL_VALUE);
    this.levelValue = levelValue;
  }

  public function getLevelValue():Number {
    return levelValue;
  }


}
}