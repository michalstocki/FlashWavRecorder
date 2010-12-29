package {
  import flash.display.InteractiveObject;
  import flash.display.Loader;
  import flash.display.StageAlign;
  import flash.display.StageScaleMode;
  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.IOErrorEvent;
  import flash.events.MouseEvent;
  import flash.external.ExternalInterface;
  import flash.net.URLRequest;
  import flash.text.engine.ElementFormat;
  import flash.text.engine.TextBlock;
  import flash.text.engine.TextElement;
  import flash.text.engine.TextLine;

  import RecorderJSInterface;

  public class Recorder extends Sprite {

    public var recorderInterface:RecorderJSInterface;
    public var saveButton:InteractiveObject;

    public function Recorder() {
      this.stage.align = StageAlign.TOP_LEFT;
      this.stage.scaleMode = StageScaleMode.NO_SCALE;
      recorderInterface = new RecorderJSInterface();

      if(this.root.loaderInfo.parameters["event_handler"]) {
	recorderInterface.eventHandler = this.root.loaderInfo.parameters["event_handler"];
      }

      var url:String = this.root.loaderInfo.parameters["upload_image"];
      if(url) {
        saveButton = createSaveImage(url);
      } else {
        saveButton = createSaveLink();
        ready();
      }
    }

    public function ready():void {
      addChild(saveButton);

      recorderInterface.saveButton = saveButton;

      saveButton.addEventListener(MouseEvent.MOUSE_UP, mouseReleased);
      saveButton.visible = false;

      recorderInterface.ready(saveButton.width, saveButton.height);
    }

    public function save():void {
      recorderInterface.save();
    }

    private function mouseReleased(event:MouseEvent):void {
      save();
    }

    private function createSaveLink():Sprite {
      var format:ElementFormat = new ElementFormat();
      var fontColor:Number = 0x0000EE;
      if(this.root.loaderInfo.parameters["font_color"]) {
        fontColor = parseInt(this.root.loaderInfo.parameters["font_color"], 16);
      }
      var fontSize:Number = 12;
      if(this.root.loaderInfo.parameters["font_size"]) {
        fontSize = parseInt(this.root.loaderInfo.parameters["font_size"], 10);
      }
      format.color = fontColor;
      format.fontSize = fontSize;
      var textBlock:TextBlock = new TextBlock();
      var saveText:String = "Save";
      if(this.root.loaderInfo.parameters["save_text"]) {
        saveText = this.root.loaderInfo.parameters["save_text"];
      }
      textBlock.content = new TextElement(saveText, format);
      var textLine:TextLine = textBlock.createTextLine();

      var saveLink:Sprite = new Sprite();

      saveLink.buttonMode = true;
      saveLink.addChild(textLine);
      textLine.y = textLine.ascent;

      if(this.root.loaderInfo.parameters["background_color"]) {
        saveLink.graphics.beginFill(parseInt(this.root.loaderInfo.parameters["background_color"], 16));
        saveLink.graphics.drawRect(0, 0, saveLink.width, saveLink.height);
      }

      saveLink.graphics.lineStyle(1, fontColor);
      saveLink.graphics.moveTo(0, textLine.height-1);
      saveLink.graphics.lineTo(saveLink.width, textLine.height-1);

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
      saveButton = createSaveLink();
      ready();
    }
  }

}
