//
//  OMParentViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 15..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "OMParentViewController.h"

@interface OMParentViewController ()

@end

@implementation OMParentViewController

static OMBlackStatusBar *_statusBar;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        if(OM_IOSVER)
        {
            [self setNeedsStatusBarAppearanceUpdate];
        }
    }
    return self;
}
- (UIStatusBarStyle) preferredStatusBarStyle
{
    
    // 7 이상이면 부모뷰에 붙임
    if(OM_IOSVER)
    {
        [OMParentViewController instStatusBar];
        [self.view addSubview:_statusBar];
    }

    return UIStatusBarStyleDefault;
}
+ (OMBlackStatusBar *)instStatusBar
{
    if(_statusBar == nil)
    {
        _statusBar = [[OMBlackStatusBar alloc] initWithFrame:CGRectMake(0, 0, 320, 20)];
    }
    return _statusBar;
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
