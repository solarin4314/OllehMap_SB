//
//  AccountSettingViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OMNavigationController.h"
#import "OllehMapStatus.h"

#import "ServerConnector.h"
#import "OMParentViewController.h"


#import "FHSTwitterEngine.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

// 트위터 인증키
#define kOAuthConsumerKey		@"uhxY4WBgfVn3Hk2rhSiOMQ"
#define kOAuthConsumerSecret	@"wn45DWVYU9B01qPu1xOvjmFwtOnehvJ0tssHkCypnQ"

@interface AccountSettingViewController : OMParentViewController<FHSTwitterEngineAccessTokenDelegate>
//>
{

    
    UIView *_backView;
    
    UILabel *_faceBtnLbl;
    UILabel *_twittBtnLbl;

}

- (IBAction)popBtn:(id)sender;


@end
