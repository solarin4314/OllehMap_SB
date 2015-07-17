//
//  SpeakAssistController.h
//  VoiceAssist
//
//  Created by infinity on 11. 4. 20..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "avrController.h"

UIKIT_EXTERN NSString *const UISpeakAssistNoneDataNotification;
UIKIT_EXTERN NSString *const UISpeakAssistConnectCannotNotification;
UIKIT_EXTERN NSString *const UISpeakAssistReadyOKNotification;
UIKIT_EXTERN NSString *const UISpeakAssistSessionTimeoutNotification;
UIKIT_EXTERN NSString *const UISpeakAssistFailureNotification;
UIKIT_EXTERN NSString *const UISpeakAssistDisconnectNotification;
UIKIT_EXTERN NSString *const UISpeakAssistCompletePlayNotification;

@class GCDAsyncSocketGM;

@interface SpeakAssistController : NSObject <AvrControllerDelegate, UIApplicationDelegate>{

}

+(id) sharedSpeakAssist;

-(NSString *)GetVersion;
-(IBAction) Start:(id)sender;
-(IBAction) Stop:(id)sender;
-(IBAction) Play:(id)sender;
-(NSInteger) SetParameter:(NSString*)ip port:(NSInteger)_port Certification:(NSString *)_ctfi reqcontype:(NSInteger)_reqcontype;


-(IBAction) NetworkStop:(id)sender;

-(void)expiredLib;

@end
