package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.media.Microphone;
  import flash.utils.ByteArray;

  import MicrophoneLevelEvent;

  import mx.controls.Label;

  public class MicrophoneLevel extends EventDispatcher {

    private var observing:Boolean = false;
    private var mic:Microphone;

    public function MicrophoneLevel(microphone:Microphone) {
      this.mic = microphone;
    }

    public function startObserving():void {
      this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.observing = true;
    }

    public function stopObserving():void {
      this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.observing = false;
    }

    public function isObserving():Boolean {
      return observing;
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
      this.dispatchLevelEvent(this.calculateLevel(event.data));
    }

    private function calculateLevel(data:ByteArray):Number {
      var level:Number = 0;
      var currentSample:Number;
      while (data.bytesAvailable) {
        currentSample = data.readFloat();
        if (currentSample > level) {
          level = currentSample;
        }
      }
      data.position = 0;
      return level;
    }

    private function dispatchLevelEvent(level:Number):void {
      dispatchEvent(new MicrophoneLevelEvent(level));
    }

  }
}