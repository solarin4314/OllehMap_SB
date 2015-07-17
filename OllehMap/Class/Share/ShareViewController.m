//
//  ShareViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "ShareViewController.h"

@interface ShareViewController ()

@end

@implementation ShareViewController

static ShareViewController *_instVC;

#pragma mark -
#pragma mark Initialization
+ (ShareViewController *)instVC
{
    if(_instVC == nil)
    {
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        _instVC = [board instantiateViewControllerWithIdentifier:@"ShareView"];
        
        [_instVC.view setFrame:CGRectMake(0, 0, 320, _instVC.view.frame.size.height)];
    }
    return _instVC;
}

+ (void)sharePopUpView:(UIView *)pView
{
    [self instVC];
    
    [pView addSubview:[ShareViewController instVC].view];
}
+ (void) ollehNaviAlertView
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:@"올레 navi로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    [alert setTag:1];
    [alert show];
    
}
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        
        
    }
    return self;
}

- (IBAction)messageBtnClick:(id)sender
{
    
    [self controlTouchUp:sender];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];

    MFMessageComposeViewController *controller = [[MFMessageComposeViewController alloc] init];
    
    if(![MFMessageComposeViewController canSendText])
	{
		[OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Message_NoAccount", @"")];
		return;
	}
    
    NSString *name = [oms.shareDictionary objectForKeyGC:@"NAME"];
    NSString *urlStr = [oms.shareDictionary objectForKeyGC:@"ShortURL"];
    NSString *Addr = [oms.shareDictionary objectForKeyGC:@"ADDR"];
    NSString *tel = [oms.shareDictionary objectForKeyGC:@"TEL"];
    
    if(urlStr == nil || [urlStr isEqualToString:@""])
    {
        urlStr = @"";
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"\n%@", urlStr];
    }
    if(Addr == nil || [Addr isEqualToString:@""])
    {
        Addr = @"";
    }
    else
    {
        
        Addr = [NSString stringWithFormat:@"\n *%@", Addr];
    }
    if(tel == nil || [tel isEqualToString:@""])
    {
        tel = @"";
    }
    else
    {
        tel = [NSString stringWithFormat:@"\n *%@", tel];
    }
    
    
    [[OMNavigationController sharedNavigationController] pushViewController:self animated:NO];
    
    controller.body = [NSString stringWithFormat:@"[올레맵]%@%@%@%@", name,urlStr,Addr,tel];
    controller.messageComposeDelegate = self;
    [self presentModalViewController:controller animated:YES];
    
}

- (IBAction)emailBtnClick:(id)sender
{
    [self controlTouchUp:sender];
    
    // 메일계정 미등록 시 알럿뷰
    if(![MFMailComposeViewController canSendMail])
	{
		[OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Mail_NoAccount", @"")];
		return;
	}
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *name = [oms.shareDictionary objectForKeyGC:@"NAME"];
    NSString *urlStr = [oms.shareDictionary objectForKeyGC:@"ShortURL"];
    NSString *Addr = [oms.shareDictionary objectForKeyGC:@"ADDR"];
    NSString *tel = [oms.shareDictionary objectForKeyGC:@"TEL"];
    
    if(urlStr == nil || [urlStr isEqualToString:@""])
    {
        urlStr = @"";
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"\n%@", urlStr];
    }
    if(Addr == nil || [Addr isEqualToString:@""])
    {
        Addr = @"";
    }
    else
    {
        
        Addr = [NSString stringWithFormat:@"\n *%@", Addr];
    }
    if(tel == nil || [tel isEqualToString:@""])
    {
        tel = @"";
    }
    else
    {
        tel = [NSString stringWithFormat:@"\n *%@", tel];
    }
    
    
    MFMailComposeViewController *controller = [[MFMailComposeViewController alloc] init];
    controller.mailComposeDelegate = self;
    [controller setSubject:[NSString stringWithFormat:@"[올레맵]%@", name]];
    [controller setMessageBody:[NSString stringWithFormat:@"[올레맵]%@%@%@%@", name,urlStr,Addr,tel] isHTML:NO];
    
    
    [[OMNavigationController sharedNavigationController]pushViewController:self animated:NO];
    [self presentModalViewController:controller animated:YES];
    
    
}

