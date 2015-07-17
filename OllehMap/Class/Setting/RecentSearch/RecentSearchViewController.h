//
//  RecentSearchViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"
#import "recentCell2.h"
//#import "RecentCell.h"
#import "FavoriteViewController.h"
#import "SettingViewController.h"
#import "BusLineViewController.h"
#import "OMNavigationController.h"
#import "OMParentViewController.h"
@interface RecentSearchViewController : OMParentViewController<UITableViewDelegate, UITableViewDataSource>
{
    
    IBOutlet UIView *_vwFavoriteContainer;
    // 편집모드 버튼
    UIButton *_editBtn;
    
    
    // 최근검색 테이블
    UITableView *_recentTableView;
    
    // 에디팅 뷰
    UIView *_editView;
    UIButton *_allSelectBtn;
    UILabel *_allSelectLabel;
    UIButton *_deleteBtn;
    UILabel *_deleteLabel;
    
    // 널뷰
    UIView *_nullView;
    UILabel *_nullLbl;
    
    BOOL _check;
    
    NSMutableDictionary *_recentList;
    
}

- (IBAction)popBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIButton *prevBtn;

@property (strong, nonatomic) IBOutlet UIButton *editBtn;
@property (strong, nonatomic) UIView *nullView;
@property (strong, nonatomic) UILabel *nullLbl;

- (IBAction)editBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UITableView *recentTableView;

- (void)didFinishRequestBusNumDetail:(id)request;

@end
