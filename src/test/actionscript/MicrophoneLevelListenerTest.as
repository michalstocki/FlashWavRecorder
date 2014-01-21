package {

  import flash.utils.ByteArray;
  import flash.events.SampleDataEvent;

  import org.hamcrest.assertThat;
  import org.hamcrest.object.equalTo;
  import org.hamcrest.object.isFalse;
  import org.hamcrest.object.isTrue;
  import org.hamcrest.object.notNullValue;
  import org.hamcrest.object.nullValue;
  import org.mockito.MockitoTestCase;

  import MicrophoneWrapper;
  import MicrophoneLevelListener;
  import MicrophoneLevelForwarder;

  public class MicrophoneLevelListenerTest extends MockitoTestCase {

    private var microphone:MicrophoneWrapper;
    private var microphoneLevelListener:MicrophoneLevelListener;
    private var microphoneLevelForwarder:MicrophoneLevelForwarder;

    public function MicrophoneLevelListenerTest() {
      super([MicrophoneWrapper, MicrophoneLevelForwarder])
    }

    private function setup():void {
      microphone = mock(MicrophoneWrapper, "microphone wrapper", [null]) as MicrophoneWrapper;
      microphoneLevelForwarder = mock(MicrophoneLevelForwarder, "level forwarder", [null]) as MicrophoneLevelForwarder;
      microphoneLevelListener = new MicrophoneLevelListener(microphone, microphoneLevelForwarder);
    }

    public function test_observation_checker_before_any_action_returns_false():void {
      // given
      setup();
      // then
      assertThat(microphoneLevelListener.isObserving(), isFalse());
    }

    public function test_observation_start_attaches_callback_on_microphone_sample():void {
      // given
      setup();
      // when
      microphoneLevelListener.startObserving();
      // then
      verify().that(microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler));
    }

    public function test_observation_checker_returns_true_after_observation_has_started():void {
      // given
      setup();
      // when
      microphoneLevelListener.startObserving();
      // then
      assertThat(microphoneLevelListener.isObserving(), isTrue());
    }

    public function test_observation_stop_removes_callback_from_microphone_sample_event():void {
      // given
      setup();
      microphoneLevelListener.startObserving();
      // when
      microphoneLevelListener.stopObserving();
      // then
      verify().that(microphone.removeEventListener(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler));
    }

    public function test_observation_checker_returns_false_after_observation_has_stopped():void {
      // given
      setup();
      microphoneLevelListener.startObserving();
      // when
      microphoneLevelListener.stopObserving();
      // then
      assertThat(microphoneLevelListener.isObserving(), isFalse());
    }

  }
}