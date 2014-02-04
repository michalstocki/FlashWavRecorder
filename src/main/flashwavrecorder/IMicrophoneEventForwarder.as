package flashwavrecorder {
import flash.events.SampleDataEvent;

  public interface IMicrophoneEventForwarder {

    function micSampleDataHandler(event:SampleDataEvent):void;

  }
}
