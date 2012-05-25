facebook-plugin
===============

A *simpler* [Apache Cordova](http://incubator.apache.org/cordova/) (aka [PhoneGap](http://phonegap.com/)) plugin to access the native Facebook SDK on [iOS](http://developers.facebook.com/docs/reference/iossdk/) and [Android](http://developers.facebook.com/docs/reference/androidsdk/).
This plugin is different from the official plugin at [phonegap-plugin-facebook-connect](https://github.com/davejohnson/phonegap-plugin-facebook-connect) in that it strives to be simpler, smaller and easier to debug.  The official plugin uses a patched version of the facebook-js-sdk with hooks to make native SDK calls where necessary.  This approach leads to a very large memory footprint in javascript (this is a performance issue) and adds unnecessary complexity to development.  This plugin is ideal for Cordova apps that need to take advantage of the Facebook SDK (Authentication, Graph API, Dialogs), but do not plan to make use of facebook-js-sdk's features like XFBML and Social Plugins.

Facebook-plugin exposes to the developer as JavaScript, the native Facebook SDK methods:
* login
* logout
* isSessionValid
* graphRequest  [Facebook Graph API](http://developers.facebook.com/docs/reference/api/)
* dialog [Facebook Dialogs Overview](http://developers.facebook.com/docs/reference/dialogs/)

Currently supports Apache Cordova 1.7.0 only.

Except as otherwise noted, the facebook-plugin is licensed under the Apache License, Version 2.0 (http://www.apache.org/licenses/LICENSE-2.0.html)
