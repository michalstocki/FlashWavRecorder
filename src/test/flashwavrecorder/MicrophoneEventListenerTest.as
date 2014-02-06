package flashwavrecorder {

  import flash.events.SampleDataEvent;

  import mockolate.received;
  import mockolate.runner.MockolateRule;

  import org.hamcrest.assertThat;
  import org.hamcrest.object.isFalse;
  import org.hamcrest.object.isTrue;

  public class MicrophoneEventListenerTest {

    [Rule]
    public var mockRule:MockolateRule = new MockolateRule();

    [Mock]
    public var microphone:MicrophoneWrapper;

    [Mock]
    public var microphoneLevelForwarder:MicrophoneLevelForwarder;

    private var microphoneEventListener:MicrophoneEventListener;

    [Before]
    public function setup():void {
      microphoneEventListener = new MicrophoneEventListener(microphone, microphoneLevelForwarder);
    }

    [Test]
    public function observation_checker_before_any_action_returns_false():void {
      // then
      assertThat(microphoneEventListener.isObserving(), isFalse());
    }

    [Test]
    public function observation_start_attaches_callback_on_microphone_sample():void {
      // when
      microphoneEventListener.startObserving();
      // then
      assertThat(microphone, received().method('addEventListener')
          .args(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler));
    }

    [Test]
    public function observation_checker_returns_true_after_observation_has_started():void {
      // when
      microphoneEventListener.startObserving();
      // then
      assertThat(microphoneEventListener.isObserving(), isTrue());
    }

    [Test]
    public function observation_stop_removes_callback_from_microphone_sample_event():void {
      // given
      microphoneEventListener.startObserving();
      // when
      microphoneEventListener.stopObserving();
      // then
      assertThat(microphone, received().method('removeEventListener')
          .args(SampleDataEvent.SAMPLE_DATA, microphoneLevelForwarder.micSampleDataHandler))
    }

    [Test]
    public function observation_checker_returns_false_after_observation_has_stopped():void {
      microphoneEventListener.startObserving();
      // when
      microphoneEventListener.stopObserving();
      // then
      assertThat(microphoneEventListener.isObserving(), isFalse());
    }

  }
}