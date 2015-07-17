//
//  ShareViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMMessageBox.h"
//#import "OMDimmedView.h"
#import "OMNavigationController.h"
#import <MessageUI/MessageUI.h>
#import "OllehMapStatus.h"
#import "KakaoLinkCenter.h"
#import "MapContainer.h"
#import "ServerConnector.h"

#import "SnsSendViewController.h"

#import "AccountSettingViewController.h"

#import "FHSTwitterEngine.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>

#define kOAuthConsumerKey		@"uhxY4WBgfVn3Hk2rhSiOMQ"
#define kOAuthConsumerSecret	@"wn45DWVYU9B01qPu1xOvjmFwtOnehvJ0tssHkCypnQ"


@interface ShareViewController : UIViewController<MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, UIAlertViewDelegate, FHSTwitterEngineAccessTokenDelegate>
{
    UIScrollView *_scrollView;
}

#pragma mark -
#pragma mark @property
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

#pragma mark -
#pragma mark ShareViewController
+ (ShareViewController *)instVC;

+ (void) sharePopUpView :(UIView *)pView;
+ (void) ollehNaviAlertView;

- (IBAction)messageBtnClick:(id)sender;
- (IBAction)emailBtnClick:(id)sender;
- (IBAction)kakaoTalkBtnClick:(id)sender;
- (IBAction)facebookBtnClick:(id)sender;
- (IBAction)twitterBtnClick:(id)sender;


- (IBAction)infoCopyBtnClick:(id)sender;
- (IBAction)cancelBtnClick:(id)sender;
- (IBAction)controlTouchDown:(id)sender;
- (IBAction)controlTouchUp:(id)sender;
@end
