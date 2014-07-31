package flashwavrecorder {

  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.utils.ByteArray;

  import flashwavrecorder.events.MicrophoneLevelEvent;

  public class MicrophoneLevelForwarder extends EventDispatcher implements IMicrophoneEventForwarder {

    private var _sampleCalculator:SampleCalculator;

    public function MicrophoneLevelForwarder(sampleCalculator:SampleCalculator) {
      _sampleCalculator = sampleCalculator;
    }

    public function handleMicSampleData(event:SampleDataEvent):void {
      var levelValue:Number = _sampleCalculator.getHighestSample(ByteArray(event.data));
      dispatchEvent(new MicrophoneLevelEvent(levelValue));
    }

  }
}