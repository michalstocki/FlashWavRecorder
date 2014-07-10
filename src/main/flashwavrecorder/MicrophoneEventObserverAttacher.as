package flashwavrecorder {

  import flash.events.SampleDataEvent;

  import flashwavrecorder.wrappers.MicrophoneWrapper;

  public class MicrophoneEventObserverAttacher {

    private var _observing:Boolean = false;
    private var microphone:MicrophoneWrapper;
    private var microphoneEventForwarder:IMicrophoneEventForwarder;

    public function MicrophoneEventObserverAttacher(microphone:MicrophoneWrapper,
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