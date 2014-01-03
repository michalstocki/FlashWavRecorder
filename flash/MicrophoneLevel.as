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
    private var microphone:Microphone;

    public function MicrophoneLevel(microphone:Microphone) {
      this.microphone = microphone;
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
      dispatchLevelEvent(this.calculateLevel(event.data));
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