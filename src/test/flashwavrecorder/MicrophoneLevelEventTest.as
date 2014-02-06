package flashwavrecorder {

  import org.hamcrest.assertThat;
  import org.hamcrest.object.equalTo;

  public class MicrophoneLevelEventTest {
    private var microphoneLevelEvent:MicrophoneLevelEvent;

    [Test]
    public function should_have_type_property_equal_to_its_static_constant_property():void {
      // when
      microphoneLevelEvent = new MicrophoneLevelEvent(23);
      // then
      assertThat(microphoneLevelEvent.type, equalTo(MicrophoneLevelEvent.LEVEL_VALUE));
    }

    [Test]
    public function should_allow_getting_value_provided_while_initialization():void {
      // given
      var levelValue:Number = 23;
      // when
      microphoneLevelEvent = new MicrophoneLevelEvent(levelValue);
      // then
      assertThat( microphoneLevelEvent.levelValue, equalTo(levelValue));
    }

  }
}