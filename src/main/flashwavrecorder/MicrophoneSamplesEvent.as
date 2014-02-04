
package flashwavrecorder {
import flash.events.Event;

public class MicrophoneSamplesEvent extends Event {
  public static const RAW_SAMPLES_DATA:String = 'raw_samples_data';
  private var samples:Array;

  public function MicrophoneSamplesEvent(samples:Array) {
    super(RAW_SAMPLES_DATA);
    this.samples = samples;
  }

  public function getSamples():Array {
    return samples;
  }
}
}
