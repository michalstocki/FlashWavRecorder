package flashwavrecorder {

  import flash.events.Event;
  import flash.events.StatusEvent;

  import flashwavrecorder.wrappers.MicrophoneWrapper;
  import flashwavrecorder.wrappers.SecurityWrapper;

  import mockolate.mock;
  import mockolate.received;
  import mockolate.runner.MockolateRule;

  import org.flexunit.Assert;

  import org.flexunit.async.Async;
  import org.hamcrest.assertThat;

  public class MicrophonePermissionPanelTest {

    [Rule]
    public var mockRule:MockolateRule = new MockolateRule();

    [Mock]
    public var microphone:MicrophoneWrapper;
    [Mock]
    public var panelObserver:SettingsPanelObserver;
    [Mock]
    public var security:SecurityWrapper;

    private var _permissionPanel:MicrophonePermissionPanel;

    [Before]
    public function setUp():void {
      mock(microphone).asEventDispatcher();
      _permissionPanel = new MicrophonePermissionPanel(microphone, panelObserver, security);
    }

    [Test]
    public function showsSimpleDialogByEnablingLoopBack():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      // when
      _permissionPanel.showSimple();
      // then
      assertThat(microphone, received().method('setLoopBack').args(true));
    }

    [Test(async)]
    public function announcesMicrophoneAllowedOnStatusEventUnmuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var statusEvent:StatusEvent = new StatusEvent(StatusEvent.STATUS, true, false, "Microphone.Unmuted");
      _permissionPanel.showSimple();
      var asyncHandler:Function = Async.asyncHandler(this, onMicrophoneAllowed, 500, null, handleTimeout);
      // when
      _permissionPanel.addEventListener(MicrophonePermissionPanel.MICROPHONE_ALLOWED, asyncHandler, false, 0, true);
      microphone.dispatchEvent(statusEvent);
    }

    protected function onMicrophoneAllowed(event:Event):void {
    }

    protected function handleTimeout():void {
      Assert.fail("Timeout reached before event");
    }

  }
}