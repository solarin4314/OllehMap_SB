//
//  VoiceAssistController.h
//  VoiceAssist
//
//  Created by 지뉴소프트 on 11. 4. 12..
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "avrController.h"

#import <AVFoundation/AVFoundation.h>

UIKIT_EXTERN NSString *const UIVoiceAssistConnectCannotNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistReadyOKNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistSessionTimeoutNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistStartRecognizeNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistFailedRecognizeNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistSucessRecognizeNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistFailureNotification;
UIKIT_EXTERN NSString *const UIVoiceAssistDisconnectNotification;

@class GCDAsyncSocketGM;


@interface VoiceAssistController : NSObject <AvrControllerDelegate, UIApplicationDelegate> {

}

+(id) sharedVoiceAssist;

-(NSString *)GetVersion;
-(IBAction) Start:(id)sender;
-(IBAction) Stop:(id)sender;
-(IBAction) Record:(id)sender;
-(NSInteger) SetParameter:(NSString*)ip port:(NSInteger)_port Certification:(NSString *)_ctfi reqcontype:(NSInteger)_reqcontype;

-(IBAction) Test:(id)sender;

-(void)expiredLib;

@end
