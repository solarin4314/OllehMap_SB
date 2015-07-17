//
//  AppDelegate.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"
#import "OMNavigationController.h"
#import "MainViewController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>
{
    MainViewController *_rootViewContoller;
}
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) MainViewController *rootViewContoller;
@end
