package flashwavrecorder {

  import flash.events.SampleDataEvent;

  public class MicrophoneLevelObservingSwitcher {

    private var _observing:Boolean = false;
    private var microphone:MicrophoneWrapper;
    private var microphoneLevelForwarder:MicrophoneLevelForwarder;

    public function MicrophoneLevelObservingSwitcher(microphone:MicrophoneWrapper,
                                                     microphoneLevelForwarder:MicrophoneLevelForwarder) {
      this.microphone = microphone;
      this.microphoneLevelForwarder = microphoneLevelForwarder;
    }

    public function startObserving():void {
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.handleMicSampleData);
      _observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.handleMicSampleData);
      _observing = false;
    }

    public function get observing():Boolean {
      return _observing;
    }

  }
}