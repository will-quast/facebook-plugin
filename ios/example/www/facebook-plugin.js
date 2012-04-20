
/**
 *
 * @constructor
 */
FacebookPlugin = function() {

}

FacebookPlugin.prototype.login = function(successCallback, failedCallback, options) {
  
  successCallback = successCallback?successCallback:function(){};
  failedCallback = failedCallback?failedCallback:function(){};
  options = options?options:{scope:'email'};
  
  Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'login', [options]);
}

FacebookPlugin.prototype.logout = function(successCallback, failedCallback) {
  
  successCallback = successCallback?successCallback:function(){};
  failedCallback = failedCallback?failedCallback:function(){};
  
  Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'logout', []);
}

FacebookPlugin.prototype.isSessionValid = function(successCallback, failedCallback) {
  
  successCallback = successCallback?successCallback:function(){};
  failedCallback = failedCallback?failedCallback:function(){};
  
  Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'login', []);
}

FacebookPlugin.prototype.graphRequest = function(successCallback, failedCallback, options) {
  
  successCallback = successCallback?successCallback:function(){};
  failedCallback = failedCallback?failedCallback:function(){};
  options = options?options:{};
  options.graphPath = options.graphPath?options.graphPath:'me';
  options.params = options.params?options.params:{};
  
  Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'graphRequest', [options]);
}

FacebookPlugin.prototype.dialog = function(successCallback, failedCallback, options) {
  
  successCallback = successCallback?successCallback:function(){};
  failedCallback = failedCallback?failedCallback:function(){};
  options = options?options:{};
  options.action = options.action?options.action:'feed';
  options.params = options.params?options.params:{};
  
  Cordova.exec(successCallback, failedCallback, 'FacebookPlugin', 'dialog', [options]);
}

FacebookPlugin.prototype._castNumberToBool = function(number) {
  if(number=1) {
    return true;
  }
  return false;
}