//
//  InfoSupportViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ServerConnector.h"
#import "OMParentViewController.h"

@interface InfoSupportViewController : OMParentViewController<UIWebViewDelegate>
{
    NSTimer *timer;
    IBOutlet UIWebView *_supportWebView;
}
- (IBAction)popBtnClick:(id)sender;

@end
