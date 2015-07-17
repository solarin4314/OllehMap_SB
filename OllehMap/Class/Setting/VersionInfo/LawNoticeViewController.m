//
//  LawNoticeViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "LawNoticeViewController.h"

@interface LawNoticeViewController ()

@end

@implementation LawNoticeViewController

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
    [_lawWebView setDelegate:self];
    // MIK.geun :: 20121116 // 캐시사용안함으로 정책수정
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/setting/iphone/notice.html", COMMON_SERVER_IP]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [_lawWebView loadRequest:urlRequest];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
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
    [_lawWebView stopLoading];
    [[OMIndicator sharedIndicator] stopAnimating];
    
    [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    
    // do anything error
}
@end
