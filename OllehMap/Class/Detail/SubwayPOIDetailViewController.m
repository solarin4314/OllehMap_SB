//
//  SubwayPOIDetailViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 7..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "SubwayPOIDetailViewController.h"

@implementation NSString(compare)

-(NSComparisonResult)compareNumberStrings:(NSString *)str
{
    NSNumber * me = [NSNumber numberWithInt:[self intValue]];
    NSNumber * you = [NSNumber numberWithInt:[str intValue]];
    
    return [you compare:me];
}

@end

@interface SubwayPOIDetailViewController ()

@end

@implementation SubwayPOIDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewWillAppear:(BOOL)animated
{
    // 지하철 상세 이동시(스크롤 이동) 지도 갔을 경우 꼬이게 됨(버스정류장도 없앰)
    [_mapBtn setHidden:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initer];
    
    _translateListArray = [[NSMutableArray alloc] init];
    //OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [self saveRecentSearch];
    
    [self drawStart];
    
}
- (void) initer
{
    // 열차시간표/첫차막차/출구정보 라벨뷰
    _timeFirstLastExitLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    
    _timeFisrtLastExitImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_3tab_01.png"]];
    [_timeFisrtLastExitImg setFrame:CGRectMake(0, 0, 320, 36)];
    [_timeFirstLastExitLabelView addSubview:_timeFisrtLastExitImg];
    
    _trainTimeTableLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 106, 36)];
    [_trainTimeTableLabel setText:@"열차시간표"];
    [_trainTimeTableLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_trainTimeTableLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeFirstLastExitLabelView addSubview:_trainTimeTableLabel];
    
    _trainTimeTableBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_trainTimeTableBtn setFrame:CGRectMake(0, 0, 106, 36)];
    [_trainTimeTableBtn setSelected:YES];
    [_trainTimeTableBtn addTarget:self action:@selector(tranTimeTableBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeFirstLastExitLabelView addSubview:_trainTimeTableBtn];
    
    _firstLastLabel = [[UILabel alloc] initWithFrame:CGRectMake(107, 0, 106, 36)];
    [_firstLastLabel setText:@"첫차/막차"];
    [_firstLastLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_firstLastLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeFirstLastExitLabelView addSubview:_firstLastLabel];
    
    _firstLastBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_firstLastBtn setFrame:CGRectMake(107, 0, 106, 36)];
    [_firstLastBtn addTarget:self action:@selector(firstLastBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_firstLastBtn setSelected:YES];
    [_timeFirstLastExitLabelView addSubview:_firstLastBtn];
    
    _exitInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(214, 0, 106, 36)];
    [_exitInfoLabel setText:@"출구정보"];
    [_exitInfoLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_exitInfoLabel setTextAlignment:NSTextAlignmentCenter];
    [_timeFirstLastExitLabelView addSubview:_exitInfoLabel];
    
    _exitInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_exitInfoBtn setFrame:CGRectMake(214, 0, 106, 36)];
    [_exitInfoBtn addTarget:self action:@selector(exitInfoBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_timeFirstLastExitLabelView addSubview:_exitInfoBtn];
    
    // 열차시간표
    _trainTimeTableView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 184)];
    
    _trainTimeTableOptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    [_trainTimeTableView addSubview:_trainTimeTableOptionView];
    
    UILabel *weekLbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 10, 42, 13)];
    [weekLbl setText:@"평일"];
    [weekLbl setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableOptionView addSubview:weekLbl];
    
    _weekdayImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 9, 15, 15)];
    [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_trainTimeTableOptionView addSubview:_weekdayImg];
    
    _weekdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weekdayBtn setFrame:CGRectMake(10, 9, 48, 13)];
    [_weekdayBtn setSelected:YES];
    [_weekdayBtn addTarget:self action:@selector(weekdayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_weekdayBtn addTarget:self action:@selector(weekdayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_weekdayBtn addTarget:self action:@selector(weekBtnTochUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [_trainTimeTableOptionView addSubview:_weekdayBtn];
    
    
    UILabel *satLbl = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 45, 13)];
    [satLbl setText:@"토요일"];
    [satLbl setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableOptionView addSubview:satLbl];
    
    _saturdayImg = [[UIImageView alloc] initWithFrame:CGRectMake(66, 9, 15, 15)];
    [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_trainTimeTableOptionView addSubview:_saturdayImg];
    
    _saturdayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saturdayBtn setFrame:CGRectMake(66, 9, 63, 13)];
    [_saturdayBtn addTarget:self action:@selector(saturdayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_saturdayBtn addTarget:self action:@selector(saturdayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_saturdayBtn addTarget:self action:@selector(weekBtnTochUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [_trainTimeTableOptionView addSubview:_saturdayBtn];
    
    UILabel *sunLbl = [[UILabel alloc] initWithFrame:CGRectMake(152, 10, 42, 13)];
    [sunLbl setText:@"휴일"];
    [sunLbl setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableOptionView addSubview:sunLbl];
    
    _sundayImg = [[UIImageView alloc] initWithFrame:CGRectMake(134, 9, 15, 15)];
    [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_trainTimeTableOptionView addSubview:_sundayImg];
    
    _sundayBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sundayBtn setFrame:CGRectMake(132, 9, 57, 13)];
    [_sundayBtn addTarget:self action:@selector(sundayBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sundayBtn addTarget:self action:@selector(sundayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_sundayBtn addTarget:self action:@selector(weekBtnTochUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [_trainTimeTableOptionView addSubview:_sundayBtn];
    
    UIView *timeTableLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 320, 1)];
    [timeTableLine setBackgroundColor:convertHexToDecimalRGBA(@"dc", @"dc", @"dc", 1)];
    [_trainTimeTableView addSubview:timeTableLine];
    
    _timeRange = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 320, 33)];
    [_timeRange setText:@"05:00~06:00"];
    [_timeRange setFont:[UIFont systemFontOfSize:15]];
    [_timeRange setTextAlignment:NSTextAlignmentCenter];
    [_trainTimeTableView addSubview:_timeRange];
    
    _prevPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_prevPageBtn setFrame:CGRectMake(0, 34, 40, 33)];
    [_prevPageBtn addTarget:self action:@selector(prevPageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_prevPageBtn setImage:[UIImage imageNamed:@"poi_left_arrow.png"] forState:UIControlStateNormal];
    [_trainTimeTableView addSubview:_prevPageBtn];
    
    _nextPageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_nextPageBtn setFrame:CGRectMake(280, 34, 40, 33)];
    [_nextPageBtn addTarget:self action:@selector(nextPageClick:) forControlEvents:UIControlEventTouchUpInside];
    [_nextPageBtn setImage:[UIImage imageNamed:@"poi_right_arrow.png"] forState:UIControlStateNormal];
    [_trainTimeTableView addSubview:_nextPageBtn];
    
    UIView *timeTableLine2 = [[UIView alloc] initWithFrame:CGRectMake(0, 67, 320, 1)];
    [timeTableLine2 setBackgroundColor:convertHexToDecimalRGBA(@"dc", @"dc", @"dc", 1)];
    [_trainTimeTableView addSubview:timeTableLine2];
    
    UIView *directionView = [[UIView alloc] initWithFrame:CGRectMake(0, 68, 320, 33)];
    [_trainTimeTableView addSubview:directionView];
    UIImageView *directionBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_02.png"]];
    [directionView addSubview:directionBg];
    
    _leftDirection = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 33)];
    [_leftDirection setFont:[UIFont systemFontOfSize:14]];
    [_leftDirection setTextAlignment:NSTextAlignmentCenter];
    [directionView addSubview:_leftDirection];
    
    _rightDirection = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 33)];
    [_rightDirection setFont:[UIFont systemFontOfSize:14]];
    [_rightDirection setTextAlignment:NSTextAlignmentCenter];
    [directionView addSubview:_rightDirection];
    
    _trainTimeTableTimeView = [[UIView alloc] init];
    [_trainTimeTableTimeView setFrame:CGRectMake(0, 101, 320, 83)];
    [_trainTimeTableView addSubview:_trainTimeTableTimeView];
    
    _trainTimeTableTimeBG = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_03.png"]];
    [_trainTimeTableTimeBG setFrame:CGRectMake(0, 0, 320, 83)];
    [_trainTimeTableTimeView addSubview:_trainTimeTableTimeBG];
    
    _upperTime = [[UILabel alloc] init];
    [_upperTime setFrame:CGRectMake(10, 9, 35, 13)];
    [_upperTime setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableTimeView addSubview:_upperTime];
    
    _upperDest = [[UILabel alloc] init];
    [_upperDest setFrame:CGRectMake(50, 9, 100, 13)];
    [_upperDest setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableTimeView addSubview:_upperDest];
    
    _downerTime = [[UILabel alloc] init];
    [_downerTime setFrame:CGRectMake(170, 9, 35, 13)];
    [_downerTime setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableTimeView addSubview:_downerTime];
    
    _downerDest = [[UILabel alloc] init];
    [_downerDest setFrame:CGRectMake(210, 9, 100, 13)];
    [_downerDest setFont:[UIFont systemFontOfSize:13]];
    [_trainTimeTableTimeView addSubview:_downerDest];
    
    // 첫차막차뷰
    
    _firstLastView = [[UIView alloc] init];
    [_firstLastView setFrame:CGRectMake(0, 0, 320, 370)];
    
    UIView *firstLastDayView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    [_firstLastView addSubview:firstLastDayView];
    
    
    UILabel *week2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(28, 10, 42, 13)];
    [week2Lbl setText:@"평일"];
    [week2Lbl setFont:[UIFont systemFontOfSize:13]];
    [firstLastDayView addSubview:week2Lbl];
    
    _weekDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_weekDayImage setFrame:CGRectMake(10, 9, 15, 15)];
    [firstLastDayView addSubview:_weekDayImage];
    
    _weekDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_weekDayButton setFrame:CGRectMake(10, 9, 48, 13)];
    [_weekDayButton addTarget:self action:@selector(weekDayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_weekDayButton addTarget:self action:@selector(weekdayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_weekDayButton addTarget:self action:@selector(firstLastRadioTouchUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [_weekDayButton setSelected:YES];
    [firstLastDayView addSubview:_weekDayButton];
    
    
    UILabel *sat2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(84, 10, 45, 13)];
    [sat2Lbl setText:@"토요일"];
    [sat2Lbl setFont:[UIFont systemFontOfSize:13]];
    [firstLastDayView addSubview:sat2Lbl];
    
    _saturDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturDayImage setFrame:CGRectMake(66, 9, 15, 15)];
    [firstLastDayView addSubview:_saturDayImage];
    
    _saturDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_saturDayButton setFrame:CGRectMake(66, 9, 63, 13)];
    [_saturDayButton addTarget:self action:@selector(saturDatButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_saturDayButton addTarget:self action:@selector(saturdayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_saturDayButton addTarget:self action:@selector(firstLastRadioTouchUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [firstLastDayView addSubview:_saturDayButton];
    
    UILabel *sun2Lbl = [[UILabel alloc] initWithFrame:CGRectMake(152, 10, 42, 13)];
    [sun2Lbl setText:@"휴일"];
    [sun2Lbl setFont:[UIFont systemFontOfSize:13]];
    [firstLastDayView addSubview:sun2Lbl];
    
    _sunDayImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sunDayImage setFrame:CGRectMake(134, 9, 15, 15)];
    [firstLastDayView addSubview:_sunDayImage];
    
    _sunDayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [_sunDayButton setFrame:CGRectMake(132, 9, 57, 13)];
    [_sunDayButton addTarget:self action:@selector(sunDayButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [_sunDayButton addTarget:self action:@selector(sundayBtnHightlight:) forControlEvents:UIControlEventTouchDown];
    [_sunDayButton addTarget:self action:@selector(firstLastRadioTouchUpOutSide:) forControlEvents:UIControlEventTouchUpOutside];
    [firstLastDayView addSubview:_sunDayButton];
    
    // 밑줄필요 firstlastView add
    UIView *firstLastLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 320, 1)];
    [firstLastLine setBackgroundColor:convertHexToDecimalRGBA(@"dc", @"dc", @"dc", 1)];
    [_firstLastView addSubview:firstLastLine];
    
    _upperLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 34, 320, 67)];
    [_firstLastView addSubview:_upperLabelView];
    
    _upperLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    [_upperLabel setBackgroundColor:convertHexToDecimalRGBA(@"e6", @"e6", @"e6", 1)];
    [_upperLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_upperLabel setTextAlignment:NSTextAlignmentCenter];
    [_upperLabelView addSubview:_upperLabel];
    
    // 밑줄필요 upperlabelview add
    UIView *upLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 320, 1)];
    [upLine setBackgroundColor:convertHexToDecimalRGBA(@"dc", @"dc", @"dc", 1)];
    [_upperLabelView addSubview:upLine];
    
    UIImageView *firstLastLblBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_02.png"]];
    [firstLastLblBg setFrame:CGRectMake(0, 34, 320, 33)];
    [_upperLabelView addSubview:firstLastLblBg];
    
    UILabel *firstLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 160, 33)];
    [firstLbl setText:@"첫차"];
    [firstLbl setTextAlignment:NSTextAlignmentCenter];
    [firstLbl setFont:[UIFont systemFontOfSize:15]];
    [_upperLabelView addSubview:firstLbl];
    
    UILabel *lastLbl = [[UILabel alloc] initWithFrame:CGRectMake(160, 34, 160, 33)];
    [lastLbl setText:@"막차"];
    [lastLbl setTextAlignment:NSTextAlignmentCenter];
    [lastLbl setFont:[UIFont systemFontOfSize:15]];
    [_upperLabelView addSubview:lastLbl];
    
    
    _upperView = [[UIView alloc] init];
    [_upperView setFrame:CGRectMake(0, 101, 320, 100)];
    [_firstLastView addSubview:_upperView];
    
    _upperBackGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_03.png"]];
    [_upperBackGround setFrame:CGRectMake(0, 0, 320, 100)];
    [_upperView addSubview:_upperBackGround];
    
    _upperFirstTime = [[UILabel alloc] init];
    [_upperFirstTime setFrame:CGRectMake(10, 9, 35, 13)];
    [_upperFirstTime setFont:[UIFont systemFontOfSize:13]];
    [_upperView addSubview:_upperFirstTime];
    
    _upperFirstDest = [[UILabel alloc] init];
    [_upperFirstDest setFrame:CGRectMake(50, 9, 100, 13)];
    [_upperFirstDest setFont:[UIFont systemFontOfSize:13]];
    [_upperView addSubview:_upperFirstDest];
    
    _upperLastTime = [[UILabel alloc] init];
    [_upperLastTime setFrame:CGRectMake(170, 9, 35, 13)];
    [_upperLastTime setFont:[UIFont systemFontOfSize:13]];
    [_upperView addSubview:_upperLastTime];
    
    _upperLastDest = [[UILabel alloc] init];
    [_upperLastDest setFrame:CGRectMake(210, 9, 100, 13)];
    [_upperLastDest setFont:[UIFont systemFontOfSize:13]];
    [_upperView addSubview:_upperLastDest];
    
    //
    
    _downerLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 201, 320, 67)];
    [_firstLastView addSubview:_downerLabelView];
    
    _downerLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 33)];
    [_downerLabel setBackgroundColor:convertHexToDecimalRGBA(@"e6", @"e6", @"e6", 1)];
    [_downerLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [_downerLabel setTextAlignment:NSTextAlignmentCenter];
    [_downerLabelView addSubview:_downerLabel];
    
    // 밑줄필요 downerLabelView add
    UIView *downLine = [[UIView alloc] initWithFrame:CGRectMake(0, 33, 320, 1)];
    [downLine setBackgroundColor:convertHexToDecimalRGBA(@"dc", @"dc", @"dc", 1)];
    [_downerLabelView addSubview:downLine];
    
    UIImageView *firstLastLblBg2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_02.png"]];
    [firstLastLblBg2 setFrame:CGRectMake(0, 34, 320, 33)];
    [_downerLabelView addSubview:firstLastLblBg2];
    
    UILabel *firstLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(0, 34, 160, 33)];
    [firstLbl2 setText:@"첫차"];
    [firstLbl2 setTextAlignment:NSTextAlignmentCenter];
    [firstLbl2 setFont:[UIFont systemFontOfSize:15]];
    [_downerLabelView addSubview:firstLbl2];
    
    UILabel *lastLbl2 = [[UILabel alloc] initWithFrame:CGRectMake(160, 34, 160, 33)];
    [lastLbl2 setText:@"막차"];
    [lastLbl2 setTextAlignment:NSTextAlignmentCenter];
    [lastLbl2 setFont:[UIFont systemFontOfSize:15]];
    [_downerLabelView addSubview:lastLbl2];
    
    
    _downerView = [[UIView alloc] init];
    [_downerView setFrame:CGRectMake(0, 268, 320, 100)];
    [_firstLastView addSubview:_downerView];
    
    _downerBackGround = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"subway_bg_03.png"]];
    [_downerBackGround setFrame:CGRectMake(0, 0, 320, 100)];
    [_downerView addSubview:_downerBackGround];
    
    _downerFirstTime = [[UILabel alloc] init];
    [_downerFirstTime setFrame:CGRectMake(10, 9, 35, 13)];
    [_downerFirstTime setFont:[UIFont systemFontOfSize:13]];
    [_downerView addSubview:_downerFirstTime];
    
    _downerFirstDest = [[UILabel alloc] init];
    [_downerFirstDest setFrame:CGRectMake(50, 9, 100, 13)];
    [_downerFirstDest setFont:[UIFont systemFontOfSize:13]];
    [_downerView addSubview:_downerFirstDest];
    
    _downerLastTime = [[UILabel alloc] init];
    [_downerLastTime setFrame:CGRectMake(170, 9, 35, 13)];
    [_downerLastTime setFont:[UIFont systemFontOfSize:13]];
    [_downerView addSubview:_downerLastTime];
    
    _downerLastDest = [[UILabel alloc] init];
    [_downerLastDest setFrame:CGRectMake(210, 9, 100, 13)];
    [_downerLastDest setFont:[UIFont systemFontOfSize:13]];
    [_downerView addSubview:_downerLastDest];
    
    // 출구정보
    _exitInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 302, 290)];
    
    // 상세정보뷰
    _detailInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 273)];
    
    // 하단버튼
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    
    UIButton *favoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoBtn setImage:[UIImage imageNamed:@"poi_btn_01.png"] forState:UIControlStateNormal];
    [favoBtn setFrame:CGRectMake(0, 0, 160, 37)];
    [favoBtn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:favoBtn];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setImage:[UIImage imageNamed:@"poi_btn_02.png"] forState:UIControlStateNormal];
    [modifyBtn setFrame:CGRectMake(160, 0, 160, 37)];
    [modifyBtn addTarget:self action:@selector(infoModifyAskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:modifyBtn];
    
    // 환승선택뷰
    _translatePopView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    [_translatePopView setBackgroundColor:convertHexToDecimalRGBA(@"00", @"00", @"00", 0.7f)];
    
    _translateModalView = [[UIView alloc] initWithFrame:CGRectMake(116/2, 248/2, 410/2, 458/2)];
    [_translatePopView addSubview:_translateModalView];
    
    _translateModalBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 410/2, 458/2)];
    [_translateModalBg setImage:[UIImage imageNamed:@"popup_bg.png"]];
    [_translateModalView addSubview:_translateModalBg];
    
    // 타이틀 렌더링
    {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 410/2, 62/2)];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(4/2 + 20/2, 16/2, 310/2, 16)];
        [titleLbl setFont:[UIFont systemFontOfSize:16]];
        [titleLbl setText:@"환승역 선택"];
        [titleLbl setTextColor:convertHexToDecimalRGBA(@"ff", @"51", @"5e", 1.0)];
        [titleView addSubview:titleLbl];
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(4/2 + 348/2, 10/2, 40/2, 40/2)];
        [titleBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
        [titleView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *titleUnderLine = [[UIImageView alloc] initWithFrame:CGRectMake(4/2, 60/2, 402/2, 2/2)];
        [titleUnderLine setImage:[UIImage imageNamed:@"popup_title_line.png"]];
        [titleView addSubview:titleUnderLine];
        
        [_translateModalView addSubview:titleView];
    }

    
    _translateCurrentStation = [[UIView alloc] initWithFrame:CGRectMake(4/2, 61/2, 402/2, 90/2)];
    [_translateCurrentStation setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0)];
    [_translateModalView addSubview:_translateCurrentStation];
    
    _currentStationRadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [_translateCurrentStation addSubview:_currentStationRadioImg];
    
    _currentStationLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 14, 29, 18)];
    [_translateCurrentStation addSubview:_currentStationLine];
    
    _currentStation = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 137, 15)];
    [_currentStation setFont:[UIFont systemFontOfSize:15]];
    [_currentStation setBackgroundColor:[UIColor clearColor]];
    [_translateCurrentStation addSubview:_currentStation];
    
    
    UIImageView *tUnderLine1 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_list_line.png"]];
    [tUnderLine1 setFrame:CGRectMake(4/2, 62/2 + 90/2, 402/2, 4/2)];
    [_translateModalView addSubview:tUnderLine1];
    
    
    
    _translateFirstStation = [[UIView alloc] initWithFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2, 402/2, 90/2)];
    [_translateFirstStation setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0)];
    
    [_translateModalView addSubview:_translateFirstStation];
    
    // 버튼
    _translate1Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_translate1Btn setFrame:CGRectMake(0, 0, 402/2, 90/2)];
    [_translate1Btn addTarget:self action:@selector(translate1BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_translate1Btn addTarget:self action:@selector(translate1BtnClickUp:) forControlEvents:UIControlEventTouchDown];
    [_translate1Btn addTarget:self action:@selector(translate1BtnClickDown:) forControlEvents:UIControlEventTouchUpOutside];
    [_translateFirstStation addSubview:_translate1Btn];
    
    _translate1RadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [_translateFirstStation addSubview:_translate1RadioImg];
    
    _translate1StationLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 14, 29, 18)];
    [_translateFirstStation addSubview:_translate1StationLine];
    
    _translate1Station = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 137, 15)];
    [_translate1Station setFont:[UIFont systemFontOfSize:15]];
    [_translate1Station setBackgroundColor:[UIColor clearColor]];
    [_translateFirstStation addSubview:_translate1Station];
    
    
    UIImageView *tUnderLine2 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_list_line.png"]];
    [tUnderLine2 setFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2 + 90/2, 402/2, 4/2)];
    [_translateModalView addSubview:tUnderLine2];
    
    
    _translateSecondStation = [[UIView alloc] initWithFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2 + 90/2 + 4/2, 402/2, 90/2)];
    [_translateSecondStation setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0)];
    [_translateModalView addSubview:_translateSecondStation];
    
    // 버튼
    _translate2Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_translate2Btn setFrame:CGRectMake(0, 0, 402/2, 90/2)];
    [_translate2Btn addTarget:self action:@selector(translate2BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_translate2Btn addTarget:self action:@selector(translate2BtnClickUp:) forControlEvents:UIControlEventTouchDown];
    [_translate2Btn addTarget:self action:@selector(translate2BtnClickDown:) forControlEvents:UIControlEventTouchUpOutside];
    [_translateSecondStation addSubview:_translate2Btn];
    
    _translate2RadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [_translateSecondStation addSubview:_translate2RadioImg];
    
    _translate2StationLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 14, 29, 18)];
    [_translateSecondStation addSubview:_translate2StationLine];
    
    _translate2Station = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 137, 15)];
    [_translate2Station setFont:[UIFont systemFontOfSize:15]];
    [_translate2Station setBackgroundColor:[UIColor clearColor]];
    [_translateSecondStation addSubview:_translate2Station];
    
    _tUnderLine3 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_list_line.png"]];
    [_tUnderLine3 setFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2 + 90/2 + 4/2 + 90/2, 402/2, 4/2)];
    [_translateModalView addSubview:_tUnderLine3];
    
    
    _translateThirdStation = [[UIView alloc] initWithFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2 + 90/2 + 4/2 + 90/2 + 4/2, 402/2, 90/2)];
    [_translateThirdStation setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0)];
    [_translateModalView addSubview:_translateThirdStation];
    
    
    // 버튼
    _translate3Btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_translate3Btn setFrame:CGRectMake(0, 0, 402/2, 90/2)];
    [_translate3Btn addTarget:self action:@selector(translate3BtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_translate3Btn addTarget:self action:@selector(translate3BtnClickUp:) forControlEvents:UIControlEventTouchDown];
    [_translate3Btn addTarget:self action:@selector(translate3BtnClickDown:) forControlEvents:UIControlEventTouchUpOutside];
    [_translateThirdStation addSubview:_translate3Btn];
    
    _translate3RadioImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
    [_translateThirdStation addSubview:_translate3RadioImg];
    
    _translate3StationLine = [[UIImageView alloc] initWithFrame:CGRectMake(45, 14, 29, 18)];
    [_translateThirdStation addSubview:_translate3StationLine];
    
    _translate3Station = [[UILabel alloc] initWithFrame:CGRectMake(80, 15, 137, 15)];
    [_translate3Station setFont:[UIFont systemFontOfSize:15]];
    [_translate3Station setBackgroundColor:[UIColor clearColor]];
    [_translateThirdStation addSubview:_translate3Station];
    
    _tUnderLine4 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"popup_list_line.png"]];
    [_tUnderLine4 setFrame:CGRectMake(4/2, 62/2 + 90/2 + 4/2 + 90/2 + 4/2 + 90/2 + 4/2 + 90/2, 402/2, 4/2)];
    [_translateModalView addSubview:_tUnderLine4];
    
    
    _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_cancelBtn setFrame:CGRectMake(88, 58, 70, 31)];
    [_cancelBtn setImage:[UIImage imageNamed:@"popup_btn_cancel_default.png"] forState:UIControlStateNormal];
    [_cancelBtn setImage:[UIImage imageNamed:@"popup_btn_cancel_pressed.png"] forState:UIControlStateHighlighted];
    [_cancelBtn addTarget:self action:@selector(cancelBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_translateModalView addSubview:_cancelBtn];
    
    
    
    
    
}
- (void) saveRecentSearch
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 최근리스트 저장
    
    NSMutableDictionary *subwayPOIDic = [NSMutableDictionary dictionary];
    
    Coord subCrd;
    
    subCrd = CoordMake([[oms.subwayDetailDictionary objectForKeyGC:@"SST_X"] doubleValue], [[oms.subwayDetailDictionary objectForKeyGC:@"SST_Y"] doubleValue]);
    
    double xx = subCrd.x;
    double yy = subCrd.y;
    
    //NSString *didCode = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellDidCode"];
    
    @try
    {
        [subwayPOIDic setObject:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"] forKey:@"NAME"];
        [subwayPOIDic setObject:@"대중교통 > 지하철" forKey:@"CLASSIFY"];
        [subwayPOIDic setValue:[NSNumber numberWithDouble:xx] forKey:@"X"];
        [subwayPOIDic setValue:[NSNumber numberWithDouble:yy] forKey:@"Y"];
        [subwayPOIDic setObject:@"TR" forKey:@"TYPE"];
        [subwayPOIDic setObject:[oms.subwayDetailDictionary objectForKeyGC:@"STID"] forKey:@"ID"];
        
        [subwayPOIDic setObject:[oms.subwayDetailDictionary objectForKeyGC:@"SST_TEL"] forKey:@"TEL"];
        [subwayPOIDic setObject:[oms.subwayDetailDictionary objectForKeyGC:@"SST_ADDRESS"] forKey:@"ADDR"];
        [subwayPOIDic setObject:[NSNumber numberWithInt:Favorite_IconType_Subway] forKey:@"ICONTYPE"];
        
        int lineNum = [[oms.subwayDetailDictionary objectForKeyGC:@"LANEID"] intValue];
        
        [subwayPOIDic setObject:[self getSubwayLineString:lineNum] forKey:@"SUBNAME"];
        
        [oms addRecentSearch:subwayPOIDic];
        
    }
    @catch (NSException *exception)
    {
        [OMMessageBox showAlertMessage:@"" :[NSString stringWithFormat:@"%@", exception]];
        
    }
}

