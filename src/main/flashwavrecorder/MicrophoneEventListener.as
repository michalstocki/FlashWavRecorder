package flashwavrecorder {
import flash.events.SampleDataEvent;

public class MicrophoneEventListener {

    private var observing:Boolean = false;
    private var microphone:MicrophoneWrapper;
    private var microphoneEventForwarder:IMicrophoneEventForwarder;

    public function MicrophoneEventListener(microphone:MicrophoneWrapper,
                                            microphoneEventForwarder:IMicrophoneEventForwarder) {
      this.microphone = microphone;
      this.microphoneEventForwarder = microphoneEventForwarder;
    }

    public function startObserving():void {
      microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneEventForwarder.micSampleDataHandler);
      observing = true;
    }

    public function stopObserving():void {
      microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneEventForwarder.micSampleDataHandler);
      observing = false;
    }

    public function isObserving():Boolean {
      return observing;
    }

  }
}