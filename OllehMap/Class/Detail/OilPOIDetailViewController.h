//
//  OilPOIDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 4..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"
#define X_VALUE 0
#define Y_VALUE 0
#define X_WIDTH 320

@interface OilPOIDetailViewController : CommonPOIDetailViewController
{
    int _oilViewStartY;
    
    UIView *_underline;
    
    UIView *_bottomView;
    
    UILabel *_support;
    
    UIButton *_mapBtn;
    
    NSString *_addrNewStr;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) NSString *addrNewStr;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;

-(IBAction)popBtnClick:(id)sender;
-(IBAction)mapBtnClick:(id)sender;

-(void)finishRequestoilDetailAtPoiId2:(id)request;
@end
