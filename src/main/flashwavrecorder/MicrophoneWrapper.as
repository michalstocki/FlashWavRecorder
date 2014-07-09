package flashwavrecorder {

  import flash.events.ActivityEvent;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.events.StatusEvent;
  import flash.media.Microphone;

  public class MicrophoneWrapper extends EventDispatcher {

    private var _microphone:Microphone;

    public function MicrophoneWrapper() {
      _microphone = Microphone.getMicrophone();
      _microphone.addEventListener(SampleDataEvent.SAMPLE_DATA, forwardEvent);
      _microphone.addEventListener(ActivityEvent.ACTIVITY, forwardEvent);
      _microphone.addEventListener(StatusEvent.STATUS, forwardEvent);
    }

    public function getRate():Number {
      return _microphone.rate;
    }

    public function setRate(rate:Number):void {
      _microphone.rate = rate;
    }

    public function setGain(gain:Number):void {
      _microphone.gain = gain;
    }

    public function getActivityLevel():Number {
      return _microphone.activityLevel;
    }

    public function isMuted():Boolean {
      return _microphone.muted;
    }

    public function setLoopBack(loopBack:Boolean):void {

      _microphone.setLoopBack(loopBack);
    }

    public function setSilenceLevel(silenceLevel:Number, silenceTimeout:int):void {
      _microphone.setSilenceLevel(silenceLevel, silenceTimeout);
    }

    public function setUseEchoSuppression(useEchoSuppression:Boolean):void {
      _microphone.setUseEchoSuppression(useEchoSuppression);
    }

    private function forwardEvent(event:StatusEvent):void {
      dispatchEvent(event);
    }

  }
}