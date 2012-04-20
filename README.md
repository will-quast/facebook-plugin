facebook-plugin
===============

A *simpler* PhoneGap/Cordova plugin to access the native Facebook SDK on IOS and Android.
This plugin is different the official plugin at [phonegap-plugin-facebook-connect](https://github.com/davejohnson/phonegap-plugin-facebook-connect) in they it strives to be simpler, smaller and easier to debug.  The official plugin uses a patched version of the facebook-js-sdk with hooks to make native SDK calls where necessary.  This approach lead to a very large memory footprint in javascript (due to the size of facebook-js-sdk) and adds unnecessary complexity to development.  This is ideal for apps that do not make use of XFBML and Social Plugins.

Facebook-plugin exposes to the developer as JavaScript, the native Facebook SDK methods:
* login
* logout
* isSessionValid
* graphRequest  [Facebook Graph API](http://developers.facebook.com/docs/reference/api/)
* dialog [Facebook Dialogs Overview](http://developers.facebook.com/docs/reference/dialogs/)

Currently supports Apache Cordova 1.5.

Except as otherwise noted, the facebook-plugin is licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)

