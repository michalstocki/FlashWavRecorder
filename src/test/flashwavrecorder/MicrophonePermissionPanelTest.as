package flashwavrecorder {

  import flash.events.Event;
  import flash.events.StatusEvent;

  import mockolate.mock;
  import mockolate.received;
  import mockolate.runner.MockolateRule;

  import mx.logging.Log;

  import org.flexunit.asserts.assertTrue;

  import org.flexunit.async.Async;

  import org.hamcrest.assertThat;

  public class MicrophonePermissionPanelTest {

    [Rule]
    public var mockRule:MockolateRule = new MockolateRule();

    [Mock]
    public var microphone:MicrophoneWrapper;
    [Mock]
    public var panelObserver:SettingsPanelObserver;

    private var _permissionPanel:MicrophonePermissionPanel;

    [Before]
    public function setUp():void {
      mock(microphone).asEventDispatcher();
      _permissionPanel = new MicrophonePermissionPanel(microphone, panelObserver);
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
      // expect
      Async.handleEvent(this, _permissionPanel, MicrophonePermissionPanel.MICROPHONE_ALLOWED, onMicrophoneAllowed);
      // when
      microphone.dispatchEvent(statusEvent);
    }

    protected function onMicrophoneAllowed(event:Event):void {
    }

  }
}