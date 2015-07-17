//
//  BusStationPOIDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 8..
//  Copyright (c) 2013년 이제민. All rights reserved.
//
#import <UIKit/UIKit.h>
#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"

#define X_VALUE 0
#define X_WIDTH 320

@interface BusStationPOIDetailViewController : CommonPOIDetailViewController
{
    int _viewStartY;
    
    IBOutlet UIButton *_mapBtn;
    
    IBOutlet UIView *_busStationWindow;
    UIScrollView *_bsScrollView;
    
    int scrollHeight;
}

@property (strong, nonatomic) IBOutlet UIScrollView *bsScrollView;
- (IBAction)popBtnClick:(id)sender;
- (IBAction)reFreshBtnClick:(id)sender;

- (IBAction)mapBtnClick:(id)sender;
@end
