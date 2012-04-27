/*
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

#import "FacebookPlugin.h"

#define APP_ID @"263149720445234"

@implementation FacebookPlugin

@synthesize facebook=_facebook, loginCallbackID=_loginCallbackID, logoutCallbackID=_logoutCallbackID, activeDelegates=_activeDelegates;

- (CDVPlugin*) initWithWebView:(UIWebView *)theWebView {
    
    _facebook = [[Facebook alloc] initWithAppId:APP_ID andDelegate: self];
    _activeDelegates = [[NSMutableSet alloc] initWithCapacity:0];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"] 
        && [defaults objectForKey:@"FBExpirationDateKey"]) {
        self.facebook.accessToken = [defaults objectForKey:@"FBAccessTokenKey"];
        self.facebook.expirationDate = [defaults objectForKey:@"FBExpirationDateKey"];
    }
    
    return [super initWithWebView:theWebView];
}

- (void) handleOpenURL:(NSNotification*)notification
{
	NSURL* url = [notification object];
    
	if (![url isKindOfClass:[NSURL class]]) {
        return;
	}
    
	[self.facebook handleOpenURL:url];
}

- (void)login:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    
    [self setLoginCallbackID:[arguments objectAtIndex:0]];
    
    NSString *scope = (NSString*)[options objectForKey:@"scope"];
    
    if (![self.facebook isSessionValid]) {
        [self.facebook authorize: [scope componentsSeparatedByString:@","]];
    } else {
        NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:1];
        [message setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
        CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:message];
        [self writeJavascript:[result toSuccessCallbackString: self.loginCallbackID]];
    }
}

- (void)activeDelegateFinished:(id)delegate {
    [self.activeDelegates removeObject:delegate];
}

- (void)logout:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    [self setLogoutCallbackID: [arguments objectAtIndex:0]];
    
    [self.facebook logout:self];
}

- (void)isSessionValid:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    NSString *callbackID = [arguments objectAtIndex:0];
    
    BOOL valid = [self.facebook isSessionValid];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsInt:[[NSNumber numberWithBool:valid] intValue] cast:@"window.FacebookPlugin._castNumberToBool"];
    [self writeJavascript:[result toSuccessCallbackString: callbackID]];
}

- (void)graphRequest:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    NSString *callbackID = [arguments objectAtIndex:0];
    NSString *graphPath = (NSString*)[options objectForKey:@"graphPath"];
    NSMutableDictionary *params = (NSMutableDictionary*)[options objectForKey:@"params"];
    
    MyFBRequestDelegate *delegate = [[MyFBRequestDelegate alloc] initWithFacebookPlugin:self andCallbackID:callbackID];
    [self.activeDelegates addObject:delegate];
    
    [self.facebook requestWithGraphPath:graphPath andParams:params andDelegate:delegate];
    [delegate release];
}

- (void)dialog:(NSMutableArray *)arguments withDict:(NSMutableDictionary *)options {
    NSString *callbackID = [arguments objectAtIndex:0];
    NSString *action = (NSString*)[options objectForKey:@"action"];
    NSMutableDictionary *params = (NSMutableDictionary*)[options objectForKey:@"params"];
    
    MyFBDialogDelegate *delegate = [[MyFBDialogDelegate alloc] initWithFacebookPlugin:self andCallbackID:callbackID];
    [self.activeDelegates addObject:delegate];
    
    [self.facebook dialog:action andParams:params andDelegate:delegate];
    [delegate release];
}

- (void)dealloc {
    
    [_loginCallbackID release];
    [_logoutCallbackID release];
    [_facebook release];
    [_activeDelegates release];
    
    [super dealloc];
}

//######################## FBSessionDelegate

/**
 * Called when the user successfully logged in.
 */
- (void)fbDidLogin {
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:[self.facebook accessToken] forKey:@"FBAccessTokenKey"];
    [defaults setObject:[self.facebook expirationDate] forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
    
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:1];
    [message setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:message];
    [self writeJavascript:[result toSuccessCallbackString: self.loginCallbackID]];
}

/**
 * Called when the user dismissed the dialog without logging in.
 */
- (void)fbDidNotLogin:(BOOL)cancelled {
    
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:2];
    [message setObject:[NSNumber numberWithBool:NO] forKey:@"success"];
    [message setObject:[NSNumber numberWithBool:cancelled] forKey:@"cancelled"];
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:message];
    [self writeJavascript:[result toSuccessCallbackString: self.loginCallbackID]];
}

/**
 * Called after the access token was extended. If your application has any
 * references to the previous access token (for example, if your application
 * stores the previous access token in persistent storage), your application
 * should overwrite the old access token with the new one in this method.
 * See extendAccessToken for more details.
 */
- (void)fbDidExtendToken:(NSString*)accessToken expiresAt:(NSDate*)expiresAt {
    
    [self.facebook setAccessToken: accessToken];
    [self.facebook setExpirationDate: expiresAt];
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
    [defaults setObject:expiresAt forKey:@"FBExpirationDateKey"];
    [defaults synchronize];
}

