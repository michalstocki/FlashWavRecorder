package flashwavrecorder {

import flash.events.SampleDataEvent;
import flash.utils.ByteArray;

import org.mockito.MockitoTestCase;

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