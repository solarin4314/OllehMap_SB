//
//  OmPeoplePickerNavigationControllerViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 1..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "OmPeoplePickerNavigationControllerViewController.h"

@interface OmPeoplePickerNavigationControllerViewController ()

@end

@implementation OmPeoplePickerNavigationControllerViewController

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
    
    int statusBarHeight = 20;
    
    if(OM_IOSVER)
    {
        statusBarHeight = 0;
    }
    
    [self.view setFrame:CGRectMake(0, OM_STARTY, 320, self.view.frame.size.height - OM_STARTY - statusBarHeight)];
    
    NSLog(@"%@", NSStringFromCGRect(self.view.frame));
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
