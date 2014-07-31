package flashwavrecorder {

  import flash.display.InteractiveObject;
  import flash.display.Loader;
  import flash.display.Sprite;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.MouseEvent;
  import flash.net.URLRequest;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextElement;
  import flash.text.engine.TextLine;

  import flashwavrecorder.wrappers.SecurityWrapper;

  public class Recorder extends Sprite {

    private var _recorderInterface:RecorderJSInterface;
    private var _saveButton:InteractiveObject;

    public function Recorder() {
      stage.align = StageAlign.TOP_LEFT;
      stage.scaleMode = StageScaleMode.NO_SCALE;
      var microphoneRecorder:MicrophoneRecorder = new MicrophoneRecorder();
      var panelObserver:SettingsPanelObserver = new SettingsPanelObserver(stage);
      var security:SecurityWrapper = new SecurityWrapper();
      var permissionPanel:MicrophonePermissionPanel = new MicrophonePermissionPanel(microphoneRecorder.mic,
          panelObserver, security);
      _recorderInterface = new RecorderJSInterface(microphoneRecorder, permissionPanel);

      var url:String = root.loaderInfo.parameters["upload_image"];
      if (url) {
        _saveButton = createSaveImage(url);
      } else {
        _saveButton = createSaveLink();
        ready();
      }
    }

    private function ready():void {
      addChild(_saveButton);

      _recorderInterface.saveButton = _saveButton;

      _saveButton.addEventListener(MouseEvent.MOUSE_UP, mouseReleased);
      _saveButton.visible = false;

      _recorderInterface.ready(_saveButton.width, _saveButton.height);
    }

    private function mouseReleased(event:MouseEvent):void {
      _recorderInterface.save();
    }

    private function createSaveLink():Sprite {
      var format:ElementFormat = new ElementFormat();
      var fontColor:Number = 0x0000EE;
      if (root.loaderInfo.parameters["font_color"]) {
        fontColor = parseInt(root.loaderInfo.parameters["font_color"], 16);
      }
      var fontSize:Number = 12;
      if (root.loaderInfo.parameters["font_size"]) {
        fontSize = parseInt(root.loaderInfo.parameters["font_size"], 10);
      }
      format.color = fontColor;
      format.fontSize = fontSize;
      var textBlock:TextBlock = new TextBlock();
      var saveText:String = "Save";
      if (root.loaderInfo.parameters["save_text"]) {
        saveText = root.loaderInfo.parameters["save_text"];
      }
      textBlock.content = new TextElement(saveText, format);
      var textLine:TextLine = textBlock.createTextLine();

      var saveLink:Sprite = new Sprite();

      saveLink.buttonMode = true;
      saveLink.addChild(textLine);
      textLine.y = textLine.ascent;

      if (root.loaderInfo.parameters["background_color"]) {
        saveLink.graphics.beginFill(parseInt(root.loaderInfo.parameters["background_color"], 16));
        saveLink.graphics.drawRect(0, 0, saveLink.width, saveLink.height);
      }

      saveLink.graphics.lineStyle(1, fontColor);
      saveLink.graphics.moveTo(0, textLine.height - 1);
      saveLink.graphics.lineTo(saveLink.width, textLine.height - 1);

      return saveLink;
    }

    private function createSaveImage(url:String):Sprite {
      var image:Sprite = new Sprite();
      var loader:Loader = new Loader();
      loader.contentLoaderInfo.addEventListener(Event.COMPLETE, imageCompleteHandler);
      loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, imageIoErrorHandler);
      loader.load(new URLRequest(url));
      image.addChild(loader);
      image.buttonMode = true;
      return image;
    }

    private function imageCompleteHandler(event:Event):void {
      ready();
    }

    private function imageIoErrorHandler(event:Event):void {
      _saveButton = createSaveLink();
      ready();
    }
  }

}
