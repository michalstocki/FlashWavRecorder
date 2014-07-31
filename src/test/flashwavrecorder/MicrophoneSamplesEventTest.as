package flashwavrecorder {

import flashwavrecorder.events.MicrophoneSamplesEvent;

import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;

public class MicrophoneSamplesEventTest {

  [Test]
  public function should_have_static_constant_property_in_type_of_string():void {
    // then
    assertThat(MicrophoneSamplesEvent.RAW_SAMPLES_DATA, isA(String));
  }

  [Test]
  public function should_have_public_type_property_equal_to_its_static_constant():void {
    // when
    var microphoneSamplesEvent:MicrophoneSamplesEvent = new MicrophoneSamplesEvent([]);
    // then
    assertThat(microphoneSamplesEvent.type, equalTo(MicrophoneSamplesEvent.RAW_SAMPLES_DATA));
  }

  [Test]
  public function should_allow_getting_samples_array_provided_while_initialization():void {
    // given
    var samples:Array = new Array(0.1, 0.2, 0.3);
    // when
    var microphoneSamplesEvent:MicrophoneSamplesEvent = new MicrophoneSamplesEvent(samples);
    // then
    assertThat(microphoneSamplesEvent.samples, equalTo(samples));
  }
}
}
