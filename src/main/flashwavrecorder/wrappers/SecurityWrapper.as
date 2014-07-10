package flashwavrecorder.wrappers {

  import flash.system.Security;

  public class SecurityWrapper {
    public function SecurityWrapper() {
    }

    public function showSettings(panel:String):void {
      Security.showSettings(panel);
    }
  }
}
