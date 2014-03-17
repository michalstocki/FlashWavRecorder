package flashwavrecorder.helpers {

  public class EventHandlerValidator {

    private static const REQUIREMENT:RegExp = /\A\w+\z/;

    public static function validate(eventHandler:String):Boolean {
      return REQUIREMENT.test(eventHandler);
    }
  }
}
