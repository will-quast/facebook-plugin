#!/bin/sh
# This script is used by the plugin developers to copy the source files from the project into the example.

mkdir -p www
cp ../../facebook-plugin.js www

mkdir -p FacebookPlugin/Plugins
cp -R ../src/* FacebookPlugin/Plugins

mkdir -p FacebookPlugin/Plugins/Facebook
cp -R ../lib/Facebook/src/* FacebookPlugin/Plugins/Facebook