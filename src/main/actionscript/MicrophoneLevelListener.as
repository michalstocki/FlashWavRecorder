package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.utils.ByteArray;

  import MicrophoneWrapper;
  import MicrophoneLevelEvent;
  import MicrophoneLevelForwarder;
  import SampleCalculator;

  public class MicrophoneLevelListener {

    private var observing:Boolean = false;
    private var microphone:MicrophoneWrapper;
    private var microphoneLevelForwarder:MicrophoneLevelForwarder;

    public function MicrophoneLevelListener(microphone:MicrophoneWrapper,
                                            microphoneLevelForwarder:MicrophoneLevelForwarder) {
      this.microphone = microphone;
      this.microphoneLevelForwarder = microphoneLevelForwarder;
    }

    public function startObserving():void {
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler);
      observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler);
      observing = false;
    }

    public function isObserving():Boolean {
      return observing;
    }

  }
}