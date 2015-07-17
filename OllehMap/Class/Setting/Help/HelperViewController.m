//
//  HelperViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "HelperViewController.h"

@interface HelperViewController ()

@end

@implementation HelperViewController

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
    
    _isFail = NO;
    
    [_helpWebView setFrame:CGRectMake(0, _helpWebView.frame.origin.y, 320, self.view.frame.size.height - _helpWebView.frame.origin.y)];
    
    [_helpWebView setDelegate:self];
    
	// Do any additional setup after loading the view.
    NSURLRequest *urlRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://%@/setting/iphone/help.html", COMMON_SERVER_IP]] cachePolicy:NSURLRequestReloadIgnoringCacheData timeoutInterval:60];
    [_helpWebView loadRequest:urlRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    [_helpWebView stopLoading];
    [[OMIndicator sharedIndicator] stopAnimating];
    
    [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    
    _isFail = YES;
    
    // do anything error
}

- (IBAction)popBtnClick:(id)sender
{
    // 현재 URL 이 Home이 아니면, 뒤로가기 버튼이 웹뷰 뒤로가기
    
    if(_isFail)
    {
        [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
        return;
    }
    
    NSString *currentURL = _helpWebView.request.URL.absoluteString;
    
    NSLog(@"현재URL : %@", currentURL);
    if([currentURL isEqualToString:[NSString stringWithFormat:@"http://%@/setting/iphone/help.html", COMMON_SERVER_IP]])
    {
        [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
    }
    else
    {
        [_helpWebView goBack];
    }
    
}
@end
