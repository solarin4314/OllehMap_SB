//
//  GeneralPOIDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 2..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"

// X 좌표
#define X_VALUE 0
// 너비
#define X_WIDTH 320
// 상세옵션 뷰 기본위치
#define DETAILOPTION_X 10
#define DETAILOPTION_Y 10
// 상세옵션 뷰 간격
//#define DETAILOPTION_DIST 5
// 상세옵션 뷰 높이
#define DETAILOPTION_HEIGHT 17

@interface GeneralPOIDetailViewController : CommonPOIDetailViewController<CommonPOIDetailViewControllerDelegate>
{
    
    NSString *_freeCalling;
    
    NSString *_shapeType;
    NSString *_fcNm;
    NSString *_idBgm;
    
    
    UIScrollView *_scrollView;
    
    
    // 무료통화일때 전화번호
    UILabel *_telLabel;
    
    
    UIView *_mainInfoLabelView;
    // 주요정보 뷰
    
    UIView *_mainInfoView;
    UIView *_mainInfoNoDataView;
    
    UILabel *_mainInfoText;
    UILabel *_expandMainInfoText;
    
    UIButton *_expandBtn;
    UIImageView *_expandBtnImg;
    UIView *_underLine5;
    
    // 상세 진짜
    UIView *_detailInfoLabelView;
    UIView *_detailInfoNoDataView;
    // 상세옵션뷰
    UIView *_detailOptionBtnView;
    UIImageView *_reservationYN;
    UIImageView *_cardYN;
    UIImageView *_parkingYN;
    UIImageView *_deliveryYN;
    UIImageView *_packingYN;
    UIImageView *_beerYN;
    UIView *_underLine6;
    
    // 영업시간 뷰
    UIView *_openingTimeView;
    UILabel *_openingText;
    
    // 휴일정보 뷰
    UIView *_closingTimeView;
    UILabel *_closingText;
    
    
    // 이용요금 뷰
    UIView *_chargeView;
    UILabel *_chargeText;
    
    
    // 주변식당 뷰
    UIView *_nearlyRestView;
    UILabel *_nearlyRestText;
    
    // 상세 끝
    
    // 하단 버튼 3개 뷰
    UIView *_bottomView;
    
    UIView *_blankPOIView;
    
    UILabel *_blankPOIlbl;
    
    UIControl *_callLinkView;
    UITextField *_myNumber;
    UIView *_callLinkAlertView;
    
    // y축
    int _viewStartY;
    
    // y축 기억해놓기
    int  _prevViewStartY;
    
    // 블랭크POI y축기억
    int _blankStartY;
    
    
    // 확장상태 체크
    BOOL _expand;
    
    // 주요정보 널 체크
    BOOL _mainInfoNull;
    // 상세정보 널 체크
    BOOL _detailInfoNull;
    // 주요정보뷰(축소일때) 너비, 높이 저장(확장, 축소)
    CGFloat _mainInfoViewNotExpendWidth;
    CGFloat _mainInfoViewNotExpendHeight;
    
    UIButton *_mapBtn;
    
    NSString *_themeToDetailName;

}
@property (strong, nonatomic) NSString *themeToDetailName;

@property (strong, nonatomic) NSString *freeCalling;
@property (strong, nonatomic) NSString *addrNewStr;

@property (strong, nonatomic) NSString *shapeType;
@property (strong, nonatomic) NSString *fcNm;
@property (strong, nonatomic) NSString *idBgm;

@property (strong, nonatomic) IBOutlet UIButton *popBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;

- (IBAction)popBtnClick:(id)sender;
- (IBAction)mapBtnClick:(id)sender;

@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;

- (void)expandClick:(id)sender;

- (void)goFreeCallClick:(id)sender;
- (void)touchBackGround:(id)sender;
- (void)keyboardShow:(id)sender;

@end
