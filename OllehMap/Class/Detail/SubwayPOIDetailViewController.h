//
//  SubwayPOIDetailViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 7..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"

// X 좌표
#define X_VALUE 0
// 너비
#define X_WIDTH 320

@interface SubwayPOIDetailViewController : CommonPOIDetailViewController<UIScrollViewDelegate>
{
    UIScrollView *_scrollView;
    
    // 열차시간표, 첫차막차, 출구정보라벨
    UIView *_timeFirstLastExitLabelView;
    UIImageView *_timeFisrtLastExitImg;
    
    UILabel *_trainTimeTableLabel;
    UIButton *_trainTimeTableBtn;
    UILabel *_firstLastLabel;
    UIButton *_firstLastBtn;
    UILabel *_exitInfoLabel;
    UIButton *_exitInfoBtn;
    //
    // 열차시간표뷰
    UIView *_trainTimeTableView;
    
    UIView *_trainTimeTableOptionView;
    
    UIView *_trainTimeTableTimeView;
    
    UIImageView *_trainTimeTableTimeBG;
    
    
    UIImageView *_weekdayImg;
    UIImageView *_saturdayImg;
    UIImageView *_sundayImg;
    
    UIButton *_weekdayBtn;
    UIButton *_saturdayBtn;
    UIButton *_sundayBtn;
    // 라벨
    UILabel *_timeRange;
    // < > 버튼
    UIButton *_prevPageBtn;
    UIButton *_nextPageBtn;
    
    UILabel *_leftDirection;
    UILabel *_rightDirection;
    
    UILabel *_upperTime;
    UILabel *_upperDest;
    
    UILabel *_downerTime;
    UILabel *_downerDest;
    // 탑뷰
    UIView *_subTopView;
    UIScrollView *_smallScroll;
    UIPageControl *_pControl;
    int paging;
    // 첫차막차뷰
    
    UIView *_firstLastView;
    
    UIButton *_weekDayButton;
    UIButton *_saturDayButton;
    UIButton *_sunDayButton;
    
    UIImageView *_weekDayImage;
    UIImageView *_saturDayImage;
    UIImageView *_sunDayImage;
    
    UIView *_upperLabelView;
    UILabel *_upperLabel;
    
    UIView *_upperView;
    
    UIImageView *_upperBackGround;
    
    UILabel *_upperFirstTime;
    UILabel *_upperFirstDest;
    
    UILabel *_upperLastTime;
    UILabel *_upperLastDest;
    
    
    
    UIView *_downerLabelView;
    UILabel *_downerLabel;
    
    UIView *_downerView;
    
    UIImageView *_downerBackGround;
    
    UILabel *_downerFirstTime;
    UILabel *_downerFirstDest;
    UILabel *_downerLastTime;
    UILabel *_downerLastDest;
    
    int _prevFirstLastViewStartY;
    //
    
    // 출구정보뷰
    UIView *_exitInfoView;
    
    int _addViewNum;
    
    int _viewStartY;
    int _prevViewStartY;
    int _firstLastViewStartY;
    int _exitInfoStartY;
    int _prevExitInfoStartY;
    
    // 상세정보뷰
    UIView *_detailInfoView;
    
    // 환승모달뷰
    
    // 환승역 정보
    NSMutableArray *_translateListArray;
    
    UIView *_translatePopView;
    UIView *_translateModalView;
    UIImageView *_translateModalBg;
    //UILabel *_translateModalLabel;
    UIButton *_cancelBtn;
    
    UIView *_translateCurrentStation;
    UIImageView *_currentStationRadioImg;
    UIImageView *_currentStationLine;
    UILabel *_currentStation;
    
    
    
    UIView *_translateFirstStation;
    UIImageView *_translate1RadioImg;
    UIImageView *_translate1StationLine;
    UILabel *_translate1Station;
    UIButton *_translate1Btn;
    
    UIView *_translateSecondStation;
    UIImageView *_translate2RadioImg;
    UIImageView *_translate2StationLine;
    UILabel *_translate2Station;
    UIButton *_translate2Btn;
    UIImageView *_tUnderLine3;
    
    UIView *_translateThirdStation;
    UIImageView *_translate3RadioImg;
    UIImageView *_translate3StationLine;
    UILabel *_translate3Station;
    UIButton *_translate3Btn;
    
    UIImageView *_tUnderLine4;
    
    // 하단버튼뷰
    UIView *_bottomView;
    
    // 오늘요일은?
    int _today;
    // 평일? 토욜? 주말?
    int _typeDay;
    
    // 현재시간(24시)
    int _currentHour;
    // 현재 분
    int _currentMin;
    
    int _page;
    
    BOOL _isFisrt;
    
    UIButton *_mapBtn;

}
@property (strong, nonatomic) IBOutlet UIButton *popBtn;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;

-(IBAction)popBtnClick:(id)sender;
-(IBAction)mapBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)finishRequestTrafficSubwayDetailRefresh:(id)request;
- (void)finishRequestTrafficSubwayExitway:(id)request;
@end
