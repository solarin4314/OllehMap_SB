//
//  NoticeListViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"
#import "SettingViewController.h"
#import "ServerConnector.h"
#import "NoticeDetailViewController.h"
#import "OMParentViewController.h"
@interface NoticeListViewController : OMParentViewController
{
    
    IBOutlet UIScrollView *_notiListScrollView;

    NSMutableArray *_notiArr;
    
    int _scrollViewHeight;
}

- (IBAction)popBtnClick:(id)sender;

@end
