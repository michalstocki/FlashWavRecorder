package flashwavrecorder {

  import flash.events.Event;
  import flash.events.StatusEvent;
  import flash.system.SecurityPanel;

  import flashwavrecorder.wrappers.MicrophoneWrapper;
  import flashwavrecorder.wrappers.SecurityWrapper;

  import mockolate.mock;
  import mockolate.received;
  import mockolate.runner.MockolateRule;

  import org.flexunit.asserts.assertEquals;
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
    private var _callsCount:Number;

    [Before]
    public function setUp():void {
      mock(microphone).asEventDispatcher();
      mock(panelObserver).asEventDispatcher();
      _permissionPanel = new MicrophonePermissionPanel(microphone, panelObserver, security);
      _callsCount = 0;
    }

//  Simple Panel -------------------------------------------------------------------------------------------------------

    [Test]
    public function showsSimpleDialogByEnablingLoopBack():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      // when
      _permissionPanel.showSimple();
      // then
      assertThat(microphone, received().method('setLoopBack').args(true));
    }

    [Test]
    public function simplePanelStartsListeningPopupCloseEvent():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      // when
      _permissionPanel.showSimple();
      // then
      assertThat(panelObserver, received().method('startListeningPanelClose'));
    }

    [Test(async)]
    public function simplePanelAnnouncesMicrophoneAllowedOnStatusEventUnmuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var statusEvent:StatusEvent = getStatusEventUnmuted();
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.MICROPHONE_ALLOWED);
      // when
      _permissionPanel.showSimple();
      microphone.dispatchEvent(statusEvent);
    }

    [Test(async)]
    public function simplePanelDisablesLoopBackOnStatusEventUnmuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var statusEvent:StatusEvent = getStatusEventUnmuted();
      // when
      _permissionPanel.showSimple();
      microphone.dispatchEvent(statusEvent);
      // then
      assertThat(microphone, received().method('setLoopBack').args(false));
    }

    [Test]
    public function simplePanelListensForOnlyFirstStatusEventUnmuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var statusEvent:StatusEvent = getStatusEventUnmuted();
      _permissionPanel.addEventListener(MicrophonePermissionPanel.MICROPHONE_ALLOWED, onMicrophoneAllowed);
      // when
      _permissionPanel.showSimple();
      microphone.dispatchEvent(statusEvent);
      microphone.dispatchEvent(statusEvent);
      // then
      assertEquals(_callsCount, 1);
    }

    protected function onMicrophoneAllowed(event:Event):void {
      _callsCount++;
    }

    private function getStatusEventUnmuted():StatusEvent {
      return new StatusEvent(StatusEvent.STATUS, true, false, "Microphone.Unmuted");
    }

    [Test(async)]
    public function simplePanelAnnouncesPanelCloseOnPanelClosedEvent():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.PANEL_CLOSED);
      // when
      _permissionPanel.showSimple();
      panelObserver.dispatchEvent(event);
    }

    [Test]
    public function simplePanelStopsListeningPanelCloseOnPanelClosedEvent():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      // when
      _permissionPanel.showSimple();
      panelObserver.dispatchEvent(event);
      // then
      assertThat(panelObserver, received().method('stopListeningPanelClose'));
    }

    [Test(async)]
    public function simplePanelAnnouncesMicrophoneDeniedOnPanelClosedEventIfMicrophoneIsStillMuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.MICROPHONE_DENIED);
      // when
      _permissionPanel.showSimple();
      panelObserver.dispatchEvent(event);
    }

//  Advanced Panel -----------------------------------------------------------------------------------------------------

    [Test]
    public function advancedPanelShowsAdvancedSecurityDialog():void {
      // when
      _permissionPanel.showAdvanced();
      // then
      assertThat(security, received().method('showSettings').args(SecurityPanel.PRIVACY));
    }

    [Test]
    public function advancedPanelStartsListeningPopupCloseEvent():void {
      // when
      _permissionPanel.showAdvanced();
      // then
      assertThat(panelObserver, received().method('startListeningPanelClose'));
    }

    [Test(async)]
    public function advancedPanelAnnouncesMicrophoneAllowedOnStatusEventUnmuted():void {
      // given
      var statusEvent:StatusEvent = getStatusEventUnmuted();
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.MICROPHONE_ALLOWED);
      // when
      _permissionPanel.showAdvanced();
      microphone.dispatchEvent(statusEvent);
    }

    [Test]
    public function advancedPanelListensForOnlyFirstStatusEventUnmuted():void {
      // given
      var statusEvent:StatusEvent = getStatusEventUnmuted();
      _permissionPanel.addEventListener(MicrophonePermissionPanel.MICROPHONE_ALLOWED, onMicrophoneAllowed);
      // when
      _permissionPanel.showAdvanced();
      microphone.dispatchEvent(statusEvent);
      microphone.dispatchEvent(statusEvent);
      // then
      assertEquals(_callsCount, 1);
    }

    [Test(async)]
    public function advancedPanelAnnouncesPanelCloseOnPanelClosedEvent():void {
      // given
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.PANEL_CLOSED);
      // when
      _permissionPanel.showAdvanced();
      panelObserver.dispatchEvent(event);
    }

    [Test]
    public function advancedPanelStopsListeningPanelCloseOnPanelClosedEvent():void {
      // given
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      // when
      _permissionPanel.showAdvanced();
      panelObserver.dispatchEvent(event);
      // then
      assertThat(panelObserver, received().method('stopListeningPanelClose'));
    }

    [Test(async)]
    public function advancedPanelAnnouncesMicrophoneDeniedOnPanelClosedEventIfMicrophoneIsStillMuted():void {
      // given
      mock(microphone).method('isMuted').returns(true);
      var event:Event = new Event(SettingsPanelObserver.PANEL_CLOSED);
      Async.proceedOnEvent(this, _permissionPanel, MicrophonePermissionPanel.MICROPHONE_DENIED);
      // when
      _permissionPanel.showAdvanced();
      panelObserver.dispatchEvent(event);
    }

  }
}