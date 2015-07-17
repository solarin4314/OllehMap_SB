//
//  BusLineViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 8..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "CommonPOIDetailViewController.h"
#import "BusLineInStationCell.h"
#import "MainViewController.h"

#define BusCellHeight 58


@interface BusLineViewController : CommonPOIDetailViewController<UITableViewDelegate, UITableViewDataSource>
{
    int _viewStartY;
    
    IBOutlet UIButton *_mapBtn;
    
    IBOutlet UIView *_busNumberWindow;
    
    UITableView *_busStationList;
    UIView *_busWhereView;
    
    NSIndexPath *currentNearStation;
}
@property (strong, nonatomic) IBOutlet UIView *busWhereView;

- (IBAction)popBtnClick:(id)sender;
- (IBAction)mapBtnClick:(id)sender;
- (IBAction)reFreshBtnClick:(id)sender;

@end
