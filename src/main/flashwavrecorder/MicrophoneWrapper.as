package flashwavrecorder {
import flash.media.Microphone;

public class MicrophoneWrapper {

    private var microphone:Microphone;

    public function MicrophoneWrapper() {
    }

    public function addEventListener(typeName:String, handler:Function):void {
      getMicrophone().addEventListener(typeName, handler);
    }

    public function removeEventListener(typeName:String, handler:Function):void {
      getMicrophone().removeEventListener(typeName, handler);
    }

    public function getRate():Number {
      return getMicrophone().rate;
    }

    public function setRate(rate:Number):void {
      getMicrophone().rate = rate;
    }

    public function setGain(gain:Number):void {
      getMicrophone().gain = gain;
    }

    public function getActivityLevel():Number {
      return getMicrophone().activityLevel;
    }

    public function isMuted():Boolean {
      return getMicrophone().muted;
    }

    public function setLoopBack(loopBack:Boolean):void {
      getMicrophone().setLoopBack(loopBack);
    }

    public function setSilenceLevel(silenceLevel:Number, silenceTimeout:int):void {
      getMicrophone().setSilenceLevel(silenceLevel, silenceTimeout);
    }

    public function setUseEchoSuppression(useEchoSuppression:Boolean):void {
      getMicrophone().setUseEchoSuppression(useEchoSuppression);
    }

    private function getMicrophone():Microphone {
      return microphone ||= Microphone.getMicrophone();
    }

  }
}