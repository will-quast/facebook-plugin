#!/bin/sh
# This script is used by the plugin developers to copy the source files from the project into the example.

mkdir -p facebook-plugin-example/assets/www
cp ../../facebook-plugin.js facebook-plugin-example/assets/www

mkdir -p facebook-plugin-example/src/com/williamquast/plugin
cp -R ../src/* facebook-plugin-example/src/com/williamquast/plugin

mkdir -p facebook-plugin-facebook-sdk
cp -R ../lib/Facebook/facebook/* facebook-plugin-facebook-sdk
