package flashwavrecorder {

  import flash.utils.ByteArray;

  import org.hamcrest.assertThat;
  import org.hamcrest.object.equalTo;

  public class SampleCalculatorTest {

    private var sampleCalculator:SampleCalculator;

    [Before]
    public function setUp():void {
      sampleCalculator = new SampleCalculator();
    }

    [Test]
    public function should_empty_buffer_give_zero_level():void {
      // given
      var emptyBuffer:ByteArray = new ByteArray();

      // when
      var level:Number = sampleCalculator.getHighestSample(emptyBuffer);

      // then
      assertThat( level, equalTo(0) );
    }

    [Test]
    public function should_give_highest_value_from_buffer_of_floats():void {
      // given
      var highestFloat:Number = 0.8;
      var floatBuffer:ByteArray = new ByteArray();
      floatBuffer.writeFloat(0);
      floatBuffer.writeFloat(0.1);
      floatBuffer.writeFloat(highestFloat);
      floatBuffer.writeFloat(0.6);

      // when
      var level:Number = sampleCalculator.getHighestSample(floatBuffer);

      // then
      assertThat( level.toFixed(3), equalTo(highestFloat));
    }

    [Test]
    public function should_give_highest_value_from_buffer_which_position_has_been_changed():void {
      // given
      var highestFloat:Number = 0.7;
      var floatBuffer:ByteArray = new ByteArray();
      floatBuffer.writeFloat(highestFloat);
      floatBuffer.writeFloat(0);
      floatBuffer.writeFloat(0.1);
      floatBuffer.writeFloat(0.6);

      // when
      floatBuffer.position = 2;
      var level:Number = sampleCalculator.getHighestSample(floatBuffer);

      // then
      assertThat( level.toFixed(3), equalTo(highestFloat));
    }


    [Test]
    public function should_leave_buffer_with_position_set_to_zero():void {
      // given
      var floatBuffer:ByteArray = new ByteArray();
      floatBuffer.writeFloat(0);
      floatBuffer.writeFloat(0.1);
      floatBuffer.writeFloat(0.6);

      // when
      var level:Number = sampleCalculator.getHighestSample(floatBuffer);

      // then
      assertThat( floatBuffer.position, equalTo(0));
    }
  }
}