package flashwavrecorder.events {

  import flash.events.Event;

  public class MicrophoneSamplesEvent extends Event {
    public static const RAW_SAMPLES_DATA:String = 'raw_samples_data';
    private var _samples:Array;

    public function MicrophoneSamplesEvent(samples:Array) {
      super(RAW_SAMPLES_DATA);
      this._samples = samples;
    }

    public function get samples():Array {
      return _samples;
    }
  }
}
