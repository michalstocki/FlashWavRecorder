package flashwavrecorder.wrappers {

  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.media.Microphone;

  public class MicrophoneWrapper extends EventDispatcher {

    private var _microphone:Microphone;

    public function MicrophoneWrapper() {
      _microphone = Microphone.getMicrophone();
    }

    override public function addEventListener(typeName:String, handler:Function, useCapture:Boolean = false, priority:int = 0, useWeakReference:Boolean = false):void {
      _microphone.addEventListener.apply(this, arguments);
    }

    override public function removeEventListener(typeName:String, handler:Function, useCapture:Boolean=false):void {
      _microphone.removeEventListener.apply(this, arguments);
    }

    override public function dispatchEvent(event:Event):Boolean {
      return _microphone.dispatchEvent(event);
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

  }
}