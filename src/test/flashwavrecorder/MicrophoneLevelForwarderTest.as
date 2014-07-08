package flashwavrecorder {

  import flash.events.SampleDataEvent;
  import flash.utils.ByteArray;

  import flashwavrecorder.events.MicrophoneLevelEvent;

  import mockolate.mock;
  import mockolate.runner.MockolateRule;

  import org.flexunit.assertThat;
  import org.flexunit.async.Async;
  import org.hamcrest.object.equalTo;

  public class MicrophoneLevelForwarderTest {

    [Rule]
    public var mockRule:MockolateRule = new MockolateRule();

    [Mock]
    public var sampleCalculator:SampleCalculator;

    private var testObj:MicrophoneLevelForwarder;
    private const LEVEL:Number = 1;

    [Before]
    public function setUp():void {
      testObj = new MicrophoneLevelForwarder(sampleCalculator);
    }

    [Test(async)]
    public function shouldDispatchLevelEventWithHandle():void {
      // given
      var data:ByteArray = new ByteArray();
      var sampleDataEvent:SampleDataEvent =  new SampleDataEvent(SampleDataEvent.SAMPLE_DATA);
      sampleDataEvent.data = data;

      mock(sampleCalculator).method('getHighestSample').args(data).returns(LEVEL);

      // expect
      Async.handleEvent(this, testObj, MicrophoneLevelEvent.LEVEL_VALUE, onLevelEvent);

      // when
      testObj.handleMicSampleData(sampleDataEvent);
    }

    private function onLevelEvent(event:MicrophoneLevelEvent, data:Object):void {
      assertThat(event.levelValue, equalTo(LEVEL));
    }
  }
}