package {
  import flash.events.Event;
  import flash.events.EventDispatcher;
  import flash.events.SampleDataEvent;
  import flash.events.TimerEvent;
  import flash.media.Microphone;
  import flash.media.Sound;
  import flash.media.SoundChannel;
  import flash.utils.ByteArray;
  import flash.utils.Dictionary;
  import flash.utils.Endian;
  import flash.utils.Timer;

  import mx.controls.Label;

  public class MicrophoneRecorder extends EventDispatcher {
    public static var SOUND_COMPLETE:String = "sound_complete";
    public static var PLAYBACK_STARTED:String = "playback_started";
    public static var RECORDING_STARTED:String = "recording_started";

    public var mic:Microphone;
    public var sound:Sound = new Sound();
    public var soundChannel:SoundChannel;
    public var sounds:Dictionary = new Dictionary();
    public var rates:Dictionary = new Dictionary();
    public var currentSoundName:String = "";
    public var currentSoundFilename:String = "";
    public var recording:Boolean = false;
    public var playing:Boolean = false;
    public var samplingStarted:Boolean = false;
    public var samplingStartTime:Date;
    public var latency:Number = 0;
    private var playTimer:Timer;

    public function MicrophoneRecorder() {
      this.mic = Microphone.getMicrophone();
    }

    public function reset():void {
      this.stop();
      this.sound = new Sound();
      this.sounds = new Dictionary();
      this.rates = new Dictionary();
      this.currentSoundName = "";
      this.recording = false;
      this.playing = false;
    }

    public function record(name:String, filename:String=""):void {
      this.stop();
      this.currentSoundName = name;
      this.currentSoundFilename = filename;
      var data:ByteArray = this.getSoundBytes(name, true);
      data.position = 0;
      this.rates[name] = mic.rate;
      this.samplingStarted = true;
      this.samplingStartTime = new Date();
      this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.recording = true;
    }

    public function play(name:String):void {
      this.stop();
      this.currentSoundName = name;
      var data:ByteArray = this.getSoundBytes();
      data.position = 0;
      this.samplingStarted = true;
      this.samplingStartTime = new Date();
      this.sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
      this.playing = true;
      this.soundChannel = this.sound.play();
    }

    public function stop():void {
      if(this.soundChannel) {
        this.soundChannel.stop();
        this.soundChannel = null;
      }

      if(this.playTimer) {
        this.playTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, playTimerCompleteHandler);
        this.playTimer.stop();
        this.playTimer = null;
      }

      if(this.playing) {
        this.sound.removeEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
        this.playing = false;
      }

      if(this.recording) {
        this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
        this.recording = false;
      }
    }

    private function playTimerCompleteHandler(event:Event):void {
      this.playing = false;
      dispatchEvent(new Event(MicrophoneRecorder.SOUND_COMPLETE));
      this.soundChannel = null;
    }

    public function getSoundBytes(name:String=null, create:Boolean=false):ByteArray {
      if(! name) {
        name = this.currentSoundName;
      }

      var data:ByteArray = ByteArray(this.sounds[name]);
      if(create) {
        if(data) {
          delete this.sounds[name];
        }
        data = new ByteArray();
        this.sounds[name] = data;
      }

      return data;
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
      if(this.samplingStarted) {
        this.samplingStarted = false;
        dispatchEvent(new Event(MicrophoneRecorder.RECORDING_STARTED));
      }

      var data:ByteArray = this.getSoundBytes();
      while(event.data.bytesAvailable) {
        data.writeFloat(event.data.readFloat());
      }
    }

    private function playbackSampleHandler(event:SampleDataEvent):void {
      if(this.samplingStarted && this.soundChannel) {
        this.samplingStarted = false;
	this.latency = (event.position / 44.1) - this.soundChannel.position;
        dispatchEvent(new Event(MicrophoneRecorder.PLAYBACK_STARTED));
	playTimer = new Timer(this.duration()*1000 + this.latency, 1);
	playTimer.addEventListener(TimerEvent.TIMER_COMPLETE, playTimerCompleteHandler);
	playTimer.start();
      }

      var data:ByteArray = this.getSoundBytes();
      var maxPlayback:int = 8192;
      var rate:int = this.rate();
      if(rate == 22) {
        maxPlayback = 4096;
      }
      for (var i:int = 0; i<maxPlayback && data.bytesAvailable && this.playing; i++) {
        var sample:Number = data.readFloat();
        event.data.writeFloat(sample);
        event.data.writeFloat(sample);
        if(rate == 22) {
          event.data.writeFloat(sample);
          event.data.writeFloat(sample);
        }
      }
    }

    public function duration(name:String=null):Number {
      if(! name) {
        name = this.currentSoundName;
      }
      var data:ByteArray = this.getSoundBytes(name);
      var frequency:int = MicrophoneRecorder.frequency(this.rates[name]);
      var numSamples:uint = data.length / 4;
      return Number(numSamples) / Number(frequency);
    }

    public function rate(name:String=null):int {
      if(! name) {
        name = this.currentSoundName;
      }
      return this.rates[name];
    }

    public function frequency(name:String=null):int {
      return MicrophoneRecorder.frequency(this.rate(name));
    }

    public static function frequency(rate:int):int {
      switch(rate) {
      case 44:
        return 44100;
      case 22:
        return 22050;
      case 11:
        return 11025;
      case 8:
        return 8000;
      case 5:
        return 5512;
      }
      return 0;
    }

    public function convertToWav(name:String):ByteArray {
      return MicrophoneRecorder.convertToWav(this.getSoundBytes(name), MicrophoneRecorder.frequency(this.rates[name]));
    }

    public static function convertToWav(soundBytes:ByteArray, sampleRate:int):ByteArray {
      var data:ByteArray = new ByteArray();
      data.endian = Endian.LITTLE_ENDIAN;

      var numBytes:uint = soundBytes.length / 2; // soundBytes are 32bit floats, we are storing 16bit integers
      var numChannels:int = 1;
      var bitsPerSample:int = 16;

      // The following is from https://ccrma.stanford.edu/courses/422/projects/WaveFormat/

      data.writeUTFBytes("RIFF"); // ChunkID
      data.writeUnsignedInt(36 + numBytes); // ChunkSize
      data.writeUTFBytes("WAVE"); // Format
      data.writeUTFBytes("fmt "); // Subchunk1ID
      data.writeUnsignedInt(16); // Subchunk1Size // 16 for PCM
      data.writeShort(1); // AudioFormat 1 Mono, 2 Stereo (Microphone is mono)
      data.writeShort(numChannels); // NumChannels
      data.writeUnsignedInt(sampleRate); // SampleRate
      data.writeUnsignedInt(sampleRate * numChannels * bitsPerSample/8); // ByteRate
      data.writeShort(numChannels * bitsPerSample/8); // BlockAlign
      data.writeShort(bitsPerSample); // BitsPerSample
      data.writeUTFBytes("data"); // Subchunk2ID
      data.writeUnsignedInt(numBytes); // Subchunk2Size

      soundBytes.position = 0;
      while(soundBytes.bytesAvailable > 0) {
        var sample:Number = soundBytes.readFloat(); // The sample is stored as a sine wave, -1 to 1
        var val:int = sample * 32768; // Convert to a 16bit integer
        data.writeShort(val);
      }

      return data;
    }
  }
}
