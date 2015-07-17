//
//  LegendViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "LegendViewController.h"

@interface LegendViewController ()

@end

@implementation LegendViewController

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
    UIImageView *legendImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"legend_info.png"]];
    
    DetailScrollView *scrollView = [[DetailScrollView alloc] init];
    [scrollView setFrame:CGRectMake(0, 37 + OM_STARTY, 320, self.view.frame.size.height - 37 - OM_STARTY)];
    [scrollView setContentSize:CGSizeMake(320, legendImage.frame.size.height)];
    
    [scrollView addSubview:legendImage];
    
    [self.view addSubview:scrollView];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}
- (IBAction)closeBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
