//
//  VOAViewController.m
//  OllehMap
//
//  Created by 이제민 on 14. 2. 18..
//  Copyright (c) 2014년 이제민. All rights reserved.
//

#import "VOAViewController.h"

@interface VOAViewController ()

@end

@implementation VOAViewController

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
    
    
    
    [_voaWebView setFrame:CGRectMake(_voaWebView.frame.origin.x, _voaWebView.frame.origin.y, 320, self.view.frame.size.height - _voaWebView.frame.origin.y)];
    
    [_voaWebView setDelegate:self];
    
    NSString *myUUID = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppUUID"];
    
    NSString *url_content = [[NSString stringWithFormat:@"%@/mobile/voc_insert.php", VOA_SERVER] stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    NSURL *url = [NSURL URLWithString:url_content];
    NSString *body =[NSString stringWithFormat: @"APPID=%@&DEVICE_ID=%@&TITLE_BAR=%@&APP_VER=%@&OS_VER=%@", appId, myUUID, @"NO", [[NSBundle mainBundle] objectForInfoDictionaryKey:(NSString *)kCFBundleVersionKey], [NSString stringWithFormat:@"IOS %@", [[UIDevice currentDevice] systemVersion]]];
    
    NSMutableURLRequest *requestObj = [NSMutableURLRequest requestWithURL:url];
    
    [requestObj setHTTPMethod:@"POST"];
    
    [requestObj setHTTPBody: [body dataUsingEncoding: NSUTF8StringEncoding]];
    
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
	[_voaWebView loadRequest:requestObj];

}
- (void) webViewDidStartLoad:(UIWebView *)webView
{
    [[OMIndicator sharedIndicator] startAnimating];
    
    // webView connected
    timer = [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(cancelWeb) userInfo:nil repeats:NO];
    
}
- (void) webViewDidFinishLoad:(UIWebView *)webView
{
    
    [timer invalidate];
    
    [[OMIndicator sharedIndicator] stopAnimating];
}
- (void)cancelWeb
{
    [_voaWebView stopLoading];
    [[OMIndicator sharedIndicator] stopAnimating];
    
    [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    
    // do anything error
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)backBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}
@end
