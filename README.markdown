Simple Microphone Recorder
==========================

Use flash to record audio data from a microphone. Converts the audio data to a WAV file. Uploads the WAV file to the server. The WAV file is POSTed as a multpart form-data request. Additional fields can be added to the request, such as authenticity_token, (response) formart, etc... The flash recorder creates serveral external interfaces. This allows the recorder to be controlled through javascript. Only the save button must be clicked inside the flash application, see [Upload and download require user interaction](http://www.adobe.com/devnet/flashplayer/articles/fplayer10_security_changes.html#head3) for more information.


Embedding the Recorder
----------------------

    <script>
      var appWidth = 24;
      var appHeight = 24;
      var flashvars = {'event_handler': 'microphone_recorder_events', 'upload_image': 'images/upload.png'};
      var params = {};
      var attributes = {'id': "recorderApp", 'name':  "recorderApp"};
      swfobject.embedSWF("recorder.swf", "flashcontent", appWidth, appHeight, "10.1.0", "", flashvars, params, attributes);
    </script>

The event_handler is a javascript function that is called from the flash application. The first argument to the event_handler is always the name of the event as a string. The other arguments may vary depending on the event.


Flash vars
----------

**event_handler**: javascript function called from the flash application

**upload_image**: image used as the save button

**font_color**: font color for the save text, default #0000EE

**font_size**: font size for the save text, default 12

**save_text**: text used for the save link, default Save

**background_color**: background color of the flash app, only used when using a save link

*if upload_image failes recorder will use a save link instead*


Flash Events
------------

**ready**: recorder is ready for use

* width - save button's width
* height - save button's height

**no_microphone_found**: no microphone was found when trying to record

**microphone_user_request**: user needs to allow the recorder to access the microphone

**microphone_connected**: user allowed access to the microphone

* microphone - Microphone object from flash, can be used to get the name of the microphone, i.e. microphone.name

**microphone_not_connected**: user denied access to the microphone, *at this point the recorder CAN NOT be used until the user reloads the page*

**recording**: recording audio data from the microphone

* name - of the recording that was specified when record was called

**recording_stopped**: stopped recording audio data

* name - of the recording that was specified when record was called
* duration - of the recording as a floating point value in seconds

**playing**: playing back the recorded audio data

* name - of the recording that was specified when play was called

**playback_started**: useful for synchronizing playback with animation

* name - of the recording that was specified when play was called
* latency - number of milliseconds before playback starts

**stopped**: stopped playing back the recorded audio data

* name - of the recording that was specified when play was called

**save_pressed**: save button was pressed in the recorder, good place to update the form data in the recorder

* name - of the recording

**saving**: upload is in progress

* name - of the recording

**saved**: upload is complete

* name - of the recording
* response - from the server as a string, can use var data = jQuery.parseJSON(arguments[2]) if response is json

**save_failed**: the recorder failed to upload the audio data

* name - of the recording
* error - message as a string

**save_progress**: upload progress

* name - of the recording
* bytes_loaded - number of bytes uploaded
* bytes_total - number of bytes to upload

Recorder JS Interface
---------------------

**record**: tells the recorder to record audio data from the microphone

* name - of the recording, basically a reference to the recording, use this name for playback
* filename - [optional] if saving the file on the server, this is the name of the file to save the WAV file as

*will also stop recording if currently recording*

**playBack**: tells the recorder to playback the recorded audio

* name - of the recording

*will stop playback if called before playback ends*

**stopPlayBack**: tells the recorder to stop recording or playback

**duration**: returns the duration of the recording

* name - of the recording

**init**: setup the recorder for saving recordings

* url - upload url
* field_name - name of the form field for the WAV file
* form_data - additional form data. Specified as an array of name/value pairs. ex: [{"name": 'authenticity_token', "value": "xxxx"}, {"name": "format", "value": "json"}]

**permit**: show the permissions dialog for microphone access, make sure the flash application is large enough for the dialog box before calling this method. Must be at least 240x160.

**show**: show the save button

**hide**: hide the save button

**update**: update the form data

* form_data - additional form data, in jQuery you can use $('#upload_form').serializeArray()

**configure**: configure microphone settings

* rate - at which the microphone captures sound, in kHz. default is 22. Currently we only support 44 and 22.
* gain - the amount by which the microphone should multiply the signal before transmitting it. default is 100
* silence_level - amount of sound required to activate the microphone and dispatch the activity event. default is 0
* silence_timeout - number of milliseconds between the time the microphone stops detecting sound and the time the activity event is dispatched. default is 4000

**setUseEchoSuppression**: use echo suppression

* yes_no

**setLoopBack**: routes audio captured by a microphone to the local speakers

* yes_no

**getMicrophone**: returns the microphone object
