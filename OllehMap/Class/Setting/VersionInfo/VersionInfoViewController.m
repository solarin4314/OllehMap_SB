//
//  VersionInfoViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "VersionInfoViewController.h"

@interface VersionInfoViewController ()

@end

@implementation VersionInfoViewController

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
	// Do any additional setup after loading the view.
    
    [self drawVersionInfoView];
}
- (void) drawVersionInfoView
{
    // plist 에서 빌드 버전 정보 가져오기
    NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
    
    if ([versionStr isEqualToString:@""] || versionStr == nil)
    {
        [_thisVersion setText:[NSString stringWithFormat:@""]];
    } else {
        [_thisVersion setText:[NSString stringWithFormat:@"현재 버전 Ver.%@", versionStr]];
    }
    
    [[ServerConnector sharedServerConnection] requestAppVersion:self action:@selector(finishAppVersionCallBack:)];
}

- (void) finishAppVersionCallBack:(id)request
{
    
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        //NSString *versionStr = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        NSString *deviceVersion = [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey];
        
        NSArray *deviceVersionArray = [deviceVersion componentsSeparatedByString:@"."];
        NSString *deviceVersionMajor = [deviceVersionArray objectAtIndexGC:0];
        NSString *deviceVersionMinor = [deviceVersionArray objectAtIndexGC:1];
        NSString *deviceVersionBuild = [deviceVersionArray objectAtIndexGC:2];
        
        NSString *recentVersionMajor = [[oms.appVersionDictionary objectForKeyGC:@"VERSION"] objectForKeyGC:@"majorVersion"];
        NSString *recentVersionMinor = [[oms.appVersionDictionary objectForKeyGC:@"VERSION"] objectForKeyGC:@"minorVersion"];
        NSString *recentVersionBuild = [[oms.appVersionDictionary objectForKeyGC:@"VERSION"] objectForKeyGC:@"buildVersion"];
        NSString *recentVersion = [NSString stringWithFormat:@"%@.%@.%@", recentVersionMajor, recentVersionMinor, recentVersionBuild];
        
        [_recentVersion setText:[NSString stringWithFormat:@"최신 버전 Ver.%@", recentVersion]];
        
        int deviceVersionValue = [deviceVersionMajor intValue] * 100000 + [deviceVersionMinor intValue] * 1000 + [deviceVersionBuild intValue] * 1;
        int recentVersionValue = [recentVersionMajor intValue] * 100000 + [recentVersionMinor intValue] * 1000 + [recentVersionBuild intValue] * 1;
        BOOL requireUpdate = recentVersionValue > deviceVersionValue;
        
        // 업데이트가 필요한 경우
        if ( requireUpdate )
        {
            [_updataBtn setEnabled:YES];
        }
        else
        {
            [_updataBtn setEnabled:NO];
        }
        
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        //[OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        //[OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
        // 다시 연결안물어봄
//        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Msg_SearchFailedWithRetry", @"") delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
//        
//        [alert setTag:1];
//        [alert show];
        
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark -
#pragma mark AlertView Delegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    if(alertView.tag == 1)
    {
        if(buttonIndex == 1)
        {
            [self drawVersionInfoView];
        }
    }
}

- (IBAction)popBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}

- (IBAction)updateBtnClick:(id)sender
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:APPSTORE_URL]];
}

- (IBAction)lawNoticeBtnClick:(id)sender
{
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    else
    {
        LawNoticeViewController *lnvc = [self.storyboard instantiateViewControllerWithIdentifier:@"LawNoticeView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:lnvc animated:YES];
        
    }
    
}

- (IBAction)cadastralLimitBtnClick:(id)sender
{
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    else
    {
        CadastralLimitViewController *lnvc = [self.storyboard instantiateViewControllerWithIdentifier:@"CadastralLimitView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:lnvc animated:YES];
        
    }
}

- (IBAction)serviceRuleBtnClick:(id)sender
{
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    else
    {
        ServiceRuleViewController *lnvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ServiceRuleView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:lnvc animated:YES];
        
    }
    
}

- (IBAction)infoSupportBtnClick:(id)sender
{
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    else
    {
        InfoSupportViewController *lnvc = [self.storyboard instantiateViewControllerWithIdentifier:@"InfoSupportView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:lnvc animated:YES];
        
    }
}
@end
