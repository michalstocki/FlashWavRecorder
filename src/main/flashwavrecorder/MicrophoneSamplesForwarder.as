package flashwavrecorder {
import flash.events.EventDispatcher;
import flash.events.SampleDataEvent;
import flash.utils.ByteArray;

public class MicrophoneSamplesForwarder extends EventDispatcher implements IMicrophoneEventForwarder {
  public function MicrophoneSamplesForwarder() {
  }

  public function micSampleDataHandler(event:SampleDataEvent):void {
    var inputSamples:ByteArray = event.data;
    inputSamples.position = 0;
    var outputSamples:Array = [];
    while (inputSamples.bytesAvailable) {
      outputSamples.push(inputSamples.readFloat());
    }
    dispatchSamplesEvent(outputSamples);
  }

  private function dispatchSamplesEvent(samples:Array):void {
    dispatchEvent(new MicrophoneSamplesEvent(samples));
  }
}
}
