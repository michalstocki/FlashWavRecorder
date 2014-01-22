package {

import org.hamcrest.assertThat;
import org.hamcrest.object.equalTo;
import org.hamcrest.object.isFalse;
import org.hamcrest.object.isTrue;
import org.hamcrest.object.notNullValue;
import org.hamcrest.object.nullValue;
import org.mockito.MockitoTestCase;
import org.flexunit.async.Async;

import flash.events.SampleDataEvent;
import flash.utils.ByteArray;

import MicrophoneLevelForwarder;
import SampleCalculator;

public class MicrophoneLevelForwarderTest extends MockitoTestCase {

  private var microphoneLevelForwarder:MicrophoneLevelForwarder;
  private var sampleCalculator:SampleCalculator;
  private var sample:Number;

  public function MicrophoneLevelForwarderTest() {
    super([SampleCalculator]);
  }

  private function setup():void {
    sampleCalculator = mock(SampleCalculator) as SampleCalculator;
    microphoneLevelForwarder = new MicrophoneLevelForwarder(sampleCalculator);
  }

  public function test_microphone_sample_handler_calls_sample_calculator_for_level_value():void {
    // given
    setup();
    var sampleDataEvent:SampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
    var sampleData:ByteArray = new ByteArray();
    sampleDataEvent.data = sampleData;
    // when
    microphoneLevelForwarder.micSampleDataHandler(sampleDataEvent);
    // then
    verify().that(sampleCalculator.getHighestSample(sampleData));
  }


}
}