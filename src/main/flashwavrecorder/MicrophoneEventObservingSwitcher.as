package flashwavrecorder {

  import flash.events.SampleDataEvent;

  public class MicrophoneEventObservingSwitcher {

    private var _observing:Boolean = false;
    private var microphone:MicrophoneWrapper;
    private var microphoneEventForwarder:IMicrophoneEventForwarder;

    public function MicrophoneEventObservingSwitcher(microphone:MicrophoneWrapper,
                                                     microphoneEventForwarder:IMicrophoneEventForwarder) {
      this.microphone = microphone;
      this.microphoneEventForwarder = microphoneEventForwarder;
    }

    public function startObserving():void {
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneEventForwarder.handleMicSampleData);
      _observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneEventForwarder.handleMicSampleData);
      _observing = false;
    }

    public function get observing():Boolean {
      return _observing;
    }

  }
}