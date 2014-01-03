package {
import flash.events.Event;

public class MicrophoneLevelEvent extends Event {

  public static const NAME:String = 'microphone_level';
  private var levelValue:Number;

  public function MicrophoneLevelEvent(levelValue:Number) {
    super(MicrophoneLevelEvent.NAME);
    this.levelValue = levelValue;
  }

  public function getLevelValue():Number {
    return levelValue;
  }


}
}