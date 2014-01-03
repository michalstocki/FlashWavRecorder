package {

  import flash.utils.ByteArray;

  public class SampleCalculator {

    public function getHighestSample(data:ByteArray):Number {
      var level:Number = 0;
      var currentSample:Number;
      data.position = 0;
      while (data.bytesAvailable) {
        currentSample = data.readFloat();
        if (currentSample > level) {
          level = currentSample;
        }
      }
      data.position = 0;
      return level;
    }


  }

}