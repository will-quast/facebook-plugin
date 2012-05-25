/**
 * facebook-plugin
 *
 * Copyright 2012 williamquast.com
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

(function(){
cordova.define('cordova/plugin/facebookPlugin', function(require, exports, module) {
  
  var exec = require('cordova/exec');
  
  var facebookPlugin = {
    
    login: function(successCallback, failedCallback, options) {  
      successCallback = successCallback?successCallback:function(){};
      failedCallback = failedCallback?failedCallback:function(){};
      options = options?options:{scope:'email'};
  
      Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'login', [options]);
    },

    logout: function(successCallback, failedCallback) {
  
      successCallback = successCallback?successCallback:function(){};
      failedCallback = failedCallback?failedCallback:function(){};
  
      Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'logout', []);
    },

    isSessionValid: function(successCallback, failedCallback) {
  
      successCallback = successCallback?successCallback:function(){};
      failedCallback = failedCallback?failedCallback:function(){};
  
      Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'login', []);
    },

    graphRequest: function(successCallback, failedCallback, options) {
  
      successCallback = successCallback?successCallback:function(){};
      failedCallback = failedCallback?failedCallback:function(){};
      options = options?options:{};
      options.graphPath = options.graphPath?options.graphPath:'me';
      options.params = options.params?options.params:{};
  
      Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'graphRequest', [options]);
    },

    dialog: function(successCallback, failedCallback, options) {
  
      successCallback = successCallback?successCallback:function(){};
      failedCallback = failedCallback?failedCallback:function(){};
      options = options?options:{};
      options.action = options.action?options.action:'feed';
      options.params = options.params?options.params:{};
  
      Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'dialog', [options]);
    }
  };
  
  module.exports = facebookPlugin;
});

})();