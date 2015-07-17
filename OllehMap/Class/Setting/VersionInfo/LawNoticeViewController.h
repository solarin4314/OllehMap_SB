//
//  LawNoticeViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMParentViewController.h"
#import "ServerConnector.h"

@interface LawNoticeViewController : OMParentViewController<UIWebViewDelegate>
{
    NSTimer *timer;
    IBOutlet UIWebView *_lawWebView;
}
- (IBAction)popBtnClick:(id)sender;

@end