- (IBAction)kakaoTalkBtnClick:(id)sender
{
    [self controlTouchUp:sender];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *name = [oms.shareDictionary objectForKeyGC:@"NAME"];
    NSString *urlStr = [oms.shareDictionary objectForKeyGC:@"ShortURL"];
    NSString *Addr = [oms.shareDictionary objectForKeyGC:@"ADDR"];
    NSString *tel = [oms.shareDictionary objectForKeyGC:@"TEL"];
    
    if(urlStr == nil || [urlStr isEqualToString:@""])
    {
        urlStr = @"";
    }
    else
    {
        urlStr = [NSString stringWithFormat:@"\n%@", urlStr];
    }
    if(Addr == nil || [Addr isEqualToString:@""])
    {
        Addr = @"";
    }
    else
    {
        
        Addr = [NSString stringWithFormat:@"\n *%@", Addr];
    }
    if(tel == nil || [tel isEqualToString:@""])
    {
        tel = @"";
    }
    else
    {
        tel = [NSString stringWithFormat:@"\n *%@", tel];
    }
    
    
    NSMutableString *returnStr = [[NSMutableString alloc] init] ;
    
    [returnStr appendFormat:@"%@%@%@%@", name, urlStr, Addr, tel];
    
    NSString *referenceURLString = [[NSString alloc] initWithString:returnStr];
    
    //NSString *appBundleID = @"com.example.app";
    //NSString *appVersion = @"1.0";
    
    ///
    
    NSString *poiId = stringValueOfDictionary(oms.shareDictionary, @"POI_ID");
    NSString *poiType = stringValueOfDictionary(oms.shareDictionary, @"POI_TYPE");
    int crdX = [stringValueOfDictionary(oms.shareDictionary, @"POI_X") intValue];
    int crdY = [stringValueOfDictionary(oms.shareDictionary, @"POI_Y") intValue];
    
    
    // 카카오톡 호출
    if ([KakaoLinkCenter canOpenKakaoLink])
    {
        [self cancelBtnClick:nil];
        
        NSMutableArray *metaInfoArray = [NSMutableArray array];
        NSDictionary *metaInfoIOS = [NSDictionary dictionaryWithObjectsAndKeys:
                                     @"ios", @"os",
                                     @"phone", @"devicetype",
                                     APPSTORE_URL, @"installurl",[NSString stringWithFormat:@"ktolleh00047://?X=%d&Y=%d&Level=5&Name=%@&ID=%@&PType=%@&srcApp=0", crdX, crdY, name, poiId, poiType]
                                     , @"executeurl",
                                     nil];
        [metaInfoArray addObject:metaInfoIOS];
        
        [KakaoLinkCenter openKakaoLinkWithURL:@"" appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] appBundleID:[[NSBundle mainBundle] bundleIdentifier] appName:@"올레맵" message:referenceURLString];
        
        // 앱으로 연결하려면...근데 변수가 많음
        // 1. 기차역처럼 타입은 tr인데 일반상세일때
        // 2. 버스와 지하철 구별못함
        //[KakaoLinkCenter openKakaoAppLinkWithMessage:referenceURLString URL:@"" appBundleID:[[NSBundle mainBundle] bundleIdentifier] appVersion:[[NSBundle mainBundle] objectForInfoDictionaryKey:@"CFBundleShortVersionString"] appName:@"올레맵" metaInfoArray:metaInfoArray];
        
    }
    else
    {
        // 카카오톡이 설치되어 있지 않은 경우에 대한 처리
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NotSetup_kakaoTalk", @"")];
    }
    
}
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initer];
	// Do any additional setup after loading the view.
    [_scrollView setContentSize:CGSizeMake(201, 235)];
}
- (void) initer
{
    
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)infoCopyBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = [NSString stringWithString:[oms.shareDictionary objectForKeyGC:@"ShortURL"]];
    
    [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Share_Copy", @"")];
}

- (IBAction)cancelBtnClick:(id)sender
{
    [self.view removeFromSuperview];
}
#pragma mark -
#pragma mark messageComposeDelegate
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult)result;
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"메시지를 보냈습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    switch (result)
    {
        case MessageComposeResultCancelled:
            break;
        case MessageComposeResultFailed:
            break;
        case MessageComposeResultSent:
            [alert show];
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self becomeFirstResponder];
    
    // ver4 위치공유 팝업제거
    //    OMNavigationController *nc = [OMNavigationController sharedNavigationController];
    //    UIViewController *preVC= [nc.viewControllers objectAtIndexGC:nc.viewControllers.count-2];
    //    [preVC.view addSubview:self.view];
    
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}


