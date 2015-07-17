//
//  SettingViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//



#import "ServerConnector.h"
#import "OllehMapStatus.h"
#import "MapContainer.h"

// 설정
#import "FavoriteViewController.h"
#import "NoticeListViewController.h"
#import "HelperViewController.h"
#import "VersionInfoViewController.h"
#import "ResolutionViewController.h"
#import "RecentSearchViewController.h"
#import "MyImageViewController.h"
#import "AccountSettingViewController.h"
#import "OMParentViewController.h"

#import "VOAViewController.h"


@interface SettingViewController : OMParentViewController
{
    UIScrollView *_scrollView;
    
    UISwitch *_screenSwitch;
    UISwitch *_myImgSwitch;
    int _viewStartY;
    
    UIImageView *_notiImg;
    UILabel *_notiLabel;
    
    //NSMutableArray *_notiArr;
    
    
    UILabel *_imgSettingLabel;
    UIImageView *_imgSettingArrow;
    UIButton *_myImageSettingBtn;
}

- (IBAction)DoneBtnClick:(id)sender;

@property (strong, nonatomic) UIImageView *notiImg;
@property (strong, nonatomic) UILabel *notiLabel;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

@property (strong, nonatomic) IBOutlet UISwitch *screenSwitch;
@property (strong, nonatomic) IBOutlet UISwitch *myImgSwitch;


@end
