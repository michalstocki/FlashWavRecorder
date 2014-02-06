package flashwavrecorder {

  import flash.events.SampleDataEvent;

  import mockolate.received;
  import mockolate.runner.MockolateRule;

  import org.hamcrest.assertThat;
  import org.hamcrest.object.isFalse;
  import org.hamcrest.object.isTrue;

  public class MicrophoneLevelListenerTest {

    [Rule]
    public var mockRule:MockolateRule = new MockolateRule();

    [Mock]
    public var microphone:MicrophoneWrapper;

    [Mock]
    public var microphoneLevelForwarder:MicrophoneLevelForwarder;

    private var microphoneLevelListener:MicrophoneLevelListener;

    [Before]
    public function setup():void {
      microphoneLevelListener = new MicrophoneLevelListener(microphone, microphoneLevelForwarder);
    }

    [Test]
    public function observation_checker_before_any_action_returns_false():void {
      // then
      assertThat(microphoneLevelListener.isObserving(), isFalse());
    }

    [Test]
    public function observation_start_attaches_callback_on_microphone_sample():void {
      // when
      microphoneLevelListener.startObserving();
      // then
      assertThat(microphone, received().method('addEventListener')
          .args(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler));
    }

    [Test]
    public function observation_checker_returns_true_after_observation_has_started():void {
      // when
      microphoneLevelListener.startObserving();
      // then
      assertThat(microphoneLevelListener.isObserving(), isTrue());
    }

    [Test]
    public function observation_stop_removes_callback_from_microphone_sample_event():void {
      // given
      microphoneLevelListener.startObserving();
      // when
      microphoneLevelListener.stopObserving();
      // then
      assertThat(microphone, received().method('removeEventListener')
          .args(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler))
    }

    [Test]
    public function observation_checker_returns_false_after_observation_has_stopped():void {
      microphoneLevelListener.startObserving();
      // when
      microphoneLevelListener.stopObserving();
      // then
      assertThat(microphoneLevelListener.isObserving(), isFalse());
    }

  }
}