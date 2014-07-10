package flashwavrecorder.wrappers {

  import flash.media.Microphone;

  public class MicrophoneWrapper {

    private var microphone:Microphone;

    public function MicrophoneWrapper() {
      microphone = Microphone.getMicrophone();
    }

    public function addEventListener(typeName:String, handler:Function):void {
      microphone.addEventListener(typeName, handler);
    }

    public function removeEventListener(typeName:String, handler:Function):void {
      microphone.removeEventListener(typeName, handler);
    }

    public function getRate():Number {
      return microphone.rate;
    }

    public function setRate(rate:Number):void {
      microphone.rate = rate;
    }

    public function setGain(gain:Number):void {
      microphone.gain = gain;
    }

    public function getActivityLevel():Number {
      return microphone.activityLevel;
    }

    public function isMuted():Boolean {
      return microphone.muted;
    }

    public function setLoopBack(loopBack:Boolean):void {
      microphone.setLoopBack(loopBack);
    }

    public function setSilenceLevel(silenceLevel:Number, silenceTimeout:int):void {
      microphone.setSilenceLevel(silenceLevel, silenceTimeout);
    }

    public function setUseEchoSuppression(useEchoSuppression:Boolean):void {
      microphone.setUseEchoSuppression(useEchoSuppression);
    }

  }
}