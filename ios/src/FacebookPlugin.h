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

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "Facebook/FBConnect.h"

@interface FacebookPlugin : CDVPlugin < FBSessionDelegate, FBDialogDelegate > {
    
    NSString* _loginCallbackID;
    NSString* _logoutCallbackID;
    Facebook* _facebook;
    NSMutableSet* _activeDelegates;
}

- (void) login:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) logout:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) isSessionValid:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) graphRequest:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) dialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;

@property (nonatomic, copy) NSString* loginCallbackID;
@property (nonatomic, copy) NSString* logoutCallbackID;
@property (nonatomic, retain) Facebook* facebook;
@property (nonatomic, retain) NSMutableSet* activeDelegates;

@end

@interface MyFBDialogDelegate : NSObject < FBDialogDelegate > {
    
    FacebookPlugin* _plugin;
    NSString* _callbackID;
}

- (id) initWithFacebookPlugin:(FacebookPlugin*)plugin andCallbackID:(NSString*)callbackID;

@property (nonatomic, retain) FacebookPlugin* plugin;
@property (nonatomic, copy) NSString* callbackID;

@end

@interface MyFBRequestDelegate :  NSObject < FBRequestDelegate > {
    
    FacebookPlugin* _plugin;
    NSString* _callbackID;
}

- (id) initWithFacebookPlugin:(FacebookPlugin*)plugin andCallbackID:(NSString*)callbackID;

@property (nonatomic, retain) FacebookPlugin* plugin;
@property (nonatomic, copy) NSString* callbackID;

@end