#pragma mark -
#pragma mark MailcomposeDelegate
-(void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:nil message:@"메일 전송을 완료하였습니다." delegate:nil cancelButtonTitle:@"확인" otherButtonTitles:nil];
    
    switch (result)
    {
        case MFMailComposeResultCancelled:
            break;
        case MFMailComposeResultSaved:
            break;
        case MFMailComposeResultSent:
            [alert show];
            break;
        case MFMailComposeResultFailed:
            break;
        default:
            break;
    }
    
    [self dismissModalViewControllerAnimated:YES];
    [self becomeFirstResponder];

    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
    
}


- (IBAction)twitterBtnClick:(id)sender
{
    
    [self controlTouchUp:sender];
    
    [self twitterSend];

}
- (void) twitterSend
{
    NSString *twitterAccess = [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"uhxY4WBgfVn3Hk2rhSiOMQ" andSecret:@"wn45DWVYU9B01qPu1xOvjmFwtOnehvJ0tssHkCypnQ"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    if(!twitterAccess)
    {
        UIViewController *loginController = [[FHSTwitterEngine sharedEngine]loginControllerWithCompletionHandler:^(BOOL success)
                                             {
                                                 if(success)
                                                 {
                                                     [self pushToTwitterShare];
                                                     [self cancelBtnClick:nil];
                                                 }
                                                 
                                                 else
                                                     return;
                                             }];
        [[OMNavigationController sharedNavigationController] presentViewController:loginController animated:YES completion:nil];
    }
    else
    {
        [self pushToTwitterShare];
        [self cancelBtnClick:nil];
    }
}
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}
- (void) pushToTwitterShare
{
    SnsSendViewController *ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsSendView"];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSMutableDictionary *shareDictionarys = [[NSMutableDictionary alloc] init];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"NAME") forKey:@"SHARENAME"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"ShortURL") forKey:@"SHAREURL"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"ADDR") forKey:@"SHAREADDR"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"TEL") forKey:@"SHARETEL"];
    
    [ssvc setShareDict:shareDictionarys];
    [ssvc setShareType:2];
    [[OMNavigationController sharedNavigationController] pushViewController:ssvc animated:YES];
}

