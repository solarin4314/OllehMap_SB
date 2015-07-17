//
//  VersionInfoViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"

#import "LawNoticeViewController.h"
#import "InfoSupportViewController.h"
#import "CadastralLimitViewController.h"
#import "ServiceRuleViewController.h"
#import "OMParentViewController.h"
#import "ServerConnector.h"

@interface VersionInfoViewController : OMParentViewController<UIAlertViewDelegate>
{
    
    IBOutlet UILabel *_recentVersion;
    IBOutlet UILabel *_thisVersion;
    
    IBOutlet UIButton *_updataBtn;
    
}

- (IBAction)popBtnClick:(id)sender;

- (IBAction)updateBtnClick:(id)sender;

- (IBAction)lawNoticeBtnClick:(id)sender;
- (IBAction)cadastralLimitBtnClick:(id)sender;
- (IBAction)serviceRuleBtnClick:(id)sender;
- (IBAction)infoSupportBtnClick:(id)sender;


@end
