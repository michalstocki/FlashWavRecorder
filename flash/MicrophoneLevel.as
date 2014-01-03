package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.media.Microphone;
  import flash.utils.ByteArray;

  import MicrophoneLevelEvent;
  import SampleCalculator;

  import mx.controls.Label;

  public class MicrophoneLevel extends EventDispatcher {

    private var observing:Boolean = false;
    private var microphone:Microphone;
    private var sampleCalculator:SampleCalculator;

    public function MicrophoneLevel(microphone:Microphone, sampleCalculator:SampleCalculator) {
      this.microphone = microphone;
      this.sampleCalculator = sampleCalculator;
    }

    public function startObserving():void {
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      observing = false;
    }

    public function isObserving():Boolean {
      return observing;
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
      dispatchLevelEvent(calculateLevel(event.data));
    }

    private function calculateLevel(data:ByteArray):Number {
      return sampleCalculator.getHighestSample(data);
    }

    private function dispatchLevelEvent(level:Number):void {
      dispatchEvent(new MicrophoneLevelEvent(level));
    }

  }
}