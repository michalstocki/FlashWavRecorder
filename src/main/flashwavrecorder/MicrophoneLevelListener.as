package flashwavrecorder {

  import flash.events.SampleDataEvent;

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
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.handleMicSampleData);
      observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.handleMicSampleData);
      observing = false;
    }

    public function isObserving():Boolean {
      return observing;
    }

  }
}