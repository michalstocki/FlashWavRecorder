package 
{	
	import flash.utils.ByteArray;

	import org.hamcrest.assertThat;
	import org.hamcrest.object.equalTo;
	import org.hamcrest.object.isFalse;
	import org.hamcrest.object.isTrue;
	import org.hamcrest.object.notNullValue;
	import org.hamcrest.object.nullValue;

	public class SampleCalculatorTest
	{		
		private var sampleCalculator:SampleCalculator;
		
		[Before]
		public function setUp():void
		{
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
	}
}