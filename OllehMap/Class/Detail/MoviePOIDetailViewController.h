//
//  MoviePOIDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 4..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"

#define X_VALUE 0
#define X_WIDTH 320

@interface MoviePOIDetailViewController : CommonPOIDetailViewController
{
    UIScrollView *_scrollView;
    
    // 주요정보라벨뷰
    UIView *_mainInfoLabelView;
    
    // 주요정보없음
    UIView *_nullMainInfoView;
    
    // 주요정보뷰
    UIView *_mainInfoView;
    
    UILabel *_notExtendLabel;
    UILabel *_extendLabel;
    UIButton *_extendBtn;
    UIImageView *_extendBtnImg;
    
    
    // 밑줄5
    UIView *_underLine5;
    
    // 상영정보라벨뷰
    UIView *_movieLabelView;
    UILabel *_supportLabel;
    UIButton *_homePageBtn;
    // 상영정보뷰
    UIView *_movieView;
    // 상영정보없음뷰
    UIView *_nullMovieView;
    UILabel *_nullMoveLbl;
    // 밑줄6
    UIView *_underLine6;
    // 상세/교통라벨 세그먼트
    UIView *_detailTrafficLabelView;
    UIImageView *_detailTrafficLabelBg;
    UILabel *_detailLabel;
    UILabel *_trafficLabel;
    
    UIButton *_detailBtn;
    UIButton *_trafficBtn;
    
    // 상세옵션뷰
    UIView *_detailOptionView;
    UIImageView *_reservationImg;
    
    // 옵션뷰 밑줄
    UIView *_underLine7;
    
    // 상세뷰
    UIView *_detailView;
    // 교통뷰
    UIView *_trafficView;
    
    // 하단버튼뷰
    UIView *_bottomView;
    
    
    int _viewStartY;
    int _prevViewStartY;
    
    // 상세y축기억
    int _detailY;
    // 교통y축기억
    int _trafficY;
    // 널 y축 기억
    int _nullStartY;
    
    CGFloat _mainInfoViewNotExpendWidth;
    CGFloat _mainInfoViewNotExpendHeight;
    
    BOOL _expend;
    
    UIButton *_mapBtn;
    
    NSString *_addrNewStr;
    NSString *_themeToDetailName;
}


@property (strong, nonatomic) NSString *themeToDetailName;
@property (strong, nonatomic) NSString *addrNewStr;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;

-(IBAction)popBtnClick:(id)sender;
-(IBAction)mapBtnClick:(id)sender;

- (void) finishRequestMovieList:(id)request;

@end