- (void) drawStart
{
    [[OllehMapStatus sharedOllehMapStatus].subwayExitDictionary removeAllObjects];
    _viewStartY = 0;
    _addViewNum = 0;
    _isFisrt = FALSE;
    paging = 3;
    _pControl = [[UIPageControl alloc] init];
    
    // 오늘날짜구하기 i=1 일요일 i=2 월요일....
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    NSDate *date = [NSDate date];
    NSDateComponents *comWeekday = [gregorian components:NSCalendarUnitWeekday fromDate:date];
    _today = (int)[comWeekday weekday];
    
    if(_today == 1)
    {
        // 일욜
        _typeDay = 3;
    }
    else if (_today == 7)
    {
        // 토욜
        _typeDay = 2;
    }
    else
    {
        // 평일
        _typeDay = 1;
    }
    
    // 현재시간, 분 구하기
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"HH"];
    _currentHour = [[dateFormatter stringFromDate:date] intValue];
    
    [dateFormatter setDateFormat:@"mm"];
    _currentMin = [[dateFormatter stringFromDate:date] intValue];
    
    
    if(_currentHour == 0)
    {
        _page = 24;
    }
    else {
        // 페이지는 1부터가 아닌 현재시간페이지로
        _page = _currentHour;
    }
    
    
    NSLog(@"What Time is it now? %d:%d", _currentHour, _currentMin);
    NSLog(@"페이지는? %d", _page);
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [self drawTopView];
    
    NSString *stationId = [oms.subwayDetailDictionary objectForKeyGC:@"STID"];
    
    [[ServerConnector sharedServerConnection] requestTrafficSubwayTime:self action:@selector(finishRequestSubwayTime:) STId:(NSString *)stationId DayType:0];
    
}
- (void) drawTopView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int topViewHeight = 87;
    
    int total = 0;
    
    _smallScroll = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, 320, topViewHeight)];
    [_smallScroll setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    [_smallScroll setShowsHorizontalScrollIndicator:NO];
    [_smallScroll setContentOffset:CGPointMake(320, 0)];
    
    //탑뷰
    _subTopView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH * paging, topViewHeight)];
    [_subTopView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    // 현재지하철
    // 지하철배경 이미지
    NSString *lineNum = [oms.subwayDetailDictionary objectForKeyGC:@"LANEID"];
    
    // 지하철 호선 이미지
    // 지하철이미지너비는 21 고정값(아래 조건문에 따라 이미지 너비가 달라짐 이미지크기는 엑셀파일 참조)
    int lineImgWidth = 21;
    // 연동규격서 156페이지....참조........는 개뿔
    NSString *stationBgImgStr = nil;
    NSString *stationLineImgStr = nil;
    
    if([lineNum isEqualToString:@"1"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_01.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub01.png"];
        
    }
    else if([lineNum isEqualToString:@"2"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_02.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub02.png"];
    }
    else if([lineNum isEqualToString:@"3"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_03.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub03.png"];
        
    }
    else if([lineNum isEqualToString:@"4"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_04.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub04.png"];
    }
    else if([lineNum isEqualToString:@"5"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_05.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub05.png"];
    }
    else if([lineNum isEqualToString:@"6"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_06.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub06.png"];
    }
    else if([lineNum isEqualToString:@"7"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_07.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub07.png"];
    }
    else if([lineNum isEqualToString:@"8"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_08.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub08.png"];
    }
    else if([lineNum isEqualToString:@"9"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_09.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub09.png"];
    }
    // 분당선
    else if([lineNum isEqualToString:@"100"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_10.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub10.png"];
        lineImgWidth = 38;
        
    }
    // 신분당선
    else if([lineNum isEqualToString:@"109"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_11.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub11.png"];
        lineImgWidth = 49;
    }
    else if([lineNum isEqualToString:@"103"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_12.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub12.png"];
        lineImgWidth = 38;
    }
    else if([lineNum isEqualToString:@"101"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_13.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub13.png"];
        lineImgWidth = 38;
    }
    else if([lineNum isEqualToString:@"21"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_14.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub14.png"];
    }
    else if([lineNum isEqualToString:@"104"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_15.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub15.png"];
        lineImgWidth = 38;
    }
    // 용인경전철
    else if ([lineNum isEqualToString:@"107"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_20.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub20.png"];
        lineImgWidth = 48;
    }
    // 경춘선
    else if([lineNum isEqualToString:@"108"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_16.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub16.png"];
        lineImgWidth = 38;
    }
    
    else if([lineNum isEqualToString:@"71"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_busan_01.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_busan_01.png"];
    }
    else if([lineNum isEqualToString:@"72"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_busan_02.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_busan_02.png"];
    }
    else if([lineNum isEqualToString:@"73"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_busan_03.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_busan_03.png"];
    }
    // 부산 4호선
    else if([lineNum isEqualToString:@"74"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_busan_04.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_busan_04.png"];
    }
    
    // 부산김해 경전철
    else if([lineNum isEqualToString:@"79"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_busan_05.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_busan_05.png"];
        lineImgWidth = 48;
    }
    
    else if([lineNum isEqualToString:@"41"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_daegu_01.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_daegu_01.png"];
    }
    else if([lineNum isEqualToString:@"42"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_daegu_02.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_daegu_02.png"];
    }
    // 대전1호선
    else if([lineNum isEqualToString:@"31"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_daejeon_01.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_daejeon_01.png"];
    }
    // 광주1호선
    else if([lineNum isEqualToString:@"51"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_gwangju_01.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub_gwangju_01.png"];
    }
    // 수인선
    else if([lineNum isEqualToString:@"111"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_17.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub17.png"];
        lineImgWidth = 38;
    }
    // 의정부경전철
    else if([lineNum isEqualToString:@"110"])
    {
        stationBgImgStr = [NSString stringWithFormat:@"subway_18.png"];
        stationLineImgStr = [NSString stringWithFormat:@"sub18.png"];
        lineImgWidth = 38;
    }
    
    //[stationBgImg setImage:[NSString stringWithFormat:@"%@", stationBgImgStr]];
    for (int i = 0; i < paging; i++)
    {
        CGRect stationBgImgFrame = CGRectMake(total, 15, 320, 57);
        UIImageView *stationBgImg = [[UIImageView alloc] initWithFrame:stationBgImgFrame];
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%@", stationBgImgStr]];
        stationBgImg.image = image;
        stationBgImg.contentMode = UIViewContentModeCenter;
        [_subTopView addSubview:stationBgImg];
        
        total = total + 320;
    }
    
    // 이전지하철
    NSString *prelineNum = stringValueOfDictionary(oms.subwayDetailDictionary, @"PRENAME1");
    UIImageView *preStationLineImg = [[UIImageView alloc] init];
    [preStationLineImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", stationLineImgStr]]];
    UILabel *preStationName = [[UILabel alloc] init];
    [preStationName setText:prelineNum];
    [preStationName setFont:[UIFont boldSystemFontOfSize:13]];
    CGSize preName = [preStationName.text sizeWithFont:preStationName.font];
    
    // 다음지하철
    NSString *nextlineNum = stringValueOfDictionary(oms.subwayDetailDictionary, @"NEXTNAME1");
    UIImageView *nextStationLineImg = [[UIImageView alloc] init];
    [nextStationLineImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", stationLineImgStr]]];
    UILabel *nextStationName = [[UILabel alloc] init];
    [nextStationName setText:nextlineNum];
    [nextStationName setFont:[UIFont boldSystemFontOfSize:13]];
    CGSize nexName = [nextStationName.text sizeWithFont:nextStationName.font];
    
    // 지하철이름
    NSString *sName = [oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"];
    UIImageView *stationLineImg = [[UIImageView alloc] init];
    [stationLineImg setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", stationLineImgStr]]];
    UILabel *stationname = [[UILabel alloc] init];
    [stationname setText:sName];
    [stationname setFont:[UIFont boldSystemFontOfSize:13]];
    
    CGSize ssName = [stationname.text sizeWithFont:stationname.font];
    
    // 이미지와 텍스트 정렬(이미지와 텍스트를 한 덩어리로)
    // 이전
    int preTwoWidth = lineImgWidth + 5 + preName.width;
    int preTwoX = 160 - (preTwoWidth / 2);
    int preBasesNameX = preTwoX + lineImgWidth + 5;
    int preBasesImgX = preTwoX;
    
    // 현재
    // 두개의 너비 = 이미지너비 + 간격 + 텍스트너비
    int twoWidth = lineImgWidth + 5 + ssName.width;
    // 두개의 X좌표 = 가운데(160) - (두개의너비 / 2)
    int twoX = 160 - (twoWidth / 2);
    
    // 텍스트X좌표 = 두개의 X좌표 + 이미지너비 + 간격
    int basesNameX = twoX + lineImgWidth + 5;
    // 이미지X좌표 = 두개의 X좌표
    int basesImgX = twoX;
    
    // 다음
    int nextTwoWidth = lineImgWidth + 5 + nexName.width;
    int nextTwoX = 160 - (nextTwoWidth / 2);
    int nextBasesNameX = nextTwoX + lineImgWidth + 5;
    int nextBasesImgX = nextTwoX;
    
    
    // 현재 지하철 노선 중에는 디자인 가이드에 정해준 범위에 벗어나는것이 없음
    
    // 만약 twoEndX가 235(디자인가이드)를 넘는다면, 따로 처리 해줘야됨
    // 이전
    [preStationName setFrame:CGRectMake(preBasesNameX, 37, preName.width, 14)];
    [preStationLineImg setFrame:CGRectMake(preBasesImgX, 33, lineImgWidth, 21)];
    
    if([prelineNum isEqualToString:@""])
        [preStationLineImg setHidden:YES];
    // 현재
    [stationname setFrame:CGRectMake(basesNameX + X_WIDTH, 37, ssName.width, 14)];
    [stationLineImg setFrame:CGRectMake(basesImgX + X_WIDTH, 33, lineImgWidth, 21)];
    // 다음
    [nextStationName setFrame:CGRectMake(nextBasesNameX + (X_WIDTH) *2, 37, nexName.width, 14)];
    [nextStationLineImg setFrame:CGRectMake(nextBasesImgX + (X_WIDTH) *2, 33, lineImgWidth, 21)];
    if([nextlineNum isEqualToString:@""])
        [nextStationLineImg setHidden:YES];
    
    [_subTopView addSubview:preStationLineImg];
    [_subTopView addSubview:preStationName];
    [_subTopView addSubview:stationname];
    [_subTopView addSubview:stationLineImg];
    [_subTopView addSubview:nextStationLineImg];
    [_subTopView addSubview:nextStationName];
    
    // 이전버튼
    UIButton *prevBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [prevBtn setFrame:CGRectMake(4 + X_WIDTH, 38, 66, 12)];
    [prevBtn setBackgroundImage:[UIImage imageNamed:@"poi_btn_left_arrow.png"] forState:UIControlStateNormal];
    [prevBtn addTarget:self action:@selector(prevBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 이전역라벨
    UILabel *prevName = [[UILabel alloc] initWithFrame:CGRectMake(15 + X_WIDTH, 38, 55, 13)];
    [prevName setText:[oms.subwayDetailDictionary objectForKeyGC:@"PRENAME1"]];
    [prevName setFont:[UIFont systemFontOfSize:13]];
    [prevName setTextColor:[UIColor whiteColor]];
    [prevName setBackgroundColor:[UIColor clearColor]];
    if([oms.subwayDetailDictionary objectForKeyGC:@"PRENAME1"] == nil)
    {
        [prevBtn setHidden:YES];
        [prevName setHidden:YES];
        
    }
    else
    {
        [prevBtn setHidden:NO];
        [prevName setHidden:NO];
    }
    
    [_subTopView addSubview:prevBtn];
    [_subTopView addSubview:prevName];
    
    // 다음 버튼
    UIButton *nextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [nextBtn setFrame:CGRectMake(250 + X_WIDTH, 38, 66, 12)];
    [nextBtn setBackgroundImage:[UIImage imageNamed:@"poi_btn_right_arrow.png"] forState:UIControlStateNormal];
    [nextBtn addTarget:self action:@selector(nextBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    // 다음역라벨
    UILabel *nextName = [[UILabel alloc] initWithFrame:CGRectMake(250 + X_WIDTH, 38, 55, 13)];
    [nextName setText:[oms.subwayDetailDictionary objectForKeyGC:@"NEXTNAME1"]];
    [nextName setFont:[UIFont systemFontOfSize:13]];
    [nextName setTextColor:[UIColor whiteColor]];
    [nextName setBackgroundColor:[UIColor clearColor]];
    [nextName setTextAlignment:NSTextAlignmentRight];
    if([oms.subwayDetailDictionary objectForKeyGC:@"NEXTNAME1"] == nil)
    {
        [nextBtn setHidden:YES];
        [nextName setHidden:YES];
    }
    else
    {
        [nextBtn setHidden:NO];
        [nextName setHidden:NO];
        
    }
    
    [_subTopView addSubview:nextBtn];
    [_subTopView addSubview:nextName];
    
    // 환승역버튼
    
    UIButton *transBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [transBtn setFrame:CGRectMake(253 + X_WIDTH, 4, 60, 21)];
    [transBtn setImage:[UIImage imageNamed:@"poi_btn_transfer.png"] forState:UIControlStateNormal];
    [transBtn addTarget:self action:@selector(translateBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_subTopView addSubview:transBtn];
    
    if([[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID1"] isEqualToString:@"0"] && [[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID2"] isEqualToString:@"0"] && [[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID3"] isEqualToString:@"0"])
    {
        [transBtn setHidden:YES];
    }
    
    // 이전역 미리보기
    // 이전애로우
    UIImageView *scrollPrevImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_left_arrow.png"]];
    [scrollPrevImg setFrame:CGRectMake(4+ (X_WIDTH * 2), 38, 66, 12)];
    
    // 이전역라벨
    UILabel *scrollprevName = [[UILabel alloc] initWithFrame:CGRectMake(15 + (X_WIDTH * 2), 38, 55, 13)];
    [scrollprevName setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
    [scrollprevName setFont:[UIFont systemFontOfSize:13]];
    [scrollprevName setTextColor:[UIColor whiteColor]];
    [scrollprevName setBackgroundColor:[UIColor clearColor]];
    
    NSLog(@"%@", stringValueOfDictionary(oms.subwayDetailDictionary, @"PRENAME1"));
    NSLog(@"%@", stringValueOfDictionary(oms.subwayDetailDictionary, @"NEXTNAME1"));
    if([stringValueOfDictionary(oms.subwayDetailDictionary, @"NEXTNAME1") isEqualToString:@""])
    {
        [scrollPrevImg setHidden:YES];
        [scrollprevName setHidden:YES];
        
    }
    else
    {
        [scrollPrevImg setHidden:NO];
        [scrollprevName setHidden:NO];
    }
    
    [_subTopView addSubview:scrollPrevImg];
    [_subTopView addSubview:scrollprevName];
    
    // 다음역 미리보기
    // 다음애로우
    UIImageView *scrollNextImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_right_arrow.png"]];
    [scrollNextImg setFrame:CGRectMake(250, 38, 66, 12)];
    
    // 다음역라벨
    UILabel *scrollNextName = [[UILabel alloc] initWithFrame:CGRectMake(250, 38, 55, 13)];
    [scrollNextName setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
    [scrollNextName setFont:[UIFont systemFontOfSize:13]];
    [scrollNextName setTextColor:[UIColor whiteColor]];
    [scrollNextName setTextAlignment:NSTextAlignmentRight];
    [scrollNextName setBackgroundColor:[UIColor clearColor]];
    if([stringValueOfDictionary(oms.subwayDetailDictionary, @"PRENAME1") isEqualToString:@""])
    {
        [scrollNextName setHidden:YES];
        [scrollNextImg setHidden:YES];
        
    }
    else
    {
        [scrollNextName setHidden:NO];
        [scrollNextImg setHidden:NO];
    }
    
    [_subTopView addSubview:scrollNextImg];
    [_subTopView addSubview:scrollNextName];
    
    [_scrollView addSubview:_smallScroll];
    [_smallScroll addSubview:_subTopView];
    [_smallScroll setContentSize:_subTopView.frame.size];
    [_smallScroll setPagingEnabled:YES];
    _smallScroll.delegate = self;
    
    _pControl.currentPage = 1;
    _pControl.numberOfPages = 3;
    [_pControl addTarget:self action:@selector(pageChangeValue:) forControlEvents:UIControlEventValueChanged];
    
    
    
    _viewStartY += topViewHeight;
    
}

- (void) finishRequestSubwayTime:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        NSString *stationId = [[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary objectForKeyGC:@"STID"];
        [[ServerConnector sharedServerConnection] requestTrafficRealtimeSubwayTimeTable:self action:@selector(didfinishRequestSubwayRealTime:) subwayid:stationId];
    }
    else if (  [request finishCode] == OMSRFinishCode_Error_Parser )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithExceptionParser", @"")];
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}

- (void) didfinishRequestSubwayRealTime:(ServerRequester*)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        
        int list2ViewHeight = 56;
        
        NSMutableArray *arr = (NSMutableArray *)request.userObject;
        
        NSMutableDictionary *dict = [arr objectAtIndexGC:0];
        NSDictionary *dict2 = [arr objectAtIndexGC:1];
        
        UIView *list2View = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, list2ViewHeight)];
        
        UIImageView *list2Bg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, X_WIDTH, list2ViewHeight)];
        [list2Bg setImage:[UIImage imageNamed:@"subway_bg_01.png"]];
        [list2View addSubview:list2Bg];
        
        // 폰트
        UIFont *lblFont = [UIFont systemFontOfSize:13];
        UIColor *timeColor = [UIColor colorWithRed:242.0/255.0 green:52.0/255.0 blue:113.0/255.0 alpha:1];
        
        NSArray *times = [dict objectForKeyGC:@"times"];
        
        if([dict objectForKeyGC:@"times"] && times.count > 0)
        {
            
            NSString *preDest1 = [NSString stringWithFormat:@"%@행", [[[dict objectForKeyGC:@"times"] objectAtIndexGC:0] objectForKeyGC:@"lane"]];
            NSString  *preTime1 = [NSString stringWithFormat:@"%@", [[[dict objectForKeyGC:@"times"] objectAtIndexGC:0] objectForKeyGC:@"time"]];
            
            NSString *preDest2 = @"";
            NSString *preTime2 = @"";
            if(times.count > 1)
            {
                preDest2 = [NSString stringWithFormat:@"%@행", [[[dict objectForKeyGC:@"times"] objectAtIndexGC:1] objectForKeyGC:@"lane"]];
                preTime2 = [NSString stringWithFormat:@"%@", [[[dict objectForKeyGC:@"times"] objectAtIndexGC:1] objectForKeyGC:@"time"]];
            }
            // prev라벨
            UILabel *prevFirstDest = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 99, 13)];
            [prevFirstDest setFont:lblFont];
            [prevFirstDest setBackgroundColor:[UIColor clearColor]];
            [prevFirstDest setText:preDest1];
            
            UILabel *prevFirstTime = [[UILabel alloc] initWithFrame:CGRectMake(109, 10, 41, 13)];
            [prevFirstTime setFont:lblFont];
            [prevFirstTime setBackgroundColor:[UIColor clearColor]];
            [prevFirstTime setTextColor:timeColor];
            [prevFirstTime setTextAlignment:NSTextAlignmentRight];
            [prevFirstTime setText:preTime1];
            
            UILabel *prevSecondDest = [[UILabel alloc] initWithFrame:CGRectMake(10, 32, 99, 13)];
            [prevSecondDest setFont:lblFont];
            [prevSecondDest setBackgroundColor:[UIColor clearColor]];
            [prevSecondDest setText:preDest2];
            
            UILabel *prevSecondTime = [[UILabel alloc] initWithFrame:CGRectMake(109, 32, 41, 13)];
            [prevSecondTime setFont:lblFont];
            [prevSecondTime setBackgroundColor:[UIColor clearColor]];
            [prevSecondTime setTextColor:timeColor];
            [prevSecondTime setTextAlignment:NSTextAlignmentRight];
            [prevSecondTime setText:preTime2];
            
            [list2View addSubview:prevFirstDest];
            [list2View addSubview:prevFirstTime];
            [list2View addSubview:prevSecondDest];
            [list2View addSubview:prevSecondTime];
            
        }
        
        
        // next라벨
        
        NSArray *times2 = [dict2 objectForKeyGC:@"times"];
        if([dict2 objectForKeyGC:@"times"] && times2.count > 0)
        {
            NSString *nextDest1 = [NSString stringWithFormat:@"%@행", [[[dict2 objectForKeyGC:@"times"] objectAtIndexGC:0] objectForKeyGC:@"lane"]];
            NSString *nextTime1 = [NSString stringWithFormat:@"%@", [[[dict2 objectForKeyGC:@"times"] objectAtIndexGC:0] objectForKeyGC:@"time"]];
            
            NSString *nextDest2 = @"";
            NSString *nextTime2 = @"";
            if(times2.count > 1)
            {
                nextDest2 = [NSString stringWithFormat:@"%@행", [[[dict2 objectForKeyGC:@"times"] objectAtIndexGC:1] objectForKeyGC:@"lane"]];
                nextTime2 = [NSString stringWithFormat:@"%@", [[[dict2 objectForKeyGC:@"times"] objectAtIndexGC:1] objectForKeyGC:@"time"]];
            }
            
            UILabel *nextFirstDest = [[UILabel alloc] initWithFrame:CGRectMake(170, 10, 99, 13)];
            [nextFirstDest setFont:lblFont];
            [nextFirstDest setBackgroundColor:[UIColor clearColor]];
            [nextFirstDest setText:nextDest1];
            
            UILabel *nextFirstTime = [[UILabel alloc] initWithFrame:CGRectMake(269, 10, 40, 13)];
            [nextFirstTime setFont:lblFont];
            [nextFirstTime setBackgroundColor:[UIColor clearColor]];
            [nextFirstTime setTextColor:timeColor];
            [nextFirstTime setTextAlignment:NSTextAlignmentRight];
            [nextFirstTime setText:nextTime1];
            
            UILabel *nextSecondDest = [[UILabel alloc] initWithFrame:CGRectMake(170, 32, 99, 13)];
            [nextSecondDest setFont:lblFont];
            [nextSecondDest setBackgroundColor:[UIColor clearColor]];
            [nextSecondDest setText:nextDest2];
            
            UILabel *nextSecondTime = [[UILabel alloc] initWithFrame:CGRectMake(269, 32, 40, 13)];
            [nextSecondTime setFont:lblFont];
            [nextSecondTime setBackgroundColor:[UIColor clearColor]];
            [nextSecondTime setTextColor:timeColor];
            [nextSecondTime setTextAlignment:NSTextAlignmentRight];
            [nextSecondTime setText:nextTime2];
            
            [list2View addSubview:nextFirstDest];
            [list2View addSubview:nextFirstTime];
            [list2View addSubview:nextSecondDest];
            [list2View addSubview:nextSecondTime];
            
        }
        
        [_scrollView addSubview:list2View];
        
        _viewStartY += list2ViewHeight;
        
        [self drawTelePhoneView];
    }
}
- (void) drawTelePhoneView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int telViewHeight = 40;
    
    UIView *telView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, telViewHeight)];
    
    // 버튼
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(X_VALUE, 0, X_WIDTH, telViewHeight)];
    [button setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goTelePhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [telView addSubview:button];
    
    // 전화이미지
    UIImageView *telImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 20, 20)];
    [telImg setImage:[UIImage imageNamed:@"view_list_b_call.png"]];
    [telView addSubview:telImg];
    
    
    // 전화번호라벨
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 13, 260, 15)];
    [telLabel setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_TEL"]];
    [telLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [telLabel setBackgroundColor:[UIColor clearColor]];
    [telLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [telView addSubview:telLabel];
    
    
    // 애로우버튼이미지
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(303, 14, 7, 12)];
    [arrowImg setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [telView addSubview:arrowImg];
    
    
    // 전화번호가 없으면 히든
    if([oms.subwayDetailDictionary objectForKeyGC:@"SST_TEL"] == nil)
    {
        [telView setHidden:YES];
        
        [self drawBtnView];
    }
    else {
        [_scrollView addSubview:telView];
        
        _viewStartY += telViewHeight;
        [self drawUnderLine2];
    }
    
    
    
}
- (void) drawUnderLine2
{
    
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 1)];
    [underLine2 setImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    
    [_scrollView addSubview:underLine2];
    
    _viewStartY += 1;
    
    [self drawBtnView];
}

- (void) drawBtnView
{
    int btnViewHeight = 56;
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY, 320, btnViewHeight)];
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, btnViewHeight)];
    
    [btnBg setImage:[UIImage imageNamed:@"poi_list_menu_bg.png"]];
    
    [btnView addSubview:btnBg];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(10, 9, 81, 37);
    
    [startBtn setImage:[UIImage imageNamed:@"poi_list_btn_start.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:startBtn];
    
    UIButton *destBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    destBtn.frame = CGRectMake(96, 9, 81, 37);
    
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop.png"] forState:UIControlStateNormal];
    [destBtn addTarget:self action:@selector(destBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:destBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(182, 9, 61, 37);
    
    [shareBtn setImage:[UIImage imageNamed:@"poi_list_btn_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:shareBtn];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.frame = CGRectMake(248, 9, 61, 37);
    
    [naviBtn setImage:[UIImage imageNamed:@"poi_list_btn_navi.png"] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(subNaviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:naviBtn];
    
    
    [_scrollView addSubview:btnView];
    _viewStartY += btnViewHeight;
    
    
    [self drawTimeFirstLastExitView];
    
}
- (void) drawTimeFirstLastExitView
{
    if(_addViewNum == 0)
    {
        [_timeFirstLastExitLabelView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _timeFirstLastExitLabelView.frame.size.height)];
        [_scrollView addSubview:_timeFirstLastExitLabelView];
        
        _viewStartY = _viewStartY + _timeFirstLastExitLabelView.frame.size.height;
        
        // 값을 보관해놓음
        _prevViewStartY = _viewStartY;
        _firstLastViewStartY = _viewStartY;
        _prevFirstLastViewStartY = _viewStartY;
        _exitInfoStartY = _viewStartY;
        _prevExitInfoStartY = _viewStartY;
    }
    
    if(_addViewNum == 1)
    {
        [_trainTimeTableView removeFromSuperview];
    }
    else if(_addViewNum == 2)
    {
        [_firstLastView removeFromSuperview];
    }
    else if(_addViewNum == 3)
    {
        [_exitInfoView removeFromSuperview];
    }
    
    if(_trainTimeTableBtn.selected)
    {
        [_trainTimeTableLabel setTextColor:[UIColor blackColor]];
        [_firstLastLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        [_exitInfoLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        
        [self drawTrainTimeTableView];
        
    }
    else if (_firstLastBtn.selected)
    {
        [_firstLastLabel setTextColor:[UIColor blackColor]];
        [_trainTimeTableLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        [_exitInfoLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        
        
        [self drawFirstLastView];
        
    }
    else if (_exitInfoBtn.selected)
    {
        
        [_exitInfoLabel setTextColor:[UIColor blackColor]];
        [_firstLastLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        [_trainTimeTableLabel setTextColor:[UIColor colorWithRed:137.0/255.0 green:137.0/255.0 blue:137.0/255.0 alpha:1]];
        
        [self drawExitInfoView];
    }
    
}
-(void) drawExitInfoView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *stationId = [oms.subwayDetailDictionary objectForKeyGC:@"STID"];
    
    if([oms.subwayExitDictionary count] > 0)
    {
        [self drawSubwayExit];
    }
    else
    {
        
        
        [[ServerConnector sharedServerConnection] requestTrafficSubwayExit:self action:@selector(finishRequestTrafficSubwayExitway:) STId:(NSString *)stationId];
    }
}
- (void)finishRequestTrafficSubwayExitway:(id)request
{
    if ([request finishCode] == OMSRFinishCode_Completed)
    {
        
        [self drawSubwayExit];
        
    }
    else
    {
        
        [self tranTimeTableBtnClick:nil];
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
        
        
    }
    
}

- (void) drawSubwayExit
{
    
    for (UIView *subView in _exitInfoView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSArray *exitArr = [oms.subwayDetailDictionary objectForKeyGC:@"GATEINFO"];
    
    NSMutableArray *gate = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dic in exitArr)
    {
        NSString *key = stringValueOfDictionary(dic, @"SGATE_GATENO");
        NSString *name = stringValueOfDictionary(dic, @"SLNK_LINK");
        
        BOOL hasKey = NO;
        
        for (NSDictionary *dic2 in gate)
        {
            if([stringValueOfDictionary(dic2, @"NUM") isEqualToString:key])
            {
                NSMutableString *name2 = (NSMutableString *)[dic2 objectForKeyGC:@"NAME"];
                [name2 appendFormat:@", %@", name];
                hasKey = YES;
                break;
            }
            
        }
        
        if(!hasKey)
        {
            NSMutableDictionary *tempDic = [[NSMutableDictionary alloc] init];
            [tempDic setObject:key forKey:@"NUM"];
            [tempDic setObject:[NSMutableString stringWithString:name] forKey:@"NAME"];
            [gate addObject:tempDic];
            
        }
        
    }
    
    NSSortDescriptor *numberSort = [[NSSortDescriptor alloc] initWithKey:@"NUM" ascending:YES];
    [gate sortUsingDescriptors:[NSArray arrayWithObjects:numberSort, nil]];
    
    // 뷰의Y축
    int tempHeight=0;
    // 라벨x축
    int label_X = 10;
    // 출구번호라벨
    int numLabelHeight = 14;
    int numLabelY = 14;
    
    NSMutableDictionary *refinedDic = [NSMutableDictionary dictionary];
    
    
    NSMutableDictionary *exitArr2 = [oms.subwayExitDictionary objectForKeyGC:@"GateINFO"];
    
    
    for(NSDictionary *dic in gate)
    {
        NSString *key = [NSString stringWithFormat:@"%@", [dic objectForKeyGC:@"NUM"]];
        
        [refinedDic setObject:dic forKey:key];
        
    }
    
    for (NSDictionary *dicc in exitArr2)
    {
        NSString *key = [NSString stringWithFormat:@"%@", [dicc objectForKeyGC:@"GateNo"]];
        
        if([[refinedDic allKeys] containsObject:key])
        {
            [[refinedDic objectForKeyGC:key] setObject:dicc forKey:@"GATE"];
        }
        
    }
    
    NSMutableArray *sortKey =[NSMutableArray arrayWithArray:refinedDic.allKeys];
    
    //[sortKey sortUsingSelector:@selector(compare:options:range:locale:)];
    NSArray *sortKey2 = [sortKey sortedArrayUsingSelector:@selector(compareNumberStrings:)];
    
    
    //NSLog(@"sortKey2 : %@", sortKey2);
    
    for (int i = (int)[(NSArray *)sortKey2 count]; i>0; i--)
    {
        NSString *key = [sortKey2 objectAtIndexGC:i-1];
        
        //NSLog(@"key : %@", key);
        
        NSDictionary *dic = [refinedDic objectForKeyGC:key];
        
        UIView *numberExitView = [[UIView alloc] init];
        
        UILabel *num = [[UILabel alloc] initWithFrame:CGRectMake(label_X, numLabelY, _exitInfoView.frame.size.width, numLabelHeight)];
        
        UILabel *name =  [[UILabel alloc] init];
        
        [num setText:[NSString stringWithFormat:@"%@번출구",[dic objectForKeyGC:@"NUM"]]];
        [num setFont:[UIFont boldSystemFontOfSize:14]];
        
        [name setText:[dic objectForKeyGC:@"NAME"]];
        [name setFont:[UIFont systemFontOfSize:13]];
        [name setTextColor:[UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
        [name setLineBreakMode:NSLineBreakByWordWrapping];
        [name setNumberOfLines:0];
        
        CGSize nameSize = [name.text sizeWithFont:name.font constrainedToSize:CGSizeMake(300, FLT_MAX) lineBreakMode:name.lineBreakMode];
        
        [name setFrame:CGRectMake(10, 35, nameSize.width, nameSize.height)];
        
        
        [numberExitView addSubview:num];
        [numberExitView addSubview:name];
        
        /// 버스정보 그리기
        
        // 시작점
        int startY = 35 + nameSize.height + 16;
        
        //NSLog(@"BusInFO count :%d, 버스정보 : %@", [[[dic objectForKeyGC:@"GATE"] objectForKeyGC:@"StopInFO"] count], [[dic objectForKeyGC:@"GATE"] objectForKeyGC:@"StopInFO"]);
        
        
        NSMutableDictionary *xdic  = [NSMutableDictionary dictionary];
        
        for (NSDictionary *ddic in [[dic objectForKeyGC:@"GATE"] objectForKeyGC:@"StopInFO"])
        {
            if([[ddic allKeys] containsObject:@"BusInFO"] == NO)
                continue;
            
            for (NSDictionary *dddic in [ddic objectForKeyGC:@"BusInFO"])
            {
                int type = [[dddic objectForKeyGC:@"Type"] intValue];
                NSString *busName = [NSString stringWithFormat:@"%@", [dddic objectForKeyGC:@"BusNo"]];
                
                if([[xdic allKeys] containsObject:[NSString stringWithFormat:@"%d", type]] == NO)
                {
                    // 중복데이터 제거를 위해 MutableArray 대신 MutableSet 사용
                    [xdic setObject:[NSMutableSet set] forKey:[NSString stringWithFormat:@"%d", type]];
                    
                }
                
                [[xdic objectForKeyGC:[NSString stringWithFormat:@"%d", type]] addObject:busName];
                
            }
            
            
        }
        
        // 렌더링 시작
        for (NSString *dddddic in xdic.allKeys)
        {
            UIImageView *busType = [[UIImageView alloc] initWithFrame:CGRectMake(10, startY, 29, 18)];
            
            [busType setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [oms getLaneIdToImgString:dddddic]]]];
            
            startY += 18 + 4;
            
            NSMutableString *busString = [NSMutableString string];
            
            for (NSString *str in [xdic objectForKeyGC:dddddic])
            {
                
                if(busString.length > 0)
                    [busString appendString:@" / "];
                
                [busString appendString:str];
            }
            
            UILabel *busStr = [[UILabel alloc] init];
            [busStr setText:busString];
            [busStr setFont:[UIFont systemFontOfSize:13]];
            //[busStr setBackgroundColor:[UIColor redColor]];
            [busStr setNumberOfLines:0];
            CGSize busStrSize = [busStr.text sizeWithFont:busStr.font constrainedToSize:CGSizeMake(300, FLT_MAX)];
            
            [busStr setFrame:CGRectMake(10, startY, 300, busStrSize.height)];
            
            [numberExitView addSubview:busType];
            [numberExitView addSubview:busStr];
            
            startY += busStrSize.height + 8;
            
        }
        
        // 각 출구정보뷰 높이
        int numberExitViewHeight = startY;
        [numberExitView setFrame:CGRectMake(0, tempHeight, 320, numberExitViewHeight)];
        
        
        [_exitInfoView addSubview:numberExitView];
        
        // 다음 출구정보뷰 시작Y축
        tempHeight += numberExitViewHeight;
        
        UIImageView *underLine22 = [[UIImageView alloc] init];
        [underLine22 setFrame:CGRectMake(0, tempHeight, 320, 1)];
        [underLine22 setBackgroundColor:[UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1]];
        //[underLine22 setBackgroundColor:[UIColor blackColor]];
        [_exitInfoView addSubview:underLine22];
        
        
        tempHeight += 1;
        
    }
    
    
    
    CGRect tempRect = _exitInfoView.frame;
    tempRect.size.height = tempHeight;
    _exitInfoView.frame = tempRect;
    
    [_timeFisrtLastExitImg setImage:[UIImage imageNamed:@"poi_3tab_03.png"]];
    [_scrollView addSubview:_exitInfoView];
    [_exitInfoView setFrame:CGRectMake(X_VALUE, _prevExitInfoStartY, X_WIDTH, _exitInfoView.frame.size.height)];
    _exitInfoStartY = _prevExitInfoStartY + _exitInfoView.frame.size.height;
    
    
    
    [self drawDetailInfoView];
    _addViewNum = 3;
}
- (void) drawTrainTimeTableView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    [_timeFisrtLastExitImg setImage:[UIImage imageNamed:@"poi_3tab_01.png"]];
    
    [_leftDirection setText:[oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"]];
    [_rightDirection setText:[oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"]];
    [_scrollView addSubview:_trainTimeTableView];
    
    NSLog(@"What Time is it now? %d, 페이지:%d", _currentHour, _page);
    
    switch (_page) {
            //case 0:
            //    [_timeRange setText:@"24:00~01:00"];
        case 1:
            [_timeRange setText:@"01:00~02:00"];
            break;
        case 2:
            [_timeRange setText:@"02:00~03:00"];
            break;
        case 3:
            [_timeRange setText:@"03:00~04:00"];
            break;
        case 4:
            [_timeRange setText:@"04:00~05:00"];
            break;
        case 5:
            [_timeRange setText:@"05:00~06:00"];
            break;
        case 6:
            [_timeRange setText:@"06:00~07:00"];
            break;
        case 7:
            [_timeRange setText:@"07:00~08:00"];
            break;
        case 8:
            [_timeRange setText:@"08:00~09:00"];
            break;
        case 9:
            [_timeRange setText:@"09:00~10:00"];
            break;
        case 10:
            [_timeRange setText:@"10:00~11:00"];
            break;
        case 11:
            [_timeRange setText:@"11:00~12:00"];
            break;
        case 12:
            [_timeRange setText:@"12:00~13:00"];
            break;
        case 13:
            [_timeRange setText:@"13:00~14:00"];
            break;
        case 14:
            [_timeRange setText:@"14:00~15:00"];
            break;
        case 15:
            [_timeRange setText:@"15:00~16:00"];
            break;
        case 16:
            [_timeRange setText:@"16:00~17:00"];
            break;
        case 17:
            [_timeRange setText:@"17:00~18:00"];
            break;
        case 18:
            [_timeRange setText:@"18:00~19:00"];
            break;
        case 19:
            [_timeRange setText:@"19:00~20:00"];
            break;
        case 20:
            [_timeRange setText:@"20:00~21:00"];
            break;
        case 21:
            [_timeRange setText:@"21:00~22:00"];
            break;
        case 22:
            [_timeRange setText:@"22:00~23:00"];
            break;
        case 23:
            [_timeRange setText:@"23:00~24:00"];
            break;
        case 24:
            [_timeRange setText:@"24:00~01:00"];
        default:
            break;
    }
    
    NSMutableArray *ordDowntimeArray = [NSMutableArray array];
    NSMutableArray *ordUptimeArray = [NSMutableArray array];
    
    NSString *upDestStrr;
    NSString *upMinStrr;
    
    NSString *downDestStrr;
    NSString *downMinStrr;
    
    NSMutableArray *timeArray = [NSMutableArray array];
    NSMutableArray *destArray = [NSMutableArray array];
    
    NSMutableArray *timeArr1ay = [NSMutableArray array];
    NSMutableArray *destArr1ay = [NSMutableArray array];
    
    // 익일새벽 1시가 25시가 넘어와서 이딴 처리를 했음
    int qtData = _page;
    if(_page == 1)
    {
        qtData = 25;
    }
    for (NSDictionary *dicTime in [oms.subwayTimeDictionary objectForKeyGC:@"SUBWAYOPERTIME_LIST"])
    {
        if([[dicTime objectForKeyGC:@"SETTIME"] intValue] == qtData)
        {
            if(_typeDay == 1)
            {
                // && 앞쪽은 상행, 하행이 비었는지 체크 && 뒤쪽은 주말에 5시 차가 없으면 배열이 비어서 강종되기 때문에 널인지 체크
                if([oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"] != nil && [dicTime objectForKeyGC:@"ORDINARYUPTIME"] != [NSNull null])
                    ordUptimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"ORDINARYUPTIME"] componentsSeparatedByString:@" "]];
                
                if([oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"] != nil && [dicTime objectForKeyGC:@"ORDINARYDOWNTIME"] != [NSNull null])
                    ordDowntimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"ORDINARYDOWNTIME"] componentsSeparatedByString:@" "]];
            }
            else if (_typeDay == 2)
            {
                if([oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"] != nil && [dicTime objectForKeyGC:@"SATURDAYUPTIME"] != [NSNull null])
                    ordUptimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"SATURDAYUPTIME"] componentsSeparatedByString:@" "]];
                
                if([oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"] != nil && [dicTime objectForKeyGC:@"SATURDAYDOWNTIME"] != [NSNull null])
                    ordDowntimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"SATURDAYDOWNTIME"] componentsSeparatedByString:@" "]];
            }
            else if (_typeDay == 3)
            {
                if([oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"] != nil  && [dicTime objectForKeyGC:@"SUNDAYUPTIME"] != [NSNull null])
                    ordUptimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"SUNDAYUPTIME"] componentsSeparatedByString:@" "]];
                
                if([oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"] != nil && [dicTime objectForKeyGC:@"SUNDAYDOWNTIME"] != [NSNull null])
                    ordDowntimeArray = [NSMutableArray arrayWithArray:[[dicTime objectForKeyGC:@"SUNDAYDOWNTIME"] componentsSeparatedByString:@" "]];
            }
            
        }
    }
    
    // 상행테이블 그리기
    for(int i = 0;i<ordUptimeArray.count; i++)
    {
        NSString *upRawStr = [NSString stringWithFormat:@"%@", [ordUptimeArray objectAtIndexGC:i]];
        NSRange tempRange = [upRawStr rangeOfString:@"("];
        
        if(tempRange.location == NSNotFound)
        {
            upMinStrr = upRawStr;
            upDestStrr = @"";
        }
        else if (tempRange.location == 0)
        {
            upMinStrr = @"";
            upDestStrr = upRawStr;
        }
        else
        {
            upMinStrr = [upRawStr substringToIndex:tempRange.location];
            upDestStrr = [upRawStr substringFromIndex:tempRange.location];
        }
        
        [timeArray addObject:upMinStrr];
        [destArray addObject:upDestStrr];
    }
    NSMutableString *tempUpTime = [NSMutableString string];
    NSMutableString *tempUpDest = [NSMutableString string];
    for (NSString *str in timeArray)
    {
        if(tempUpTime.length > 0)
            [tempUpTime appendString:@"\n"];
        
        [tempUpTime appendFormat:@"%d:%@", _page ,str];
    }
    for (NSString *str in destArray)
    {
        if(tempUpDest.length > 0)
            [tempUpDest appendString:@"\n"];
        
        [tempUpDest appendFormat:@"%@", str];
    }
    
    [_upperTime setText:tempUpTime];
    [_upperDest setText:tempUpDest];
    
    // 상행 끝
    
    // 하행 그리기
    for(int i = 0;i<ordDowntimeArray.count; i++)
    {
        NSString *downRawStr = [NSString stringWithFormat:@"%@", [ordDowntimeArray objectAtIndexGC:i]];
        NSRange tempRange = [downRawStr rangeOfString:@"("];
        
        if(tempRange.location == NSNotFound)
        {
            downMinStrr = downRawStr;
            downDestStrr = @"";
        }
        else if (tempRange.location == 0)
        {
            downMinStrr = @"";
            downDestStrr = downRawStr;
        }
        else
        {
            downMinStrr = [downRawStr substringToIndex:tempRange.location];
            downDestStrr = [downRawStr substringFromIndex:tempRange.location];
        }
        
        [timeArr1ay addObject:downMinStrr];
        [destArr1ay addObject:downDestStrr];
    }
    
    NSMutableString *tempDownTime = [NSMutableString string];
    NSMutableString *tempDownDest = [NSMutableString string];
    for (NSString *str in timeArr1ay)
    {
        if(tempDownTime.length > 0)
            [tempDownTime appendString:@"\n"];
        
        [tempDownTime appendFormat:@"%d:%@", _page ,str];
    }
    for (NSString *str in destArr1ay)
    {
        if(tempDownDest.length > 0)
            [tempDownDest appendString:@"\n"];
        
        [tempDownDest appendFormat:@"%@", str];
    }
    
    [_downerTime setText:tempDownTime];
    [_downerDest setText:tempDownDest];
    
    [ordDowntimeArray removeAllObjects];
    [ordUptimeArray removeAllObjects];
    
    // 하행 끝
    
    if(_weekdayBtn.selected)
    {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    }
    else if (_saturdayBtn.selected) {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        
    }
    else if (_sundayBtn.selected)
    {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    }
    
    // 넘버라인 0이면 무한대로 늘어남
    // 텍스트가 라벨사이즈보다 초과되면 자동줄바꿈
    [_upperTime setNumberOfLines:0];
    [_upperDest setNumberOfLines:0];
    [_downerTime setNumberOfLines:0];
    [_downerDest setNumberOfLines:0];
    [_upperTime setLineBreakMode:NSLineBreakByWordWrapping];
    [_upperDest setLineBreakMode:NSLineBreakByWordWrapping];
    [_downerTime setLineBreakMode:NSLineBreakByWordWrapping];
    [_downerDest setLineBreakMode:NSLineBreakByWordWrapping];
    // 라벨 사이즈 맞추기
    
    CGSize maximumLabelSize = CGSizeMake(280,9999);
    
    // 상행시간
    CGSize expectedLabelSize = [_upperTime.text sizeWithFont:_upperTime.font
                                           constrainedToSize:maximumLabelSize
                                               lineBreakMode:_upperTime.lineBreakMode];
    CGRect newFrame = _upperTime.frame;
    newFrame.size.height = expectedLabelSize.height;
    _upperTime.frame = newFrame;
    
    // 상행종착
    CGSize expectedLabel2Size = [_upperDest.text sizeWithFont:_upperDest.font
                                            constrainedToSize:maximumLabelSize
                                                lineBreakMode:_upperDest.lineBreakMode];
    CGRect new2Frame = _upperDest.frame;
    new2Frame.size.height = expectedLabel2Size.height;
    _upperDest.frame = new2Frame;
    
    // 하행시간
    CGSize expectedLabel3Size = [_downerTime.text sizeWithFont:_downerTime.font
                                             constrainedToSize:maximumLabelSize
                                                 lineBreakMode:_downerTime.lineBreakMode];
    CGRect new3Frame = _downerTime.frame;
    new3Frame.size.height = expectedLabel3Size.height;
    _downerTime.frame = new3Frame;
    // 하행종착
    CGSize expectedLabel4Size = [_downerDest.text sizeWithFont:_downerDest.font
                                             constrainedToSize:maximumLabelSize
                                                 lineBreakMode:_downerDest.lineBreakMode];
    CGRect new4Frame = _downerDest.frame;
    new4Frame.size.height = expectedLabel4Size.height;
    _downerDest.frame = new4Frame;
    
    
    // 최대값 찾기 배열(상행시간, 상행종착, 하행시간, 하행종착 중 제일 긴 것을 뷰의 크기로 해야되기 때문)
    
    NSArray *maxFind = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:newFrame.size.height], [NSNumber numberWithFloat:new2Frame.size.height], [NSNumber numberWithFloat:new3Frame.size.height], [NSNumber numberWithFloat:new4Frame.size.height], nil];
    
    NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
    
    NSArray *resultArray = [maxFind sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
    
    // resultArray 의 제일 첫번째 인덱스가 제일 크다(마지막 10은 여백(디자인가이드))
    [_trainTimeTableTimeBG setFrame:CGRectMake(X_VALUE, 0, X_WIDTH, _upperTime.frame.origin.y + [[resultArray objectAtIndexGC:0] intValue] + 10)];
    
    // 옵션뷰높이 33 + 밑줄1 + 시간버튼33 + 밑줄1 + 라벨33
    [_trainTimeTableView setFrame:CGRectMake(X_VALUE, _prevViewStartY, X_WIDTH, 33+1+33+33+1+_upperTime.frame.origin.y +[[resultArray objectAtIndexGC:0] intValue] + 10)];
    _viewStartY = _prevViewStartY + 33+1+33+33+1+[[resultArray objectAtIndexGC:0] intValue]+ _upperTime.frame.origin.y + 10;
    
    [self drawDetailInfoView];
    _addViewNum = 1;
    
}

- (void) drawFirstLastView
{
    
    [_timeFisrtLastExitImg setImage:[UIImage imageNamed:@"poi_3tab_02.png"]];
    [_scrollView addSubview:_firstLastView];
    //[_firstLastView setFrame:CGRectMake(X_VALUE, _firstLastViesStartY, X_WIDTH, 500)];
    //_firstLastViesStartY = _firstLastViesStartY + 500;
    //_viewStartY = _viewStartY + 100;
    int optionViewNunderLine = 33 + 1;
    int upperLabelViewHeight = 67;
    int downerLabelViewHeight = 67;
    int upperViewHeight =0;
    int downerViewHeight = 0;
    
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //NSLog(@"상행 : %@", [oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"]);
    
    
    NSString *firstInfo = @"";
    
    
    NSString *lastInfo = @"";
    
    
    
    if(_weekDayButton.selected)
    {
        firstInfo = [oms.subwayDetailDictionary objectForKeyGC:@"ORDINARYFIRSTTIME"];
        lastInfo = [oms.subwayDetailDictionary objectForKeyGC:@"ORDINARYLASTTIME"];
    }
    else if (_saturDayButton.selected)
    {
        firstInfo = [oms.subwayDetailDictionary objectForKeyGC:@"SATURDAYFIRSTTIME"];
        lastInfo = [oms.subwayDetailDictionary objectForKeyGC:@"SATURDAYLASTTIME"];
    }
    else if (_sunDayButton.selected)
    {
        firstInfo = [oms.subwayDetailDictionary objectForKeyGC:@"SUNDAYFIRSTTIME"];
        lastInfo = [oms.subwayDetailDictionary objectForKeyGC:@"SUNDAYLASTTIME"];
    }
    
    NSArray *firstSegment = [firstInfo componentsSeparatedByString:@"#"];
    NSArray *lastSegment = [lastInfo componentsSeparatedByString:@"#"];
    
    NSString *firstUpString = [firstSegment objectAtIndexGC:0];
    NSString *firstDownString = [firstSegment objectAtIndexGC:1];
    
    NSString *lastUpString = [lastSegment objectAtIndexGC:0];
    NSString *lastDownString = [lastSegment objectAtIndexGC:1];
    
    NSMutableString *timeStr = [NSMutableString string];
    NSMutableString *destStr = [NSMutableString string];
    int maxRowNumber = 0;
    
    
    // 상행 라벨
    [_upperLabel setText:[NSString stringWithFormat:@"%@%@", [oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"], @"행"]];
    if([oms.subwayTimeDictionary objectForKeyGC:@"UPWAY"] == nil)
    {
        [_upperLabelView setHidden:YES];
        [_upperView setHidden:YES];
        upperLabelViewHeight = 0;
        upperViewHeight = 0;
    }
    
    
    else {
        
        [_upperLabelView setFrame:CGRectMake(X_VALUE, optionViewNunderLine, X_WIDTH, upperLabelViewHeight)];
        
        // 상행첫차
        for (NSString *strBox in [firstUpString componentsSeparatedByString:@"◎"])
        {
            if(strBox.length <= 0)
                continue;
            
            NSArray *arr = [strBox componentsSeparatedByString:@" "];
            
            //NSLog(@"firstUpString Arr : %@", arr);
            if(timeStr.length > 0)
            {
                [timeStr appendString:@"\n"];
                [destStr appendString:@"\n"];
            }
            
            maxRowNumber++;
            [timeStr appendString:[arr objectAtIndexGC:1]];
            [destStr appendString:[arr objectAtIndexGC:0]];
            
        }
        
        [_upperFirstTime setNumberOfLines:maxRowNumber];
        [_upperFirstDest setNumberOfLines:maxRowNumber];
        [_upperFirstTime setText:timeStr];
        [_upperFirstDest setText:destStr];
        //NSLog(@"timeStr : %@", timeStr);
        CGSize sizeUpFirstTime = [_upperFirstTime.text sizeWithFont:_upperFirstTime.font constrainedToSize:CGSizeMake(35, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        CGSize sizeUpFirstDest = [_upperFirstDest.text sizeWithFont:_upperFirstDest.font constrainedToSize:CGSizeMake(200, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        
        [_upperFirstTime setFrame:CGRectMake(10, 9, sizeUpFirstTime.width, sizeUpFirstTime.height)];
        [_upperFirstDest setFrame:CGRectMake(50, 9, sizeUpFirstDest.width, sizeUpFirstDest.height)];
        
        // 상행 막차
        
        maxRowNumber = 0;
        timeStr = [NSMutableString string];
        destStr = [NSMutableString string];
        
        for (NSString *strBox in [lastUpString componentsSeparatedByString:@"◎"])
        {
            if(strBox.length <= 0)
                continue;
            
            NSArray *arr = [strBox componentsSeparatedByString:@" "];
            
            //NSLog(@"firstDownString Arr : %@", arr);
            if(timeStr.length > 0)
            {
                [timeStr appendString:@"\n"];
                [destStr appendString:@"\n"];
            }
            maxRowNumber++;
            [timeStr appendString:[arr objectAtIndexGC:1]];
            [destStr appendString:[arr objectAtIndexGC:0]];
        }
        
        //NSLog(@"timeStr : %@", timeStr);
        [_upperLastTime setNumberOfLines:maxRowNumber];
        [_upperLastDest setNumberOfLines:maxRowNumber];
        [_upperLastTime setText:timeStr];
        [_upperLastDest setText:destStr];
        
        
        CGSize sizeUpLastTime = [_upperLastTime.text sizeWithFont:_upperLastTime.font constrainedToSize:CGSizeMake(35, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        CGSize sizeUpLastDest = [_upperLastDest.text sizeWithFont:_upperLastDest.font constrainedToSize:CGSizeMake(200, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        
        [_upperLastTime setFrame:CGRectMake(170, 9, sizeUpLastTime.width, sizeUpLastTime.height)];
        [_upperLastDest setFrame:CGRectMake(210, 9, sizeUpLastDest.width, sizeUpLastDest.height)];
        
        // 최대값 찾기 배열
        NSArray *maxFind = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:sizeUpFirstTime.height], [NSNumber numberWithFloat:sizeUpFirstTime.height], [NSNumber numberWithFloat:sizeUpLastTime.height], [NSNumber numberWithFloat:sizeUpLastDest.height], nil];
        
        NSSortDescriptor *desc = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
        
        NSArray *resultArray = [maxFind sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc]];
        //NSLog(@"%@",[resultArray objectAtIndexGC:0]);
        
        upperViewHeight = 9 + [[resultArray objectAtIndexGC:0] intValue] + 10;
        
        // 상행뷰크기
        [_upperView setFrame:CGRectMake(0, optionViewNunderLine + upperLabelViewHeight, 320, upperViewHeight)];
        [_upperBackGround setFrame:CGRectMake(0, 0, 320, upperViewHeight)];
    }
    
    
    // 하행 라벨
    [_downerLabel setText:[NSString stringWithFormat:@"%@%@", [oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"], @"행"]];
    
    if([oms.subwayTimeDictionary objectForKeyGC:@"DOWNWAY"] == nil)
    {
        [_downerLabelView setHidden:YES];
        [_downerView setHidden:YES];
        downerLabelViewHeight = 0;
        downerViewHeight = 0;
    }
    else {
        
        [_downerLabelView setFrame:CGRectMake(X_VALUE, optionViewNunderLine + upperLabelViewHeight + upperViewHeight, X_WIDTH, downerLabelViewHeight)];
        // 하행 첫차
        maxRowNumber = 0;
        timeStr = [NSMutableString string];
        destStr = [NSMutableString string];
        
        for (NSString *strBox in [firstDownString componentsSeparatedByString:@"◎"])
        {
            if(strBox.length <= 0)
                continue;
            
            NSArray *arr = [strBox componentsSeparatedByString:@" "];
            
            //NSLog(@"firstDownString Arr : %@", arr);
            if(timeStr.length > 0)
            {
                [timeStr appendString:@"\n"];
                [destStr appendString:@"\n"];
            }
            maxRowNumber++;
            [timeStr appendString:[arr objectAtIndexGC:1]];
            [destStr appendString:[arr objectAtIndexGC:0]];
        }
        
        //NSLog(@"timeStr : %@", timeStr);
        [_downerFirstTime setNumberOfLines:maxRowNumber];
        [_downerFirstDest setNumberOfLines:maxRowNumber];
        [_downerFirstTime setText:timeStr];
        [_downerFirstDest setText:destStr];
        
        
        CGSize sizeDownFirstTime = [_downerFirstTime.text sizeWithFont:_downerFirstTime.font constrainedToSize:CGSizeMake(35, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        CGSize sizeDownFirstDest = [_downerFirstDest.text sizeWithFont:_downerFirstDest.font constrainedToSize:CGSizeMake(200, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        
        [_downerFirstTime setFrame:CGRectMake(10, 9, sizeDownFirstTime.width, sizeDownFirstTime.height)];
        [_downerFirstDest setFrame:CGRectMake(50, 9, sizeDownFirstDest.width, sizeDownFirstDest.height)];
        
        // 하행 막차
        maxRowNumber = 0;
        timeStr = [NSMutableString string];
        destStr = [NSMutableString string];
        
        for (NSString *strBox in [lastDownString componentsSeparatedByString:@"◎"])
        {
            if(strBox.length <= 0)
                continue;
            
            NSArray *arr = [strBox componentsSeparatedByString:@" "];
            
            //NSLog(@"firstDownString Arr : %@", arr);
            if(timeStr.length > 0)
            {
                [timeStr appendString:@"\n"];
                [destStr appendString:@"\n"];
            }
            maxRowNumber++;
            [timeStr appendString:[arr objectAtIndexGC:1]];
            [destStr appendString:[arr objectAtIndexGC:0]];
        }
        
        //NSLog(@"timeStr : %@", timeStr);
        [_downerLastTime setNumberOfLines:maxRowNumber];
        [_downerLastDest setNumberOfLines:maxRowNumber];
        [_downerLastTime setText:timeStr];
        [_downerLastDest setText:destStr];
        
        
        CGSize sizeDownLastTime = [_downerLastTime.text sizeWithFont:_downerLastTime.font constrainedToSize:CGSizeMake(35, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        CGSize sizeDownLastDest = [_downerLastDest.text sizeWithFont:_downerLastDest.font constrainedToSize:CGSizeMake(200, FLT_MAX) lineBreakMode:NSLineBreakByClipping];
        
        [_downerLastTime setFrame:CGRectMake(170, 9, sizeDownLastTime.width, sizeDownLastTime.height)];
        [_downerLastDest setFrame:CGRectMake(210, 9, sizeDownLastDest.width, sizeDownLastDest.height)];
        
        // 최대값 찾기 배열
        NSArray *maxFind1 = [[NSArray alloc] initWithObjects:[NSNumber numberWithFloat:sizeDownFirstTime.height], [NSNumber numberWithFloat:sizeDownFirstTime.height], [NSNumber numberWithFloat:sizeDownLastTime.height], [NSNumber numberWithFloat:sizeDownLastDest.height], nil];
        
        NSSortDescriptor *desc1 = [[NSSortDescriptor alloc] initWithKey:@"self" ascending:NO];
        
        NSArray *resultArray1 = [maxFind1 sortedArrayUsingDescriptors:[NSArray arrayWithObject:desc1]];
        
        //NSLog(@"%@",[resultArray1 objectAtIndexGC:0]);
        
        downerViewHeight = 9 + [[resultArray1 objectAtIndexGC:0] intValue] + 10;
        //NSLog(@"하행뷰 높이 : %d", downerViewHeight);
        
        // 하행뷰크기
        [_downerView setFrame:CGRectMake(0, optionViewNunderLine + upperLabelViewHeight + upperViewHeight + downerLabelViewHeight, 320, downerViewHeight)];
        [_downerBackGround setFrame:CGRectMake(0, 0, 320, downerViewHeight)];
    }
    [_firstLastView setFrame:CGRectMake(X_VALUE, _prevFirstLastViewStartY, X_WIDTH, optionViewNunderLine + upperLabelViewHeight + upperViewHeight + downerLabelViewHeight + downerViewHeight)];
    //_firstLastViesStartY;
    _firstLastViewStartY = _prevFirstLastViewStartY + optionViewNunderLine + upperLabelViewHeight + upperViewHeight + downerLabelViewHeight + downerViewHeight;
    
    //NSLog(@"firstLastViewStartY : %d", _firstLastViesStartY);
    [self drawDetailInfoView];
    _addViewNum = 2;
    
}
- (void) drawDetailInfoView
{
    // 그리기전 다 지운다
    for (UIView *subView in _detailInfoView.subviews)
    {
        [subView removeFromSuperview];
    }
    
    
    UIView *detailLabelView = [[UIView alloc] init];
    [detailLabelView setFrame:CGRectMake(0, 0, 320, 35)];
    [detailLabelView setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1]];
    
    UILabel *detailLabel = [[UILabel alloc] init];
    [detailLabel setText:@"상세정보"];
    [detailLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [detailLabel setBackgroundColor:[UIColor clearColor]];
    [detailLabel setFrame:CGRectMake(10, 10, 200, 14)];
    [detailLabelView addSubview:detailLabel];
    
    
    
    [_detailInfoView addSubview:detailLabelView];
    
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 상세정보라벨뷰 높이 + 35
    
    int lblX = 10;
    int contentX = 97;
    int lblY = 35 + 14;
    int y_interval = 19;
    int lblWidth = 67;
    int lblHeight = 13;
    
    // 제목
    UIFont *lblFont = [UIFont boldSystemFontOfSize:13];
    // 내용
    UIFont *contentFont = [UIFont systemFontOfSize:13];
    UIColor *contentColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
    
    // 주소
    UILabel *addLabel = [[UILabel alloc] init];
    [addLabel setText:@"주소"];
    [addLabel setFont:lblFont];
    //[addLabel setBackgroundColor:[UIColor redColor]];
    [addLabel setFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    [_detailInfoView addSubview:addLabel];
    
    
    
    UILabel *addContent = [[UILabel alloc] init];
    [addContent setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_ADDRESS"]];
    [addContent setFont:contentFont];
    //[addContent setBackgroundColor:[UIColor redColor]];
    [addContent setTextColor:contentColor];
    [addContent setNumberOfLines:0];
    
    CGSize addSize = [addContent.text sizeWithFont:addContent.font constrainedToSize:CGSizeMake(186, FLT_MAX)];
    
    [addContent setFrame:CGRectMake(contentX, lblY, addSize.width, addSize.height)];
    [_detailInfoView addSubview:addContent];
    
    
    //[_addressLabel setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_ADDRESS"]];
    
    lblY += addSize.height + y_interval;
    
    // 플랫폼위치
    
    UILabel *platformlbl = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    [platformlbl setText:@"플랫폼위치"];
    //[platformlbl setBackgroundColor:[UIColor redColor]];
    [platformlbl setFont:lblFont];
    [_detailInfoView addSubview:platformlbl];
    
    // 플랫폼내용
    UILabel *platformContent = [[UILabel alloc] initWithFrame:CGRectMake(contentX, lblY, 186, 13)];
    
    
    if([[oms.subwayDetailDictionary objectForKeyGC:@"PLATFORM"] isEqualToString:@"0"])
    {
        [platformContent setText:@"기타"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"PLATFORM"] isEqualToString:@"1"]) {
        [platformContent setText:@"중앙"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"PLATFORM"] isEqualToString:@"2"]) {
        [platformContent setText:@"양쪽"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"PLATFORM"] isEqualToString:@"3"]) {
        [platformContent setText:@"복선(국철)"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"PLATFORM"] isEqualToString:@"4"]) {
        [platformContent setText:@"일방향"];
    }
    else {
        [platformContent setText:@"zz"];
    }
    
    if([platformContent.text isEqualToString:@"zz"])
    {
        [platformContent setHidden:YES];
        [platformlbl setHidden:YES];
    }
    else
    {
        //[platformContent setBackgroundColor:[UIColor redColor]];
        [platformContent setTextColor:contentColor];
        [platformContent setFont:contentFont];
        [_detailInfoView addSubview:platformContent];
        
        lblY += lblHeight + y_interval;
        
    }
    // 내리는문
    
    UILabel *doorLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    [doorLabel setText:@"내리는 문"];
    [doorLabel setFont:lblFont];
    [_detailInfoView addSubview:doorLabel];
    
    
    UILabel *doorContent = [[UILabel alloc] initWithFrame:CGRectMake(contentX, lblY, 186, 13)];
    
    
    // 내리는문
    if([[oms.subwayDetailDictionary objectForKeyGC:@"OFFDOOR"] isEqualToString:@"0"])
    {
        [doorContent setText:@"왼쪽"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"OFFDOOR"] isEqualToString:@"1"]) {
        [doorContent setText:@"오른쪽"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"OFFDOOR"] isEqualToString:@"2"]) {
        [doorContent setText:@"양쪽"];
    }
    else {
        
        [doorContent setText:@"zz"];
        
    }
    
    if([doorContent.text isEqualToString:@"zz"])
    {
        [doorLabel setHidden:YES];
        [doorContent setHidden:YES];
    }
    else {
        [doorContent setFont:contentFont];
        [doorContent setTextColor:contentColor];
        
        [_detailInfoView addSubview:doorContent];
        
        lblY += lblHeight + y_interval;
    }
    
    
    
    
    // 횡단
    
    UILabel *crossLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    [crossLabel setText:@"반대편 횡단"];
    [crossLabel setFont:lblFont];
    CGSize crossSize = [crossLabel.text sizeWithFont:crossLabel.font constrainedToSize:CGSizeMake(FLT_MAX, 13)];
    [crossLabel setFrame:CGRectMake(lblX, lblY, crossSize.width, lblHeight)];
    [_detailInfoView addSubview:crossLabel];
    
    
    UILabel *crossContent = [[UILabel alloc] initWithFrame:CGRectMake(contentX, lblY, 186, 13)];
    
    if([[oms.subwayDetailDictionary objectForKeyGC:@"CROSSOVER"] isEqualToString:@"0"])
    {
        [crossContent setText:@"기타"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"CROSSOVER"] isEqualToString:@"1"]) {
        [crossContent setText:@"연결안됨"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"CROSSOVER"] isEqualToString:@"2"]) {
        [crossContent setText:@"연결됨"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"CROSSOVER"] isEqualToString:@"3"]) {
        [crossContent setText:@"환승역 연결"];
    }
    else {
        [crossContent setText:@"zz"];
    }
    
    
    if([crossContent.text isEqualToString:@"zz"])
    {
        [crossLabel setHidden:YES];
        [crossContent setHidden:YES];
    }
    else {
        [crossContent setFont:contentFont];
        [crossContent setTextColor:contentColor];
        [_detailInfoView addSubview:crossContent];
        
        lblY += lblHeight + y_interval;
    }
    
    
    // 장실
    
    UILabel *restLabel = [[UILabel alloc] init];
    
    [restLabel setText:@"화장실 위치"];
    [restLabel setFont:lblFont];
    CGSize restSize = [restLabel.text sizeWithFont:restLabel.font constrainedToSize:CGSizeMake(FLT_MAX, 13)];
    [restLabel setFrame:CGRectMake(lblX, lblY, restSize.width, lblHeight)];
    [_detailInfoView addSubview:restLabel];
    
    
    UILabel *restContent = [[UILabel alloc] initWithFrame:CGRectMake(contentX, lblY, 186, 13)];
    
    if([[oms.subwayDetailDictionary objectForKeyGC:@"RESTROOM"] isEqualToString:@"0"])
    {
        [restContent setText:@"없음"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"RESTROOM"] isEqualToString:@"1"]) {
        [restContent setText:@"안쪽"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"RESTROOM"] isEqualToString:@"2"]) {
        [restContent setText:@"바깥쪽"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"RESTROOM"] isEqualToString:@"3"]) {
        [restContent setText:@"환승역 연결"];
    }
    else if ([[oms.subwayDetailDictionary objectForKeyGC:@"RESTROOM"] isEqualToString:@"4"]) {
        [restContent setText:@"안쪽/바깥쪽"];
    }
    else {
        [restContent setText:@"zz"];
    }
    
    if([restContent.text isEqualToString:@"zz"])
    {
        [restLabel setHidden:YES];
        [restContent setHidden:YES];
    }
    else {
        [restContent setFont:contentFont];
        [restContent setTextColor:contentColor];
        [_detailInfoView addSubview:restContent];
        
        lblY += lblHeight + y_interval;
    }
    
    
    
    
    
    NSString *meetingPlace;
    NSString *publicOffice;
    NSString *bicycle;
    NSString *parking;
    NSString *convenience;
    
    // 만남의장소
    
    UILabel *convLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, lblWidth, lblHeight)];
    [convLabel setText:@"편의시설"];
    [convLabel setFont:lblFont];
    [_detailInfoView addSubview:convLabel];
    
    
    UILabel *convContent = [[UILabel alloc] initWithFrame:CGRectMake(contentX, lblY, 186, 13)];
    
    if([[oms.subwayDetailDictionary objectForKeyGC:@"MEETINGPLACE"] isEqualToString:@"0"])
    {
        meetingPlace = @"";
    }
    else {
        
        meetingPlace = @"만남의 장소 / ";
    }
    
    // 현장사무소
    if([[oms.subwayDetailDictionary objectForKeyGC:@"PUBLICOFFICE"] isEqualToString:@"0"])
    {
        publicOffice = @"";
    }
    else {
        publicOffice = @"현장사무소 / ";
    }
    // 자전거보관소
    if([[oms.subwayDetailDictionary objectForKeyGC:@"BICYCLE"] isEqualToString:@"0"])
    {
        bicycle = @"";
    }
    else {
        bicycle = @"자전거 보관소 / ";
    }
    // 환승주차장
    if([[oms.subwayDetailDictionary objectForKeyGC:@"ISPARKING"] isEqualToString:@"0"])
    {
        parking = @"";
    }
    else {
        parking = @"환승주차장 / ";
    }
    // 장애인편의시설
    if([[oms.subwayDetailDictionary objectForKeyGC:@"ISHANDICAP"] isEqualToString:@"0"])
    {
        convenience = @"";
    }
    else
    {
        convenience = @"장애인 편의시설";
    }
    
    
    NSString *convenienceLbl = [NSString stringWithFormat:@"%@%@%@%@%@", meetingPlace, publicOffice, bicycle, parking, convenience];
    
    [convContent setNumberOfLines:0];
    [convContent setText:convenienceLbl];
    [convContent setFont:contentFont];
    [convContent setTextColor:contentColor];
    [_detailInfoView addSubview:convContent];
    
    CGSize sizeConveniencelbl = [convContent.text sizeWithFont:convContent.font constrainedToSize:CGSizeMake(186, FLT_MAX)];
    
    [convContent setFrame:CGRectMake(contentX, lblY-2, sizeConveniencelbl.width, sizeConveniencelbl.height)];
    
    lblY += sizeConveniencelbl.height + y_interval;
    
    
    if(_trainTimeTableBtn.selected)
    {
        [_detailInfoView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, lblY)];
        
        _viewStartY = _viewStartY + lblY;
    }
    else if(_firstLastBtn.selected)
    {
        [_detailInfoView setFrame:CGRectMake(X_VALUE, _firstLastViewStartY, X_WIDTH, lblY)];
        
        _firstLastViewStartY = _firstLastViewStartY + lblY;
    }
    else if(_exitInfoBtn.selected)
    {
        [_detailInfoView setFrame:CGRectMake(X_VALUE, _exitInfoStartY, X_WIDTH, lblY)];
        
        _exitInfoStartY = _exitInfoStartY + lblY;
    }
    
    [_scrollView addSubview:_detailInfoView];
    
    [self drawBottomView];
    
}
- (void) drawBottomView
{
    if(_trainTimeTableBtn.selected)
    {
        [_bottomView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 37)];
        
        _viewStartY = _viewStartY + 37;
    }
    else if(_firstLastBtn.selected)
    {
        [_bottomView setFrame:CGRectMake(X_VALUE, _firstLastViewStartY, X_WIDTH, 37)];
        
        _firstLastViewStartY = _firstLastViewStartY + 37;
    }
    else if(_exitInfoBtn.selected)
    {
        [_bottomView setFrame:CGRectMake(X_VALUE, _exitInfoStartY, X_WIDTH, 37)];
        
        _exitInfoStartY = _exitInfoStartY + 37;
    }
    
    
    
    [_scrollView addSubview:_bottomView];
    
    [self scrollviewHeight];
}
- (void) scrollviewHeight
{
    if(_trainTimeTableBtn.selected)
    {
        _scrollView.contentSize = CGSizeMake(X_WIDTH, _viewStartY);
    }
    else if(_firstLastBtn.selected)
    {
        _scrollView.contentSize = CGSizeMake(X_WIDTH, _firstLastViewStartY);
    }
    else if(_exitInfoBtn.selected)
    {
        _scrollView.contentSize = CGSizeMake(X_WIDTH, _exitInfoStartY);
    }
    
    [_scrollView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - OM_STARTY - 37)];
    
    
    
    //NSLog(@"다그렸당");
}

#pragma mark -
#pragma mark - 보조메서드
- (NSString *) getSubwayLineString :(int)lineNum
{
    NSString *subway_Line = nil;
    
    if(lineNum == 1)
    {
        subway_Line = @"(1호선)";
        
    }
    else if(lineNum == 2)
    {
        subway_Line = @"(2호선)";
    }
    else if(lineNum == 3)
    {
        subway_Line = @"(3호선)";
    }
    else if(lineNum == 4)
    {
        subway_Line = @"(4호선)";
    }
    else if(lineNum == 5)
    {
        subway_Line = @"(5호선)";
    }
    else if(lineNum == 6)
    {
        subway_Line = @"(6호선)";
    }
    else if(lineNum == 7)
    {
        subway_Line = @"(7호선)";
    }
    else if(lineNum == 8)
    {
        subway_Line = @"(8호선)";
    }
    else if(lineNum == 9)
    {
        subway_Line = @"(9호선)";
    }
    // 분당선
    else if(lineNum == 100)
    {
        subway_Line = @"(분당선)";
        
    }
    // 신분당선
    else if(lineNum == 109)
    {
        subway_Line = @"(신분당선)";
    }
    else if(lineNum == 103)
    {
        subway_Line = @"(중앙선)";
    }
    else if(lineNum == 101)
    {
        subway_Line = @"(공항철도)";
    }
    else if(lineNum == 21)
    {
        subway_Line = @"(인천1호선)";
    }
    else if(lineNum == 104)
    {
        subway_Line = @"(경의선)";
    }
    else if (lineNum == 107)
    {
        subway_Line = @"(에버라인)";
    }
    // 경춘선
    else if(lineNum == 108)
    {
        subway_Line = @"(경춘선)";
    }
    
    else if(lineNum == 71)
    {
        subway_Line = @"(부산1호선)";
    }
    else if(lineNum == 72)
    {
        subway_Line = @"(부산2호선)";
    }
    else if(lineNum == 73)
    {
        subway_Line = @"(부산3호선)";
    }
    // 부산 4호선
    else if(lineNum == 74)
    {
        subway_Line = @"(부산4호선)";
    }
    
    // 부산김해 경전철
    else if(lineNum == 79)
    {
        subway_Line = @"(부산김해 경전철)";
    }
    
    else if(lineNum == 41)
    {
        subway_Line = @"(대구1호선)";
    }
    else if(lineNum == 42)
    {
        subway_Line = @"(대구2호선)";
    }
    // 대전1호선
    else if(lineNum == 31)
    {
        subway_Line = @"(대전1호선)";
    }
    // 광주1호선
    else if(lineNum == 51)
    {
        subway_Line = @"(광주1호선)";
    }
    // 수인선
    else if(lineNum == 111)
    {
        subway_Line = @"(수인선)";
    }
    // 의정부경전철
    else if(lineNum == 110)
    {
        subway_Line = @"(의정부경전철)";
    }
    
    return subway_Line;
    
}
#pragma mark -
#pragma mark - 액션
- (void)tranTimeTableBtnClick:(id)sender
{
    _trainTimeTableBtn.selected = YES;
    _firstLastBtn.selected = NO;
    _exitInfoBtn.selected = NO;
    
    //[self drawTrainTimeTableView];
    [self drawTimeFirstLastExitView];
}
- (void)firstLastBtnClick:(id)sender
{
    _trainTimeTableBtn.selected = NO;
    _firstLastBtn.selected = YES;
    _exitInfoBtn.selected = NO;
    
    //[self drawFirstLastView];
    [self drawTimeFirstLastExitView];
}
- (void)exitInfoBtnClick:(id)sender
{
    _trainTimeTableBtn.selected = NO;
    _firstLastBtn.selected = NO;
    _exitInfoBtn.selected = YES;
    
    //[self drawExitInfoView];
    [self drawTimeFirstLastExitView];
}
- (void)prevPageClick:(id)sender
{
    if(_page == 1)
    {
        _page = 24;
    }
    else {
        _page--;
    }
    
    
    [self drawTrainTimeTableView];
}
- (void)weekDayButtonClick:(id)sender
{
    _weekDayButton.selected = YES;
    _saturDayButton.selected = NO;
    _sunDayButton.selected = NO;
    
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    
    [self drawFirstLastView];
}
- (void)weekDayButtonHighlight:(id)sender
{
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
}
- (void)saturDatButtonClick:(id)sender
{
    _weekDayButton.selected = NO;
    _saturDayButton.selected = YES;
    _sunDayButton.selected = NO;
    
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    
    [self drawFirstLastView];
}
- (void)saturDayButtonHighlight:(id)sender
{
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
}
- (void)sunDayButtonClick:(id)sender
{
    _weekDayButton.selected = NO;
    _saturDayButton.selected = NO;
    _sunDayButton.selected = YES;
    
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    
    [self drawFirstLastView];
}
- (void)sunDayButtonHighlight:(id)sender
{
    [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
}
- (void)firstLastRadioTouchUpOutSide:(id)sender
{
    if(_weekDayButton.selected == YES)
    {
        [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    }
    else if (_saturDayButton.selected == YES)
    {
        [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    }
    else if (_sunDayButton.selected == YES)
    {
        [_weekDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturDayImage setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sunDayImage setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    }
    
}

- (void)nextPageClick:(id)sender
{
    if(_page == 24)
    {
        _page = 1;
    }
    else
    {
        _page++;
    }
    
    [self drawTrainTimeTableView];
}
- (void)weekdayBtnClick:(id)sender
{
    _weekdayBtn.selected = YES;
    _saturdayBtn.selected = NO;
    _sundayBtn.selected = NO;
    
    _typeDay = 1;
    
    [self drawTrainTimeTableView];
}

- (void)weekdayBtnHightlight:(id)sender
{
    [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
}
- (void)saturdayBtnClick:(id)sender
{
    _weekdayBtn.selected = NO;
    _saturdayBtn.selected = YES;
    _sundayBtn.selected = NO;
    
    _typeDay = 2;
    
    [self drawTrainTimeTableView];
}
- (void)saturdayBtnHightlight:(id)sender
{
    [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
}
- (void)sundayBtnClick:(id)sender
{
    _weekdayBtn.selected = NO;
    _saturdayBtn.selected = NO;
    _sundayBtn.selected = YES;
    
    _typeDay = 3;
    
    [self drawTrainTimeTableView];
}
- (void)sundayBtnHightlight:(id)sender
{
    [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
}
- (void)weekBtnTochUpOutSide:(id)sender
{
    if(_weekdayBtn.selected == YES)
    {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    }
    else if (_saturdayBtn.selected == YES)
    {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
    }
    else if (_sundayBtn.selected == YES)
    {
        [_weekdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_saturdayImg setImage:[UIImage imageNamed:@"radio_btn_off.png"]];
        [_sundayImg setImage:[UIImage imageNamed:@"radio_btn_on.png"]];
    }
}

- (void)favoriteBtnClick:(id)sender
{
    // 즐겨찾기 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail/favorite"];
    
    DbHelper *dh = [[DbHelper alloc] init];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *fullName = [NSString stringWithFormat:@"%@ (%@)",[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"], [oms.subwayDetailDictionary objectForKeyGC:@"SUBWAY_LANENAME"]];
    
    NSMutableDictionary *fdic = [OMDatabaseConverter makeFavoriteDictionary:-1 sortOrder:-1 category:Favorite_Category_Public title1:fullName title2:@"대중교통 > 지하철" title3:@"" iconType:Favorite_IconType_Subway coord1x:[[oms.subwayDetailDictionary objectForKeyGC:@"SST_X"] doubleValue] coord1y:[[oms.subwayDetailDictionary objectForKeyGC:@"SST_Y"] doubleValue] coord2x:0 coord2y:0 coord3x:0 coord3y:0 detailType:@"TR" detailID:[oms.subwayDetailDictionary objectForKeyGC:@"STID"] shapeType:@"" fcNm:@"" idBgm:@"" rdCd:@""];
    
    if([dh favoriteValidCheck:fdic])
    {
        [self typeChecker:7];
        [self bottomViewFavorite:fdic placeHolder:fullName];
    }
    
    
}

- (void)infoModifyAskBtnClick:(id)sender
{
    [self typeChecker:7];
    [self modalInfoModify:[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary];
}
- (IBAction)popBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}
- (IBAction)mapBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    [oms.searchResult reset]; // 검색결과 리셋
    [oms.searchResult setUsed:YES];
    [oms.searchResult setIsCurrentLocation:NO];
    
    int lineNum = [[oms.subwayDetailDictionary objectForKeyGC:@"LANEID"] intValue];
    
    [oms.searchResult setStrLocationName:[NSString stringWithFormat:@"%@%@", [oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"], [self getSubwayLineString:lineNum]]];
    [oms.searchResult setStrLocationAddress:[oms.subwayDetailDictionary objectForKeyGC:@"SST_ADDRESS"]];
    [oms.searchResult setStrID:[oms.subwayDetailDictionary objectForKeyGC:@"STID"]];
    
    [oms.searchResult setStrType:@"TR"];
    
    Coord poiCrd = CoordMake([[oms.subwayDetailDictionary objectForKeyGC:@"SST_X"] doubleValue], [[oms.subwayDetailDictionary objectForKeyGC:@"SST_Y"] doubleValue]);
    
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    
    [oms.searchResult setCoordLocationPoint:CoordMake(xx, yy)];

    [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Normal animated:YES];
    
}

- (void)goTelePhoneClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *telNum = [oms.subwayDetailDictionary objectForKeyGC:@"SST_TEL"];
    
    [self typeChecker:7];
    [self telViewCallBtnClick:telNum];
}
- (void)startBtnClick:(id)sender
{
    [self typeChecker:7];
    [self btnViewStartBtnClick:[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary];
}
- (void)destBtnClick:(id)sender
{
    [self typeChecker:7];
    [self btnViewDestBtnClick:[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary];
}
- (void)shareBtnClick:(id)sender
{
    [self typeChecker:7];
    [self btnViewShareBtnClick];
}
- (void)subNaviBtnClick:(id)sender
{
    [self typeChecker:7];
    [self btnViewNaviBtnClick:[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary];
}

- (void)prevBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    if([oms.subwayDetailDictionary objectForKeyGC:@"PRENAME1"] == nil)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Subway_NotNextStation", @"")];
    }
    else
    {
        
        NSString *masterID = [oms.subwayDetailDictionary objectForKeyGC:@"PRESTID1"];
        
        [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestTrafficSubwayDetailRefresh:) stationId:masterID];
    }
}

- (void)finishRequestTrafficSubwayDetailRefresh:(id)request
{
    // 지하철 다음역 갈때 출구정보 내용 클리어
    for (UIView *subbView in _scrollView.subviews)
    {
        
        [subbView removeFromSuperview];
    }
    for (UIView *subbView in _detailInfoView.subviews)
    {
        [subbView removeFromSuperview];
    }
    for (UIView *subbView in _exitInfoView.subviews)
    {
        [subbView removeFromSuperview];
    }
    
    _trainTimeTableBtn.selected = YES;
    
    // 출구정보를 클리어시켜야 출구정보를 다시 불러옴(리무브안시키면 다음역을 가도 출구정보api를 안불러왔었넹 ㅋㅋ
    [[OllehMapStatus sharedOllehMapStatus].subwayExitDictionary removeAllObjects];
    
    [self drawStart];
}

- (void)nextBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //NSLog(@"하행(다음역): %@", [oms.subwayDetailDictionary objectForKeyGC:@"NEXTSTID1"]);
    
    if([oms.subwayDetailDictionary objectForKeyGC:@"NEXTNAME1"] == nil)
    {
        
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Subway_NotNextStation", @"")];
    }
    else
    {
        NSString *masterID = [oms.subwayDetailDictionary objectForKeyGC:@"NEXTSTID1"];
        
        [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestTrafficSubwayDetailRefresh:) stationId:masterID];
    }
}

#pragma mark -
#pragma mark UIPageControl, ScrollView Delegate
- (void)pageChangeValue:(id)sender
{
    UIPageControl *pController    = (UIPageControl *)sender;
    [_smallScroll setContentOffset:CGPointMake(pController.currentPage*320, 0) animated:YES];
}
- (void)scrollViewDidScroll:(UIScrollView *)sender
{
    CGFloat pageWidth = _smallScroll.frame.size.width;
    _pControl.currentPage = floor((_smallScroll.contentOffset.x - pageWidth / paging) / pageWidth) + 1;
}
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    if(_smallScroll.contentOffset.x == 0)
    {
        if(![stringValueOfDictionary(oms.subwayDetailDictionary, @"PRESTID1") isEqualToString:@"0"])
        {
            [self prevBtnClick:nil];
        }
        else
        {
            //[OMMessageBox showAlertMessage:@"":NSLocalizedString(@"Msg_Subway_NotNextStation", @"")];
            [_smallScroll setContentOffset:CGPointMake(320, 0) animated:YES];
        }
    }
    else if (_smallScroll.contentOffset.x == 640)
    {
        if(![stringValueOfDictionary(oms.subwayDetailDictionary, @"NEXTSTID1") isEqualToString:@"0"])
        {
            [self nextBtnClick:nil];
        }
        else
        {
            //[OMMessageBox showAlertMessage:@"":NSLocalizedString(@"Msg_Subway_NotNextStation", @"")];
            [_smallScroll setContentOffset:CGPointMake(320, 0) animated:YES];
        }
    }
    
}
- (void)translateBtnClick:(id)sender
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_translateListArray removeAllObjects];
    
    NSString *trans1 = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID1"];
    NSString *trans2 = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID2"];
    NSString *trans3 = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID3"];
    
    
    [_translateListArray  addObject:trans1];
    [_translateListArray  addObject:trans2];
    [_translateListArray  addObject:trans3];
    
    NSLog(@"%@", _translateListArray);
    
    int transCount = 0;
    
    [oms.subwayExistArr removeAllObjects];
    
    //NSLog(@"subwayExistArr : %@", oms.subwayExistArr);
    
    if(![[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID1"] isEqualToString:@"0"])
        transCount++;
    
    if(![[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID2"] isEqualToString:@"0"])
        transCount++;
    
    if(![[oms.subwayDetailDictionary objectForKeyGC:@"EXSTID3"] isEqualToString:@"0"])
        transCount++;
    
    if(transCount == 0)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Subway_NotTransfer", @"")];
    }
    
    else {
        
        [[ServerConnector sharedServerConnection] requestTransSubStation:self action:@selector(translateDrawer:) stationId:[_translateListArray objectAtIndexGC:0] counter:0 max:transCount];
    }
    
}
- (void) translateDrawer:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        NSInteger transIndex = [request userInt] + 1;
        NSInteger maxIndex = [request userInt2];
        
        if(maxIndex > transIndex)
        {
            // 한번더
            [[ServerConnector sharedServerConnection] requestTransSubStation:self action:@selector(translateDrawer:) stationId:[_translateListArray objectAtIndexGC:transIndex] counter:(int)transIndex max:(int)maxIndex];
            
        }
        else
        {
            // 끝
            //NSLog(@"%@", [OllehMapStatus sharedOllehMapStatus].subwayExistArr);
            
            int transMax = (int)maxIndex;
            
            [self drawPopupTop];
            
            switch (transMax) {
                case 1:
                    [self drawTranslateBtn1];
                    [self drawTrans1];
                    break;
                case 2:
                    [self drawTranslateBtn1];
                    [self drawTranslateBtn2];
                    [self drawTrans2];
                    break;
                case 3:
                    [self drawTranslateBtn1];
                    [self drawTranslateBtn2];
                    [self drawTranslateBtn3];
                    [self drawTrans3];
                    break;
                default:
                    break;
            }
        }
        
    }
    else
    {
        
    }
}
- (void) drawPopupTop
{
    [self.view addSubview:_translatePopView];
    
    // 맨위꺼 그리기
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    
    
    int lineNum = [[[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary objectForKeyGC:@"LANEID"] intValue];
    
    [_currentStationLine setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self getSubwaySmallImg:lineNum]]]];
    
    [_currentStationLine setFrame:CGRectMake(45, 14, [self getSubwaySmallImgWidth:lineNum], 18)];
    
    [_currentStation setFrame:CGRectMake(45 + [self getSubwaySmallImgWidth:lineNum] + 6, 15, 137, 15)];
    [_currentStation setText:[[OllehMapStatus sharedOllehMapStatus].subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
    
}
- (void) drawTranslateBtn1
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_translate1RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    
    int trans1 = 0;
    
    trans1 = [[oms.subwayExistArr objectAtIndexGC:0] intValue];
    
    [_translate1StationLine setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self getSubwaySmallImg:trans1]]]];
    
    [_translate1StationLine setFrame:CGRectMake(45, 14, [self getSubwaySmallImgWidth:trans1], 18)];
    
    [_translate1Station setFrame:CGRectMake(45 + [self getSubwaySmallImgWidth:trans1] + 6, 15, 137, 15)];
    [_translate1Station setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
    
    
}
- (void) drawTrans1
{
    [_translateSecondStation setHidden:YES];
    [_translateThirdStation setHidden:YES];
    [_translateModalView setFrame:CGRectMake(58, 124, 205, 229 - (90/2 + 4/2))];
    [_translateModalBg setFrame:CGRectMake(0, 0, 205, 229 - (90/2 + 4/2))];
    [_cancelBtn setFrame:CGRectMake(58, 182 - (90/2 + 4/2), 88, 32)];
    [_translateCurrentStation setFrame:CGRectMake(2, 31, 201, 45)];
    [_translateFirstStation setFrame:CGRectMake(2, 78, 201, 45)];
    [_tUnderLine3 setHidden:YES];
    [_tUnderLine4 setHidden:YES];
}
- (void) drawTranslateBtn2
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_translate2RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    
    int trans2 = 0;
    
    trans2 = [[oms.subwayExistArr objectAtIndexGC:1] intValue];
    
    [_translate2StationLine setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self getSubwaySmallImg:trans2]]]];
    [_translate2StationLine setFrame:CGRectMake(45, 14, [self getSubwaySmallImgWidth:trans2], 18)];
    [_translate2Station setFrame:CGRectMake(45 + [self getSubwaySmallImgWidth:trans2] + 6, 15, 137, 15)];
    [_translate2Station setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
    
}
- (void) drawTrans2
{
    [_translateModalView setFrame:CGRectMake(58, 124, 205, 229)];
    [_translateModalBg setFrame:CGRectMake(0, 0, 205, 229)];
    [_translateSecondStation setHidden:NO];
    [_translateThirdStation setHidden:YES];
    [_cancelBtn setFrame:CGRectMake(58, 182, 88, 32)];
    [_translateCurrentStation setFrame:CGRectMake(2, 31, 201, 45)];
    [_translateFirstStation setFrame:CGRectMake(2, 78, 201, 45)];
    [_translateSecondStation setFrame:CGRectMake(2, 125, 201, 45)];

    
    [_tUnderLine3 setHidden:NO];
    [_tUnderLine4 setHidden:YES];
}
- (void) drawTranslateBtn3
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_translate3RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    
    int trans3 = 0;
    
    trans3 = [[oms.subwayExistArr objectAtIndexGC:2] intValue];
    
    [_translate3StationLine setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@", [self getSubwaySmallImg:trans3]]]];
    [_translate3StationLine setFrame:CGRectMake(45, 14, [self getSubwaySmallImgWidth:trans3], 18)];
    [_translate3Station setFrame:CGRectMake(45 + [self getSubwaySmallImgWidth:trans3] + 6, 15, 137, 15)];
    [_translate3Station setText:[oms.subwayDetailDictionary objectForKeyGC:@"SST_NAME"]];
}
- (void) drawTrans3
{
    [_translateModalView setFrame:CGRectMake(58, 124, 205, 229 + (90/2 + 4/2))];
    [_translateModalBg setFrame:CGRectMake(0, 0, 205, 229 + (90/2 + 4/2))];
    [_translateSecondStation setHidden:NO];
    [_translateThirdStation setHidden:NO];
    [_cancelBtn setFrame:CGRectMake(58, 182 + (90/2 + 4/2) , 88, 32)];
    [_translateCurrentStation setFrame:CGRectMake(2, 31, 201, 45)];
    [_translateFirstStation setFrame:CGRectMake(2, 78, 201, 45)];
    [_translateSecondStation setFrame:CGRectMake(2, 125, 201, 45)];
    [_translateThirdStation setFrame:CGRectMake(2, 172, 201, 45)];

    [_tUnderLine3 setHidden:NO];
    [_tUnderLine4 setHidden:NO];
    
}

- (int) getSubwaySmallImgWidth :(int) number
{
    int imgWidth;
    
    if(number == 21 || number == 71 || number == 72 || number == 73 || number == 74 || number == 79 || number == 41 || number == 42 || number == 31 || number == 32 || number == 107)
    {
        imgWidth = 40;
    }
    else
    {
        imgWidth = 29;
    }
    
    return imgWidth;
}
// 이미지 스트링
- (NSString *) getSubwaySmallImg :(int) number
{
    NSString *imgStr = nil;
    
    if(number == 1)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_02.png"];
    }
    else if(number == 2)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_03.png"];
    }
    else if(number == 3)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_04.png"];
    }
    else if(number == 4)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_05.png"];
    }
    else if(number == 5)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_06.png"];
    }
    else if(number == 6)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_07.png"];
    }
    else if(number == 7)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_08.png"];
    }
    else if(number == 8)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_09.png"];
    }
    else if(number == 9)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_10.png"];
    }
    
    // 분당선
    else if(number == 100)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_11.png"];
        
    }
    // 신분당선
    else if(number == 109)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_12.png"];
    }
    // 중앙선
    else if(number == 103)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_13.png"];
    }
    // 공항철도
    else if(number == 101)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_14.png"];
    }
    // 인천1호선
    else if(number == 21)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_15.png"];
    }
    // 경의선
    else if(number == 104)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_16.png"];
    }
    // 용인경전철
    else if (number == 107)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_45.png"];
    }
    // 경춘선
    else if(number == 108)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_17.png"];
    }
    // 부산1호선
    else if(number == 71)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_18.png"];
    }
    // 부산2호선
    else if(number == 72)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_19.png"];
    }
    // 부산3호선
    else if(number == 73)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_20.png"];
    }
    // 부산 4호선!!!!!
    else if(number == 74)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_21.png"];
    }
    
    // 부산김해 경전철
    else if(number == 79)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_22.png"];
    }
    // 대구1호선
    else if(number == 41)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_23.png"];
    }
    // 대구2호선
    else if(number == 42)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_24.png"];
    }
    // 대전1호선
    else if(number == 31)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_25.png"];
    }
    // 광주1호선
    else if(number == 51)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_26.png"];
    }
    // 수인선
    else if(number == 111)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_42.png"];
    }
    // 의정부경전철
    else if(number == 110)
    {
        imgStr = [NSString stringWithFormat:@"info_icon_43.png"];
    }
    
    return imgStr;
    
}

#pragma mark -
#pragma mark - 환승역 액션
- (void)translate1BtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSLog(@"1번");
    
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate1RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    
    NSString *masterID = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID1"];
    
    [_translatePopView removeFromSuperview];
    
    [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestTrafficSubwayDetailRefresh:) stationId:masterID];
    
}
- (void)translate1BtnClickUp:(id)sender
{
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate1RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
}
- (void)translate1BtnClickDown:(id)sender
{
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    [_translate1RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    
}
- (void)translate2BtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSLog(@"2번");
    
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate2RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    
    NSString *masterID = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID2"];
    
    [_translatePopView removeFromSuperview];
    
    [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestTrafficSubwayDetailRefresh:) stationId:masterID];
}
- (void)translate2BtnClickUp:(id)sender
{
    
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate2RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
}
- (void)translate2BtnClickDown:(id)sender
{
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    [_translate2RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
}
- (void)translate3BtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSLog(@"3번");
    
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate3RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    
    NSString *masterID = [oms.subwayDetailDictionary objectForKeyGC:@"EXSTID3"];
    
    [_translatePopView removeFromSuperview];
    
    [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestTrafficSubwayDetailRefresh:) stationId:masterID];
}
- (void)translate3BtnClickUp:(id)sender
{
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
    [_translate3RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
}
- (void)translate3BtnClickDown:(id)sender
{
    [_currentStationRadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"]];
    [_translate3RadioImg setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"]];
}

- (void)cancelBtnClick:(id)sender
{
    [_translatePopView removeFromSuperview];
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