#pragma mark -
#pragma mark - facebook
- (IBAction)facebookBtnClick:(id)sender
{
    
    [self controlTouchUp:sender];
    
    NSUserDefaults *faceDefaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookUser = [faceDefaults stringForKey:@"FACEBOOKUSER"];
    
    if(!facebookUser)
    {
        [self loginFacebook];
    }
    else
    {
        // 설정사용할지 체크
        if (NSClassFromString(@"SLComposeViewController") != Nil)
        {
            if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            {
                NSLog(@"service available");
                [self pushToFaceBookShare];
                [self cancelBtnClick:nil];
    
                return;
            }
        }
        
        if (![FBSession.activeSession isOpen])
        {
            [FBSession openActiveSessionWithPublishPermissions: [NSArray arrayWithObjects: @"publish_stream", nil]
                                               defaultAudience: FBSessionDefaultAudienceEveryone
                                                  allowLoginUI: YES
             
                                             completionHandler: ^(FBSession *session,
                                                                  FBSessionState status,
                                                                  NSError *error)
             {
                 if (!error)
                 {
                     [self pushToFaceBookShare];
                     [self cancelBtnClick:nil];
                 }
             }];
        }
        else
        {
            [self pushToFaceBookShare];
            [self cancelBtnClick:nil];
        }

        
    }

}
- (void) loginFacebook
{
    [self openSession];
}
-(void)openSession
{
    if (NSClassFromString(@"SLComposeViewController") != Nil) {
        // iOS 6 설정에 있는거 사용?
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
        {
            [self useSettingInFaceBook];
        }
        else
        {
            [self noUseSettingInFaceBook];
        }

    } else {
        // iOS 5, Social.framework unavailable, use Twitter.framework instead
        [self noUseSettingInFaceBook];
    
    }

}
- (void) useSettingInFaceBook
{
    NSLog(@"service available");
    
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
                     NSString *name = [[properties objectForKey:@"properties"] objectForKey:@"ACPropertyFullName"];
                     //NSLog(@"user name = %@",[name objectForKey:@"ACPropertyFullName"]);
                     
                     // 7.0 미만에서는 fullName으로 온다?
                     if([name isEqualToString:@""])
                         name = stringValueOfDictionary([properties objectForKeyGC:@"properties"], @"fullname");
                     
                     NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
                     [defaults setObject:name forKey:@"FACEBOOKUSER"];
                     [defaults synchronize];
                     
                     
                     [self pushToFaceBookShare];
                     [self cancelBtnClick:nil];
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
// 설정사용 안함
- (void) noUseSettingInFaceBook
{
    [FBSession openActiveSessionWithPublishPermissions:[NSArray arrayWithObjects:@"publish_actions", @"publish_stream", nil] defaultAudience:FBSessionDefaultAudienceFriends allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
        if(error)
        {
            [OMMessageBox showAlertMessage:@"" :error.localizedDescription];
        }
        else
            [self sessionStateChanged:session state:state error:error];
    }];
}
-(void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
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
        
    }
}
- (void) facebookSessionOpened
{
    [[FBRequest requestForMe] startWithCompletionHandler:^(FBRequestConnection *connection, NSDictionary<FBGraphUser> *user, NSError *error) {
        if(error)
        {
            return;
        }
        else
        {
            // Handle new permissions callback
            NSLog(@"Reauthorized with publish permissions.");
            
            NSDictionary<FBGraphUser> *my = (NSDictionary<FBGraphUser> *) user;
            
            NSString *faceBookName = stringValueOfDictionary(my, @"username");
            
            if([faceBookName isEqualToString:@""])
                faceBookName = stringValueOfDictionary(my, @"name");
            
            
            
            // 로컬에 페이스북 네임을 저장한다.
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:faceBookName forKey:@"FACEBOOKUSER"];
            [defaults synchronize];
            
            [self pushToFaceBookShare];
            [self cancelBtnClick:nil];
            
        }
    }];
    
    
}
- (void) pushToFaceBookShare
{
    int fbType = 0;
    
    if (NSClassFromString(@"SLComposeViewController") != Nil)
    {
        if([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])
            fbType = 1;
    }
    
    NSUserDefaults *faceDefaults = [NSUserDefaults standardUserDefaults];
    NSString *facebookUser = [faceDefaults stringForKey:@"FACEBOOKUSER"];
    
    // 마지막안전장치 이상하게 closeAndClearTokenInformation 시에 이게 호출됨
    if(!facebookUser)
        return;
        
    SnsSendViewController *ssvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SnsSendView"];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSMutableDictionary *shareDictionarys = [[NSMutableDictionary alloc] init];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"NAME") forKey:@"SHARENAME"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"ShortURL") forKey:@"SHAREURL"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"ADDR") forKey:@"SHAREADDR"];
    [shareDictionarys setObject:stringValueOfDictionary(oms.shareDictionary, @"TEL") forKey:@"SHARETEL"];
    
    [ssvc setShareDict:shareDictionarys];
    [ssvc setShareType:fbType];
    [[OMNavigationController sharedNavigationController] pushViewController:ssvc animated:YES];
}

#pragma mark -
#pragma mark - 공통

- (IBAction)controlTouchDown:(id)sender
{
    UIControl *cell = (UIControl*)sender;
    
    UIColor *backgroundColor = [[UIColor alloc] initWithPatternImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"]];
    cell.backgroundColor = backgroundColor;
}
- (IBAction)controlTouchUp:(id)sender
{
    UIControl *cell = (UIControl*)sender;
    [cell setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0f)];
}

#pragma mark -
#pragma mark AlertView Delegate
+ (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if (alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            
            Coord myCrd = [[MapContainer sharedMapContainer_Main].kmap getUserLocation];
            
            Coord poiCrd = CoordMake([[oms.shareDictionary objectForKeyGC:@"X"] doubleValue], [[oms.shareDictionary objectForKeyGC:@"Y"] doubleValue]);
            
            myCrd = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:myCrd inCoordType:KCoordType_UTMK outCoordType:KCoordType_WGS84];
            poiCrd = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:poiCrd inCoordType:KCoordType_UTMK outCoordType:KCoordType_WGS84];
            
            double Myx = myCrd.x;
            double Myy = myCrd.y;
            
            double Destx = poiCrd.x;
            double Desty = poiCrd.y;
            
            
            NSLog(@"%f, %f, %f, %f", Myx, Myy, Destx, Desty);
            
            NSString *naviURL = [NSString stringWithFormat:@"ollehnavi://ollehnavi.kt.com/navigation.req?method=routeguide&start=(%f,%f)&end=(%f,%f)&response=ollehmap", Myx, Myy, Destx, Desty];
            
            
            if ([[UIApplication sharedApplication] openURL:[NSURL URLWithString:naviURL]])
            {
                NSLog(@"navi gogo");
            }
            else
            {
                // 알림창 표시
                [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NotSetup_navi", @"")];
            }
            
        }
    }
}

@end
