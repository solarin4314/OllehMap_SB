//
//  AccountSettingViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "AccountSettingViewController.h"

@interface AccountSettingViewController ()

@end

@implementation AccountSettingViewController

- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        
    }
    return self;
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self renderBackView];
    
    
}
- (void) initer
{
    _backView = [[UIView alloc] init];
    [_backView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - (OM_STARTY + 37))];
    [_backView setBackgroundColor:[UIColor whiteColor]];
    [self.view addSubview:_backView];
    
    _twittBtnLbl = [[UILabel alloc] init];
    _faceBtnLbl = [[UILabel alloc] init];
    
}
- (void) renderBackView
{
    for (UIView *subView in _backView.subviews) {
        [subView removeFromSuperview];
    }
    [self renderTwitter];
    [self renderFaceBook];
}
- (void) checkSettingFb
{
    NSUserDefaults *faceDefaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookId = [faceDefaults stringForKey:@"FACEBOOKUSER"];
    
    if(facebookId && ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        //[self logoutFacebook];
    }
    else if (facebookId &&  [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        [self settingFaceBook];
    }
}
- (void) renderTwitter
{
    // 트위터
    UILabel *twitLbl = [[UILabel alloc] init];
    [twitLbl setFrame:CGRectMake(21,15, 200, 17)];
    [twitLbl setText:@"트위터"];
    [twitLbl setFont:[UIFont boldSystemFontOfSize:17]];
    [twitLbl setBackgroundColor:[UIColor clearColor]];
    [_backView addSubview:twitLbl];
    
    
    // 트윗뷰
    UIView *twitView = [[UIView alloc] init];
    [twitView setFrame:CGRectMake(10, 41, 300, 45)];
    [_backView addSubview:twitView];
    
    UIButton *twitBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [twitBtn setImage:[UIImage imageNamed:@"setting_box_01.png"] forState:UIControlStateNormal];
    [twitBtn setFrame:CGRectMake(0, 0, 300, 45)];
    [twitBtn addTarget:self action:@selector(twitterLogin:) forControlEvents:UIControlEventTouchUpInside];
    [twitView addSubview:twitBtn];

    [_twittBtnLbl setFrame:CGRectMake(143, 0, 130, 45)];
    [_twittBtnLbl setFont:[UIFont boldSystemFontOfSize:14]];
    [_twittBtnLbl setBackgroundColor:[UIColor clearColor]];
    [_twittBtnLbl setText:@""];
    
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"uhxY4WBgfVn3Hk2rhSiOMQ" andSecret:@"wn45DWVYU9B01qPu1xOvjmFwtOnehvJ0tssHkCypnQ"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    NSString *twitterAccess = [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
    
    if(!twitterAccess)
    {
        UIImageView *twitterImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_twitter.png"]];
        [twitterImg setFrame:CGRectMake(118, 13, 20, 20)];
        [twitView addSubview:twitterImg];
        
        [_twittBtnLbl setTextAlignment:NSTextAlignmentLeft];
        [_twittBtnLbl setText:@"로그인"];
        [twitView addSubview:_twittBtnLbl];
    }
    else
    {
        UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
        [arrowImg setFrame:CGRectMake(280, 16, 9, 14)];
        [twitView addSubview:arrowImg];
        
        UILabel *twittLoginId = [[UILabel alloc] init];
        [twittLoginId setFrame:CGRectMake(11, 15, 200, 15)];
        [twittLoginId setFont:[UIFont boldSystemFontOfSize:15]];
        [twittLoginId setBackgroundColor:[UIColor clearColor]];
        [twittLoginId setTextColor:convertHexToDecimalRGBA(@"19", @"a8", @"c7", 1)];
        [twittLoginId setText:FHSTwitterEngine.sharedEngine.authenticatedUsername];
        [twitView addSubview:twittLoginId];
        [twitView addSubview:_twittBtnLbl];
        
        [_twittBtnLbl setTextAlignment:NSTextAlignmentRight];
        [_twittBtnLbl setText:@"로그아웃"];
        
    }
    
    
}
- (void)twitterLogin:(id)sender
{
    NSString *twitterAccess = [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
    
    if(!twitterAccess)
    {
        
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success) {
            NSLog(success?@"L0L success":@"O noes!!! Loggen faylur!!!");
        }];
        [[OMNavigationController sharedNavigationController] presentViewController:loginController animated:YES completion:nil];
    }
    else
    {
        [self logout];
    }
    
}
- (void)logout
{
    [[FHSTwitterEngine sharedEngine]clearAccessToken];
    
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    
    [nd removeObjectForKey:@"SavedAccessHTTPBody"];
    
    [self renderBackView];
}

- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initer];
    
    [self checkSettingFb];

}
#pragma mark -
#pragma mark - facebook
- (void) renderFaceBook
{
    NSUserDefaults *faceDefaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookId = [faceDefaults stringForKey:@"FACEBOOKUSER"];
    
    
    if(!facebookId && [SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        [self settingFaceBook];
        return;
    }
    
    // 페이스북
    UILabel *twitLbl = [[UILabel alloc] init];
    [twitLbl setFrame:CGRectMake(21,100, 200, 17)];
    [twitLbl setText:@"페이스북"];
    [twitLbl setFont:[UIFont boldSystemFontOfSize:17]];
    [twitLbl setBackgroundColor:[UIColor clearColor]];
    [_backView addSubview:twitLbl];
    
    // 페북뷰
    UIView *faceView = [[UIView alloc] init];
    [faceView setFrame:CGRectMake(10, 126, 300, 45)];
    [_backView addSubview:faceView];
    
    UIButton *faceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [faceBtn setImage:[UIImage imageNamed:@"setting_box_01.png"] forState:UIControlStateNormal];
    [faceBtn setFrame:CGRectMake(0,0, 300, 45)];
    [faceBtn addTarget:self action:@selector(faceBookLogin:) forControlEvents:UIControlEventTouchUpInside];
    [faceView addSubview:faceBtn];
    
    [_faceBtnLbl setFrame:CGRectMake(143, 0, 130, 45)];
    [_faceBtnLbl setFont:[UIFont boldSystemFontOfSize:14]];
    [_faceBtnLbl setBackgroundColor:[UIColor clearColor]];
    
    if(!facebookId)
    {
        UIImageView *faceBookImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_facebook.png"]];
        [faceBookImg setFrame:CGRectMake(118, 13, 20, 20)];
        [faceView addSubview:faceBookImg];
        
        [_faceBtnLbl setTextAlignment:NSTextAlignmentLeft];
        [_faceBtnLbl setText:@"로그인"];
    }
    else
    {
        [_faceBtnLbl setTextAlignment:NSTextAlignmentRight];
        [_faceBtnLbl setText:@"로그아웃"];
        
        UIImageView *arrowImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
        [arrowImg setFrame:CGRectMake(280, 16, 9, 14)];
        [faceView addSubview:arrowImg];
        
        
        UILabel *faceLoginId = [[UILabel alloc] init];
        [faceLoginId setFrame:CGRectMake(11, 15, 150, 15)];
        [faceLoginId setFont:[UIFont boldSystemFontOfSize:15]];
        [faceLoginId setBackgroundColor:[UIColor clearColor]];
        [faceLoginId setTextColor:convertHexToDecimalRGBA(@"19", @"a8", @"c7", 1)];
        [faceLoginId setText:facebookId];
        [faceView addSubview:faceLoginId];
        
        
    }
    
    [faceView addSubview:_faceBtnLbl];
}
- (void)faceBookLogin:(id)sender
{
    NSUserDefaults *faceDefault = [NSUserDefaults standardUserDefaults];
    
    NSString *faceId = [faceDefault stringForKey:@"FACEBOOKUSER"];

    // 페북계정없고 저장된것도 없다
	if (!faceId && ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {
        // 로그인 시킴
		[self loginFacebook];
	}
    // 페북계정없는데 저장된게 있다
    else if(faceId && ![SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
    {		// 로그아웃 시킴
		[self logoutFacebook];
	}
    // 페북계정있고 저장된게 있다
    else
    {
        [OMMessageBox showAlertMessage:@"" :@"설정 > 페이스북 계정 로그아웃이 필요합니다"];
    }
}
- (void) settingFaceBook
{
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
    __block ACAccount *facebookAccount = nil;
    
    // Specify App ID and permissions
    NSDictionary *options = @{
                              ACFacebookAppIdKey:facebooksId,
                              ACFacebookPermissionsKey: @[@"email", @"basic_info"],
                              ACFacebookAudienceKey:ACFacebookAudienceFriends
                              }; // basic read permissions
    
    [accountStore requestAccessToAccountsWithType:facebookAccountType
                                          options:options completion:^(BOOL granted, NSError *e)
     {
         if (granted) {
             
             
             dispatch_sync(dispatch_get_main_queue(), ^{
                 @autoreleasepool {
                     
                     NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                     
                     facebookAccount = [accounts lastObject];
                     
                     NSDictionary *properties = [facebookAccount dictionaryWithValuesForKeys:[NSArray arrayWithObject:@"properties"]];
                     NSString *name = stringValueOfDictionary([properties objectForKeyGC:@"properties"], @"ACPropertyFullName");
                     
                     // 7.0 미만에서는 fullName으로 온다?
                     if([name isEqualToString:@""])
                         name = stringValueOfDictionary([properties objectForKeyGC:@"properties"], @"fullname");
                                                               
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:name forKey:@"FACEBOOKUSER"];
                     [defaults synchronize];
                     
                     [self renderBackView];
                 }
             });
             
             
         }
         else {
             dispatch_sync(dispatch_get_main_queue(), ^{
                 @autoreleasepool {
                     [OMMessageBox showAlertMessage:facebooksId :[e description]];
                     NSLog(@"Error: %@", [e description]);
                     NSLog(@"Access denied");
                 }
             });
             
         }
     }];

}
- (void) loginFacebook
{
    [self openFbSession];
}
- (void) logoutFacebook
{
    
    // 로컬에 페이스북 로그아웃 되었다고 저장한다.
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults removeObjectForKey:@"FACEBOOKUSER"];
    [defaults removeObjectForKey:@"FBAccessTokenKey"];
    [defaults synchronize];
    
    [FBSession.activeSession closeAndClearTokenInformation];
    
    
    
    [self renderBackView];
}
- (void) openFbSession
{
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions", @"publish_stream", nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        [self sessionStateChangedCount:session state:state error:error];
    }];
}
-(void)sessionStateChangedCount:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    NSLog(@"sessionStatusChanged");
    switch (state) {
        case FBSessionStateOpen:
            NSLog(@"FBSessionStateOpen");
            [self facebookSessionOpened];
            break;
        case FBSessionStateClosed:
        case FBSessionStateClosedLoginFailed:
            NSLog(@"FBSessionStateClosed");
            break;
        default:
            break;
    }
    
    if (error)
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:error.localizedDescription delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        //[alertView show];
        [OMMessageBox showAlertMessage:@"" :error.localizedDescription];
    }
}
- (void) facebookSessionOpened
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        if(error)
        {
            NSLog(@"error");
            return;
        }
        else
        {
            // 로컬에 페이스북 네임을 저장한다.
            NSString *accessToken = [[FBSession.activeSession accessTokenData] accessToken];
            
            NSDictionary<FBGraphUser> *my = (NSDictionary<FBGraphUser> *) user;
            
            NSString *faceBookName = stringValueOfDictionary(my, @"username");
            
            if([faceBookName isEqualToString:@""])
                faceBookName = stringValueOfDictionary(my, @"name");
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:faceBookName forKey:@"FACEBOOKUSER"];
 
            [defaults setObject:accessToken forKey:@"FBAccessTokenKey"];
            [defaults synchronize];
            
            [self renderBackView];
            
        }
    }];
   
}

#pragma mark -
#pragma mark IBAction
- (IBAction)popBtn:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
