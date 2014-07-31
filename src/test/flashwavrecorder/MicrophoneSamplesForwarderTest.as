package flashwavrecorder {
import flash.events.SampleDataEvent;
import flash.utils.ByteArray;

import flashwavrecorder.events.MicrophoneSamplesEvent;

import org.flexunit.async.Async;
import org.hamcrest.assertThat;
import org.hamcrest.core.isA;
import org.hamcrest.object.equalTo;


public class MicrophoneSamplesForwarderTest {

  private var sampleDataEvent:SampleDataEvent;
  private var firstSample:Number = Number(0.1);
  private var secondSample:Number = Number(0.4);

  [Before]
  public function setup():void {
    sampleDataEvent = new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
    sampleDataEvent.data = new ByteArray();
    sampleDataEvent.data.writeFloat(firstSample);
    sampleDataEvent.data.writeFloat(secondSample);
    sampleDataEvent.data.writeFloat(Number(0.6));
  }

  [Test(async)]
  public function should_dispatch_raw_sample_data_event():void {
    // given
    var asyncHandler:Function = Async.asyncHandler(this, expectEventToBeDispatched, 500);
    var microphoneSamplesForwarder:MicrophoneSamplesForwarder = new MicrophoneSamplesForwarder();
    // when
    microphoneSamplesForwarder.addEventListener(MicrophoneSamplesEvent.RAW_SAMPLES_DATA, asyncHandler);
    microphoneSamplesForwarder.handleMicSampleData(sampleDataEvent);
  }

  private function expectEventToBeDispatched(event:MicrophoneSamplesEvent, object:Object):void {
    // then
    assertThat(event, isA(MicrophoneSamplesEvent));
  }

  [Test(async)]
  public function should_dispatch_raw_sample_data_event_with_samples_array():void {
    // given
    var asyncHandler:Function = Async.asyncHandler(this, expectEventToHaveProperData, 500);
    var microphoneSamplesForwarder:MicrophoneSamplesForwarder = new MicrophoneSamplesForwarder();
    // when
    microphoneSamplesForwarder.addEventListener(MicrophoneSamplesEvent.RAW_SAMPLES_DATA, asyncHandler);
    microphoneSamplesForwarder.handleMicSampleData(sampleDataEvent);
  }

  private function expectEventToHaveProperData(event:MicrophoneSamplesEvent, object:Object):void {
    // then
    assertThat(event.samples, isA(Array));
    assertThat(event.samples[0].toFixed(1), equalTo(firstSample));
    assertThat(event.samples[1].toFixed(1), equalTo(secondSample));
  }

}
}
