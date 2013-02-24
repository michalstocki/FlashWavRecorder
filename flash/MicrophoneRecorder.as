package {
  import flash.events.Event;
  import flash.events.ActivityEvent;
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
    public static var ACTIVITY:String = "activity";

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
    public var latency:Number = 0;
    private var resampledBytes:ByteArray = new ByteArray();

    public function MicrophoneRecorder() {
      this.mic = Microphone.getMicrophone();
      this.sound.addEventListener(SampleDataEvent.SAMPLE_DATA, playbackSampleHandler);
    }

    public function reset():void {
      this.stop();
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
      this.mic.addEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
      this.mic.addEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
      this.recording = true;
    }

    public function playBack(name:String):void {
      this.stop();
      this.currentSoundName = name;
      this.getSoundBytesResampled(true);
      this.samplingStarted = true;
      this.playing = true;
      this.soundChannel = this.sound.play();
      this.soundChannel.addEventListener(Event.SOUND_COMPLETE, onSoundComplete);
    }

    public function stop():void {
      if(this.soundChannel) {
        this.soundChannel.stop();
	this.soundChannel.removeEventListener(Event.SOUND_COMPLETE, onSoundComplete);
        this.soundChannel = null;
      }

      if(this.playing) {
        this.playing = false;
      }

      if(this.recording) {
        this.mic.removeEventListener(SampleDataEvent.SAMPLE_DATA, micSampleDataHandler);
        this.mic.removeEventListener(ActivityEvent.ACTIVITY, onMicrophoneActivity);
        this.recording = false;
      }
    }

    private function onSoundComplete(event:Event):void {
      this.stop();
      dispatchEvent(new Event(MicrophoneRecorder.SOUND_COMPLETE));
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

    public function getSoundBytesResampled(resampling:Boolean=false):ByteArray {
      if(! resampling) {
        return resampledBytes;
      }

      var targetRate:int = 44100;
      var sourceRate:int = this.frequency();
      var data:ByteArray = this.getSoundBytes();
      data.position = 0;

      // nothing todo here
      if(sourceRate == 44100) {
        resampledBytes = data;
        resampledBytes.position = 0;
        return resampledBytes;
      }

      resampledBytes = new ByteArray();

      var multiplier:Number = targetRate / sourceRate;
			
      // convert the data
      var measure:int = targetRate;
      var currentSample:Number = data.readFloat();
      var nextSample:Number = data.readFloat();

      resampledBytes.writeFloat(currentSample);

      // taken from http://code.google.com/p/as3wavsound/ in Wav.as from resampleSamples()
      while(data.bytesAvailable) {
        var increment:Number = (nextSample - currentSample) / multiplier;
        var times:int = 0;
        while(measure >= sourceRate) {
          times += 1;
          resampledBytes.writeFloat(currentSample + (increment * times));
          measure -= sourceRate;
        }

        currentSample = nextSample;
        nextSample = data.readFloat();
        measure += targetRate;
      }

      resampledBytes.writeFloat(nextSample);
      resampledBytes.position = 0;

      return resampledBytes;
    }

    private function onMicrophoneActivity(event:Event):void {
      dispatchEvent(new Event(MicrophoneRecorder.ACTIVITY));
    }

    private function micSampleDataHandler(event:SampleDataEvent):void {
      var data:ByteArray = this.getSoundBytes();
      while(event.data.bytesAvailable) {
        data.writeFloat(event.data.readFloat());
      }
    }

    private function playbackSampleHandler(event:SampleDataEvent):void {
      var i:int = 0;
      var sample:Number = 0.0;
      if(!this.soundChannel) {
	for (; i<3072; i++) {
	  event.data.writeFloat(sample);
	  event.data.writeFloat(sample);
	}
	return;
      }

      if(this.samplingStarted && this.soundChannel) {
        this.samplingStarted = false;
	this.latency = (event.position * 2.267573696145e-02) - this.soundChannel.position;
        dispatchEvent(new Event(MicrophoneRecorder.PLAYBACK_STARTED));
      }

      var data:ByteArray = this.getSoundBytesResampled();
      for (; i<8192 && data.bytesAvailable && this.playing; i++) {
        sample = data.readFloat();
        event.data.writeFloat(sample);
        event.data.writeFloat(0.0);
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
