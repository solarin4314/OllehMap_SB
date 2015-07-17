//
//  VOAViewController.h
//  OllehMap
//
//  Created by 이제민 on 14. 2. 18..
//  Copyright (c) 2014년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNavigationController.h"
#import "OMParentViewController.h"
#import "ServerConnector.h"

@interface VOAViewController : OMParentViewController<UIWebViewDelegate>
{
    NSTimer *timer;
    __weak IBOutlet UIWebView *_voaWebView;
}

- (IBAction)backBtnClick:(id)sender;




@end
