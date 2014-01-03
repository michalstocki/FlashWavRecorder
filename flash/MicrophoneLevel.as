package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.media.Microphone;
  import flash.utils.ByteArray;

  import MicrophoneLevelEvent;

  import mx.controls.Label;

  public class MicrophoneLevel extends EventDispatcher {

    public var isObserving:Boolean = false;
    private var mic:Microphone;

    public function MicrophoneLevel(microphone:Microphone) {
      this.mic = microphone;
    }

    public function startObserving():void {
      this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.isObserving = true;
    }

    public function stopObserving():void {
      this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.isObserving = false;
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
      var data:ByteArray = new ByteArray();
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