package flashwavrecorder {

  import flash.net.URLRequest;
  import flash.net.URLRequestMethod;
  import flash.utils.ByteArray;

  public class MultiPartFormUtil {
    public static function boundary():String {
      var str:String = "---------------------------";
      for(var i:int=0; i<25; i++) {
        str += Math.floor(Math.random()*10).toString();
      }
      return str;
    }

    public static function nameValuePair(name:String, value:Object):Object {
      var field:Object = new Object();
      field.name = name;
      field.value = value;
      return field;
    }

    public static function fileField(name:String, data:ByteArray, filename:String, type:String):Object {
      var field:Object = new Object();
      field.name = name;
      field.value = new Object();
      field.value.data = data;
      field.value.filename = filename;
      field.value.type = type;
      return field;
    }

    public static function request(data:Array):URLRequest {
      var request:URLRequest = new URLRequest();
      MultiPartFormUtil.setup(request, data);
      return request;
    }

    public static function setup(request:URLRequest, data:Array):void {
      var boundary:String = MultiPartFormUtil.boundary();
      request.method = URLRequestMethod.POST;
      request.contentType = "multipart/form-data; boundary=" + boundary;
      request.data = MultiPartFormUtil.requestData(data, boundary);
    }

    public static function requestData(data:Array, boundary:String):ByteArray {
      var newline:ByteArray = new ByteArray();
      newline.writeByte(13);
      newline.writeByte(10);

      var body:ByteArray = new ByteArray();

      for(var i:int=0; i<data.length; i++) {
        var field:Object = data[i];
        var name:String = field.name;

        body.writeUTFBytes("--" + boundary);
        body.writeBytes(newline);

        if(field.value.hasOwnProperty("data")) {
          if(field.value.hasOwnProperty('filename')) {
            body.writeUTFBytes("Content-Disposition: form-data; name=\"" + name + "\"; filename=\"" + field.value.filename + "\"");
          } else {
            body.writeUTFBytes("Content-Disposition: form-data; name=\"" + name + "\"");
          }
          body.writeBytes(newline);

          if(field.value.hasOwnProperty('type')) {
            body.writeUTFBytes("Content-Type: " + field.value.type);
            body.writeBytes(newline);
          }

          body.writeBytes(newline);
          body.writeBytes(field.value.data);
          body.writeBytes(newline);
        } else {
          body.writeUTFBytes("Content-Disposition: form-data; name=\"" + name + "\"");
          body.writeBytes(newline);

          body.writeBytes(newline);
          body.writeUTFBytes(field.value.toString());
          body.writeBytes(newline);
        }
      }

      body.writeUTFBytes("--" + boundary + "--");

      return body;
    }

    public static function requestDataAsString(data:Array, boundary:String):String {
      var body:String = "";

      for(var i:int=0; i<data.length; i++) {
        var field:Object = data[i];
        var name:String = field.name;

        body += "--" + boundary;
        body += "\r\n";

        if(field.value.hasOwnProperty("data")) {
          if(field.value.hasOwnProperty('filename')) {
            body += "Content-Disposition: form-data; name=\"" + name + "\"; filename=\"" + field.value.filename + "\"";
          } else {
            body += "Content-Disposition: form-data; name=\"" + name + "\"";
          }
          body += "\r\n";

          if(field.value.hasOwnProperty('type')) {
            body += "Content-Type: " + field.value.type;
            body += "\r\n";
          }

          body += "Content-Transfer-Encoding: base64";
	  body += "\r\n";

          body += "\r\n";
          body += MultiPartFormUtil.base64_encdode(field.value.data);
          body += "\r\n";
        } else {
          body += "Content-Disposition: form-data; name=\"" + name + "\"";
          body += "\r\n";

          body += "\r\n";
          body += field.value.toString();
          body += "\r\n";
        }
      }

      body += "--" + boundary + "--";

      return body;
    }

    public static function base64_encdode(data:ByteArray):String {
      var str:String = "";
      data.position = 0;
      while(data.bytesAvailable) {
        var n1:int = data.readByte();
        var n2:int = 0;
        var n3:int = 0;
        var padding:int = 0;

        if(data.bytesAvailable) {
          n2 = data.readByte();
        } else {
          padding = 2;
        }

        if(data.bytesAvailable) {
          n3 = data.readByte();
        } else {
          padding = 1;
        }

        var idx1:int = (n1 & 0xFC) >> 2;
        var idx2:int = ((n1 & 0x03) << 4) | ((n2 & 0xF0) >> 4);
        var idx3:int = ((n2 & 0x0F) << 2) | ((n3 & 0xC0) >> 6);
        var idx4:int = n3 & 0x3F;

        str += MultiPartFormUtil.base64_character(idx1) + MultiPartFormUtil.base64_character(idx2);
        if(padding == 0) {
          str += MultiPartFormUtil.base64_character(idx3) + MultiPartFormUtil.base64_character(idx4);
        } else if(padding == 1) {
          str += MultiPartFormUtil.base64_character(idx3) + "=";
        } else {
          str += "==";
        }
      }
      return str;
    }

    public static function base64_character(index:int):String {
      if(index >= 0 && index < 26) {
        return String.fromCharCode(65+index); // A-Z
      } else if(index >= 26 && index < 52) {
        return String.fromCharCode(97+index-26); // a-z
      } else if(index >= 52 && index < 62) {
        return String.fromCharCode(48+index-52); // 0-9
      } else if(index == 62) {
        return "+";
      } else if(index == 63) {
        return "/";
      }
      return "";
    }
  }
}
