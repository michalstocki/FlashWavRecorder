@echo off


:: Requirements for building
:: Download "Open Source Flex SDK" from http://www.adobe.com/devnet/flex/flex-sdk-download-all.html
:: file similar to: flex_sdk_4.1.0.16076_mpl.zip
::
:: create directory on disc e.g "C:\Program Files\FlexSdk"
:: Copy and extract downloaded .zip to this location
::
:: Go to Start>My Computer (right click)>Properties>Advanced System Settings>Environment Variables
:: Edit System variable called "Path"
:: Add ";C:\Program Files\FlexSdk\bin" (without quotes) at the end of its value


echo ----- Generating new SWF -----
mxmlc Recorder.as -output recorder.swf

echo ----- Copying SWF file to demo -----
xcopy /s/y "recorder.swf" "..\html\recorder.swf"

exit