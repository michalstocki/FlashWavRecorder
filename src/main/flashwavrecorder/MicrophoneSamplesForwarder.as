package flashwavrecorder {

  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.utils.ByteArray;

  import flashwavrecorder.events.MicrophoneSamplesEvent;

  public class MicrophoneSamplesForwarder extends EventDispatcher implements IMicrophoneEventForwarder {
    public function MicrophoneSamplesForwarder() {
    }

    public function handleMicSampleData(event:SampleDataEvent):void {
      var outputSamples:Array = readFloatsFromBytes(event.data);
      dispatchEvent(new MicrophoneSamplesEvent(outputSamples));
    }

    private function readFloatsFromBytes(bytes:ByteArray):Array {
      var floats:Array = [];
      bytes.position = 0;
      while (bytes.bytesAvailable > 0) {
        floats.push(bytes.readFloat());
      }
      return floats;
    }
  }
}
