//
//  FacebookPlugin.h
//  FacebookPlugin
//
//  Created by bohemian on 4/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Cordova/CDVPlugin.h>
#import "Facebook/FBConnect.h"

@interface FacebookPlugin : CDVPlugin < FBSessionDelegate, FBDialogDelegate > {
    
    NSString* loginCallbackID;
    NSString* logoutCallbackID;
}

@property (nonatomic, copy) NSString* loginCallbackID;
@property (nonatomic, copy) NSString* logoutCallbackID;
@property (nonatomic, retain) Facebook *facebook;

//Instance Method  
- (void) login:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) logout:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) isSessionValid:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) graphRequest:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;
- (void) dialog:(NSMutableArray*)arguments withDict:(NSMutableDictionary*)options;


@end

@interface MyFBDialogDelegate : NSObject < FBDialogDelegate > {
    
    FacebookPlugin* plugin;
    NSString* callbackID;
}

@property (nonatomic, retain) FacebookPlugin* plugin;
@property (nonatomic, copy) NSString* callbackID;

@end

@interface MyFBRequestDelegate :  NSObject < FBRequestDelegate > {
    
    FacebookPlugin* plugin;
    NSString* callbackID;
}

@property (nonatomic, retain) FacebookPlugin* plugin;
@property (nonatomic, copy) NSString* callbackID;

@end