#!/bin/sh

# Requirements for building
# Download "Open Source Flex SDK" from http://opensource.adobe.com/wiki/display/flexsdk/Download+Flex+4
#
# mkdir flex4.open.source.sdk
# cd flex4.open.source.sdk
# Copy flex_sdk_4.1.0.16076_mpl.zip to this folder - cp ~/Downloads/flex_sdk_4.1.0.16076_mpl.zip .
#
# unzip flex_sdk_4.1.0.16076_mpl.zip
# cd ../
# ln -s flex4.open.source.sdk flex
#
# Add flex/bin to your $PATH
# PATH="<home directory>/flex/bin:$PATH"
#

rm -f recorder.swf

mxmlc Recorder.as -output recorder.swf

if [ -f recorder.swf ]; then
  echo "Copying recorder.swf to ../html/."
  cp -f recorder.swf ../html/.
fi
