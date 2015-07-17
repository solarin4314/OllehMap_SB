//
//  NoticeDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"
#import "OMNavigationController.h"
#import "OMParentViewController.h"
#import "OMCustomView.h"
@interface NoticeDetailViewController : OMParentViewController
{
    
    IBOutlet OMWhiteScrollView *_noticeDetailScrollView;
    
    int _viewStartY;
}
- (IBAction)popBtnClick:(id)sender;

@end