/**
 * Called when the user logged out.
 */
- (void)fbDidLogout {
    
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
    
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK];
    [self writeJavascript:[result toSuccessCallbackString: self.logoutCallbackID]];
}

/**
 * Called when the current session has expired. This might happen when:
 *  - the access token expired
 *  - the app has been disabled
 *  - the user revoked the app's permissions
 *  - the user changed his or her password
 */
- (void)fbSessionInvalidated {
    
    // Remove saved authorization information if it exists
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    if ([defaults objectForKey:@"FBAccessTokenKey"]) {
        [defaults removeObjectForKey:@"FBAccessTokenKey"];
        [defaults removeObjectForKey:@"FBExpirationDateKey"];
        [defaults synchronize];
    }
}

@end




/**
 *  MyFBDialogDelegate
 *
 */
@implementation MyFBDialogDelegate

@synthesize plugin=_plugin, callbackID=_callbackID;

- (id) initWithFacebookPlugin:(FacebookPlugin*)plugin andCallbackID:(NSString*)callbackID {
    self = [super init];
    
    if(self) {
        [self setPlugin: plugin]; // assign
        [self setCallbackID: callbackID]; // copy
    }
    
    return self;
}

/**
 * Called when the dialog succeeds with a returning url.
 */
- (void)dialogCompleteWithUrl:(NSURL *)url {
    
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:2];
    [message setObject:[NSNumber numberWithBool:YES] forKey:@"success"];
    if(url) {
        [message setObject:[url absoluteString] forKey:@"url"];
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:message];
    [self.plugin writeJavascript:[result toSuccessCallbackString: self.callbackID]];
    [self.plugin activeDelegateFinished:self];
}

/**
 * Called when the dialog get canceled by the user.
 */
- (void)dialogDidNotCompleteWithUrl:(NSURL *)url {
    
    NSMutableDictionary *message = [NSMutableDictionary dictionaryWithCapacity:3];
    [message setObject:[NSNumber numberWithBool:NO] forKey:@"success"];
    [message setObject:[NSNumber numberWithBool:YES] forKey:@"cancelled"];
    if(url) {
        [message setObject:[url absoluteString] forKey:@"url"];
    }
    CDVPluginResult* result = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:message];
    [self.plugin writeJavascript:[result toSuccessCallbackString: self.callbackID]];
    [self.plugin activeDelegateFinished:self];
}

/**
 * Called when dialog failed to load due to an error.
 */
- (void)dialog:(FBDialog*)dialog didFailWithError:(NSError *)error {
    
    CDVPluginResult* cdvResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
    [self.plugin writeJavascript:[cdvResult toSuccessCallbackString: self.callbackID]];
    [self.plugin activeDelegateFinished:self];
}

/**
 * Asks if a link touched by a user should be opened in an external browser.
 *
 * If a user touches a link, the default behavior is to open the link in the Safari browser,
 * which will cause your app to quit.  You may want to prevent this from happening, open the link
 * in your own internal browser, or perhaps warn the user that they are about to leave your app.
 * If so, implement this method on your delegate and return NO.  If you warn the user, you
 * should hold onto the URL and once you have received their acknowledgement open the URL yourself
 * using [[UIApplication sharedApplication] openURL:].
 */
- (BOOL)dialog:(FBDialog*)dialog shouldOpenURLInExternalBrowser:(NSURL *)url {
    
    //TODO;
    return YES;
}

- (void)dealloc {
    
    [_plugin release];
    [_callbackID release];
    
    [super dealloc];
}

@end



/**
 *  MyFBRequestDelegate
 *
 */
@implementation MyFBRequestDelegate

@synthesize plugin=_plugin, callbackID=_callbackID;

- (id) initWithFacebookPlugin:(FacebookPlugin*)plugin andCallbackID:(NSString*)callbackID {
    self = [super init];
    
    if(self) {
        [self setPlugin: plugin]; // assign
        [self setCallbackID: callbackID]; // copy
    }
    
    return self;
}

/**
 * Called when an error prevents the request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
    
    CDVPluginResult* cdvResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_ERROR messageAsString:[error localizedDescription]];
    [self.plugin writeJavascript:[cdvResult toSuccessCallbackString: self.callbackID]];
    [self.plugin activeDelegateFinished:self];
}

/**
 * Called when a request returns and its response has been parsed into
 * an object.
 *
 * The resulting object may be a dictionary, an array or a string, depending
 * on the format of the API response. If you need access to the raw response,
 * use:
 *
 * (void)request:(FBRequest *)request
 *      didReceiveResponse:(NSURLResponse *)response
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
    
    CDVPluginResult* cdvResult = [CDVPluginResult resultWithStatus: CDVCommandStatus_OK messageAsDictionary:result];
    [self.plugin writeJavascript:[cdvResult toSuccessCallbackString: self.callbackID]];
    [self.plugin activeDelegateFinished:self];
}

- (void)dealloc {
    
    [_plugin release];
    [_callbackID release];
    
    [super dealloc];
}

@end
