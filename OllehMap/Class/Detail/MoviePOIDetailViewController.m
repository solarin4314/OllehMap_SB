//
//  MoviePOIDetailViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 4..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "MoviePOIDetailViewController.h"

@interface MoviePOIDetailViewController ()

@end

@implementation MoviePOIDetailViewController

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
    [_mapBtn setHidden:NO];
    [_mapBtn setHidden:!_displayMapBtn];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    _viewStartY = GeneralStartY;
    _expend = NO;
    
    [self initer];
    [self saveRecentSearch];
    
    NSLog(@"영화관poi정보 : %@", oms.poiDetailDictionary);
    
    NSString *mId = [oms.poiDetailDictionary objectForKeyGC:@"ORG_DB_ID"];
    
    
    
    NSLog(@"mId : %@", mId);
    
    [oms.movieListDictionary removeAllObjects];
    
    [[ServerConnector sharedServerConnection] requestMovieInfo:self action:@selector(finishRequestMovieInfo:) mId:(NSString *)mId];
}
- (void) initer
{
    _mainInfoLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    UILabel *mainLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 280, 14)];
    [mainLbl setText:@"주요정보"];
    [mainLbl setFont:[UIFont boldSystemFontOfSize:14]];
    [_mainInfoLabelView addSubview:mainLbl];
    
    _nullMainInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    UILabel *nullMainLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    [nullMainLbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [nullMainLbl setText:NSLocalizedString(@"Msg_Detail_MainNull", @"")];
    [nullMainLbl setFont:[UIFont systemFontOfSize:13]];
    [nullMainLbl setTextAlignment:NSTextAlignmentCenter];
    [_nullMainInfoView addSubview:nullMainLbl];
    
    _mainInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
    _notExtendLabel = [[UILabel alloc] init];
    [_notExtendLabel setFrame:CGRectMake(10, 0, 280, 32)];
    [_notExtendLabel setFont:[UIFont systemFontOfSize:13]];
    [_notExtendLabel setNumberOfLines:2];
    [_notExtendLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_mainInfoView addSubview:_notExtendLabel];
    
    _extendLabel = [[UILabel alloc] init];
    [_extendLabel setFrame:CGRectMake(10, 0, 280, 32)];
    [_extendLabel setFont:[UIFont systemFontOfSize:13]];
    [_extendLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_mainInfoView addSubview:_extendLabel];
    [_extendLabel setHidden:YES];
    
    
    _extendBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_extendBtn setFrame:CGRectMake(0, 32, 320, 26)];
    [_extendBtn addTarget:self action:@selector(extendBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_extendBtn setHidden:YES];
    [_mainInfoView addSubview:_extendBtn];
    
    _extendBtnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_list_down_icon.png"]];
    [_extendBtnImg setFrame:CGRectMake(153, 39, 15, 8)];
    [_extendBtnImg setHidden:YES];
    [_mainInfoView addSubview:_extendBtnImg];
    
    
    _underLine5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    UIImageView *line5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    [line5 setFrame:CGRectMake(0, 0, 320, 1)];
    [_underLine5 addSubview:line5];
    
    _movieLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 35)];
    UILabel *movieLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 54, 14)];
    [movieLbl setText:@"상영정보"];
    [movieLbl setFont:[UIFont boldSystemFontOfSize:14]];
    [_movieLabelView addSubview:movieLbl];
    
    _supportLabel = [[UILabel alloc] initWithFrame:CGRectMake(70, 11, 100, 11)];
    [_supportLabel setText:@"(맥스무비 제공)"];
    [_supportLabel setFont:[UIFont systemFontOfSize:11]];
    [_supportLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_movieLabelView addSubview:_supportLabel];
    
    _homePageBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_homePageBtn setImage:[UIImage imageNamed:@"homepage_btn.png"] forState:UIControlStateNormal];
    [_homePageBtn setFrame:CGRectMake(250, 7, 60, 21)];
    [_homePageBtn addTarget:self action:@selector(movieHomepageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_movieLabelView addSubview:_homePageBtn];
    
    _movieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    _nullMovieView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    _nullMoveLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 80)];
    [_nullMoveLbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_nullMoveLbl setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
    [_nullMoveLbl setTextAlignment:NSTextAlignmentCenter];
    [_nullMoveLbl setFont:[UIFont systemFontOfSize:13]];
    [_nullMovieView addSubview:_nullMoveLbl];
    
    
    _underLine6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    UIImageView *line6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    [line6 setFrame:CGRectMake(0, 0, 320, 1)];
    [_underLine6 addSubview:line6];
    
    _detailTrafficLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    _detailTrafficLabelBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_2tab_01.png"]];
    [_detailTrafficLabelBg setFrame:CGRectMake(0, 0, 320, 36)];
    [_detailTrafficLabelView addSubview:_detailTrafficLabelBg];
    
    _detailLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 160, 36)];
    [_detailLabel setText:@"상세정보"];
    [_detailLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_detailLabel setTextAlignment:NSTextAlignmentCenter];
    [_detailTrafficLabelView addSubview:_detailLabel];
    
    _detailBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_detailBtn setFrame:CGRectMake(0, 0, 160, 36)];
    [_detailBtn setSelected:YES];
    [_detailBtn addTarget:self action:@selector(detailBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_detailTrafficLabelView addSubview:_detailBtn];
    
    _trafficLabel = [[UILabel alloc] initWithFrame:CGRectMake(160, 0, 160, 36)];
    [_trafficLabel setText:@"교통정보"];
    [_trafficLabel setTextColor:convertHexToDecimalRGBA(@"59", @"59", @"59", 1.0)];
    [_trafficLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_trafficLabel setTextAlignment:NSTextAlignmentCenter];
    [_detailTrafficLabelView addSubview:_trafficLabel];
    
    _trafficBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_trafficBtn setFrame:CGRectMake(160, 0, 160, 36)];
    [_trafficBtn setSelected:YES];
    [_trafficBtn addTarget:self action:@selector(trafficBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_detailTrafficLabelView addSubview:_trafficBtn];
    
    
    
    _detailOptionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    
    _reservationImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_01.png"]];
    [_reservationImg setFrame:CGRectMake(10, 10, 33, 17)];
    [_detailOptionView addSubview:_reservationImg];
    
    
    _underLine7 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    UIImageView *line7 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_list_line_02.png"]];
    [line7 setFrame:CGRectMake(0, 0, 320, 1)];
    [_underLine7 addSubview:line7];
    
    
    _detailView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    _trafficView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 460)];
    
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    UIButton *favoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoBtn setImage:[UIImage imageNamed:@"poi_botton_btn_01.png"] forState:UIControlStateNormal];
    [favoBtn setFrame:CGRectMake(0, 0, 107, 37)];
    [favoBtn addTarget:self action:@selector(favoriteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:favoBtn];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setImage:[UIImage imageNamed:@"poi_botton_btn_02.png"] forState:UIControlStateNormal];
    [contactBtn setFrame:CGRectMake(107, 0, 106, 37)];
    [contactBtn addTarget:self action:@selector(contactBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:contactBtn];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setImage:[UIImage imageNamed:@"poi_botton_btn_03.png"] forState:UIControlStateNormal];
    [modifyBtn setFrame:CGRectMake(213, 0, 107, 37)];
    [modifyBtn addTarget:self action:@selector(infoModifyAskBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:modifyBtn];
    
    self.addrNewStr = stringValueOfDictionary([OllehMapStatus sharedOllehMapStatus].searchLocalDictionary, @"LastExtendNewAddr");
    
}
- (void) saveRecentSearch
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *ujName = [oms.poiDetailDictionary objectForKeyGC:@"UJ_NAME"];
    // 최근리스트 저장
    
    NSMutableDictionary *generalPOIDic = [NSMutableDictionary dictionary];
    
    Coord poiCrd;
    
    poiCrd = CoordMake([[oms.poiDetailDictionary objectForKeyGC:@"X"] doubleValue], [[oms.poiDetailDictionary objectForKeyGC:@"Y"] doubleValue]);
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    NSString *tel = [oms.poiDetailDictionary objectForKeyGC:@"TEL"];
    
    if(tel == nil)
        tel = @"";
    
    @try
    {
        
        NSString *recentName = _themeToDetailName;
        
        // ver3테스트2번버그(최근검색에서도 상세이름까지 나오도록...)
        if(!recentName || [recentName isEqualToString:@""])
        {
            recentName = [oms.poiDetailDictionary objectForKey:@"NAME"];
        }
        
        [generalPOIDic setObject:recentName forKey:@"NAME"];
        [generalPOIDic setObject:[oms ujNameSegment:ujName] forKey:@"CLASSIFY"];
        [generalPOIDic setValue:[NSNumber numberWithDouble:xx] forKey:@"X"];
        [generalPOIDic setValue:[NSNumber numberWithDouble:yy] forKey:@"Y"];
        [generalPOIDic setObject:@"MV" forKey:@"TYPE"];
        [generalPOIDic setObject:[oms.poiDetailDictionary objectForKeyGC:@"POI_ID"] forKey:@"ID"];
        [generalPOIDic setObject:tel forKey:@"TEL"];
        [generalPOIDic setObject:[oms.poiDetailDictionary objectForKeyGC:@"ADDR"] forKey:@"ADDR"];
        [generalPOIDic setObject:[NSNumber numberWithInt:Favorite_IconType_POI] forKey:@"ICONTYPE"];
        
        [oms addRecentSearch:generalPOIDic];
        
    }
    @catch (NSException *exception)
    {
        [OMMessageBox showAlertMessage:@"" :[NSString stringWithFormat:@"%@", exception]];
        
    }
    // 최근리스트 저장 끝
    
}
- (void) drawTopView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 최상단 뷰(이름, 주소, 분류, 이미지)
    int topViewHeight = 90;
    
    UIView *topView = [[UIView alloc] init];
    [topView setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:244.0/255.0 blue:255.0/255.0 alpha:1]];
    
    UIImageView *poiImg = [[UIImageView alloc] init];
    [poiImg setFrame:CGRectMake(10, 10, 70, 70)];
    [poiImg setImage:[UIImage imageNamed:@"view_no_img_box.png"]];
    
    NSString *imageUrl = [oms.poiDetailDictionary objectForKeyGC:@"IMG_URL"];
    
    
    // 이미지가 있으면 이미지를 그린다
	if (imageUrl)
    {
        [poiImg setImage:[oms urlGetImage:imageUrl]];
	}
    
    
    [topView addSubview:poiImg];
    
    
    UIImageView *poiImgBox = [[UIImageView alloc] init];
    [poiImgBox setFrame:CGRectMake(10, 10, 70, 70)];
    [poiImgBox setImage:[UIImage imageNamed:@"view_img_box.png"]];
    [topView addSubview:poiImgBox];
    
    
    UILabel *poiName = [[UILabel alloc] init];
    [poiName setFrame:CGRectMake(90, 16, 220, 17)];
    [poiName setText:[oms.poiDetailDictionary objectForKeyGC:@"NAME"]];
    [poiName setFont:[UIFont boldSystemFontOfSize:17]];
    [poiName setAdjustsFontSizeToFitWidth:YES];
    [poiName setNumberOfLines:1];
    [poiName setBackgroundColor:[UIColor clearColor]];
    [topView addSubview:poiName];
    
    NSString *roadAddrDoGu = stringValueOfDictionary(oms.poiDetailDictionary, @"M_NEWADDR1");
    NSString *roadAddr = stringValueOfDictionary(oms.poiDetailDictionary, @"ROAD_NAME");
    NSString *roadBuildNo = stringValueOfDictionary(oms.poiDetailDictionary, @"BUILD_NO");
    
    NSString *zibunAddr = stringValueOfDictionary(oms.poiDetailDictionary, @"ADDR");
    
    int segmentHeight = 60;
    
    if([roadAddrDoGu isEqualToString:@""])
    {
        // 지번주소이미지
        UIImageView *subImg = [[UIImageView alloc] init];
        [subImg setImage:[UIImage imageNamed:@"old_address_icon.png"]];
        [subImg setFrame:CGRectMake(90, 40, 33, 15)];
        
        [topView addSubview:subImg];
        
        UILabel *poiAdd = [[UILabel alloc] initWithFrame:CGRectMake(127, 40, 183, 13)];
        [poiAdd setText:zibunAddr];
        [poiAdd setFont:[UIFont systemFontOfSize:13]];
        [poiAdd setAdjustsFontSizeToFitWidth:YES];
        [poiAdd setNumberOfLines:1];
        [poiAdd setBackgroundColor:[UIColor clearColor]];
        [topView addSubview:poiAdd];
    }
    else
    {
        UILabel *poiNewAdd = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 220, 13)];
        [poiNewAdd setText:[NSString stringWithFormat:@"%@ %@ %@", roadAddrDoGu, roadAddr, roadBuildNo]];
        [poiNewAdd setFont:[UIFont systemFontOfSize:13]];
        [poiNewAdd setAdjustsFontSizeToFitWidth:YES];
        [poiNewAdd setNumberOfLines:1];
        [poiNewAdd setBackgroundColor:[UIColor clearColor]];
        [topView addSubview:poiNewAdd];
        
        // 지번주소
        
        // 지번주소이미지
        UIImageView *subZiImg = [[UIImageView alloc] init];
        [subZiImg setImage:[UIImage imageNamed:@"old_address_icon.png"]];
        [subZiImg setFrame:CGRectMake(90, poiNewAdd.frame.origin.y + poiNewAdd.frame.size.height + 6 - 1, 33, 15)];
        
        [topView addSubview:subZiImg];
        
        UILabel *poiAdd = [[UILabel alloc] initWithFrame:CGRectMake(127, poiNewAdd.frame.origin.y +poiNewAdd.frame.size.height + 6 - 1, 183, 13)];
        [poiAdd setText:zibunAddr];
        [poiAdd setFont:[UIFont systemFontOfSize:13]];
        [poiAdd setAdjustsFontSizeToFitWidth:YES];
        [poiAdd setNumberOfLines:1];
        [poiAdd setBackgroundColor:[UIColor clearColor]];
        [topView addSubview:poiAdd];
        
        segmentHeight += 13 + 5;
        topViewHeight = 106;
    }
    
    UILabel *poiUj = [[UILabel alloc] initWithFrame:CGRectMake(90, segmentHeight, 220, 13)];
    [poiUj setText:[oms.poiDetailDictionary objectForKeyGC:@"UJ_NAME"]];
    [poiUj setFont:[UIFont systemFontOfSize:13]];
    [poiUj setAdjustsFontSizeToFitWidth:YES];
    [poiUj setNumberOfLines:1];
    [poiUj setBackgroundColor:[UIColor clearColor]];
    [poiUj setTextColor:[UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    [topView addSubview:poiUj];
    
    
    [topView setFrame:CGRectMake(0, 0, 320, topViewHeight)];

    // 스크롤 뷰에 상단뷰 추가
    [_scrollView addSubview:topView];
    
    _viewStartY += topView.frame.size.height;
    
    [self drawUnderLine1];
    
}
// 상단뷰 밑줄
- (void) drawUnderLine1
{
    // 스크롤뷰에 밑줄뷰 추가
    
    UIImageView *underLine = [[UIImageView alloc] init];
    [underLine setFrame:CGRectMake(0, _viewStartY, 320, 1)];
    [underLine setImage:[UIImage imageNamed:@"poi_list_line_01.png"]];
    [_scrollView addSubview:underLine];
    
    _viewStartY += underLine.frame.size.height;
    
    [self drawTelView];
}

- (void) drawTelView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    UIView *telView = [[UIView alloc] init];
    [telView setFrame:CGRectMake(0, _viewStartY, 320, 40)];
    
    // 버튼
    UIButton *telBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [telBtn setFrame:CGRectMake(0, 0, 320, 40)];
    [telBtn setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [telBtn addTarget:self action:@selector(telBtnClickMv:) forControlEvents:UIControlEventTouchUpInside];
    [telView addSubview:telBtn];
    
    // 전번이미지
    UIImageView *telImg = [[UIImageView alloc] init];
    [telImg setFrame:CGRectMake(7, 10, 20, 20)];
    [telImg setImage:[UIImage imageNamed:@"view_list_b_call.png"]];
    [telView addSubview:telImg];
    
    
    // 전번라벨
    UILabel *telLabel = [[UILabel alloc] init];
    [telLabel setFrame:CGRectMake(35, 13, 260, 15)];
    [telLabel setText:[oms.poiDetailDictionary objectForKeyGC:@"TEL"]];
    [telLabel setBackgroundColor:[UIColor clearColor]];
    [telLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [telLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [telView addSubview:telLabel];
    
    
    // 애로우버튼
    UIImageView *arrowImg = [[UIImageView alloc] init];
    [arrowImg setFrame:CGRectMake(303, 14, 7, 12)];
    [arrowImg setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [telView addSubview:arrowImg];
    
    
    // 전화번호가 없으면 히든
    if([oms.poiDetailDictionary objectForKeyGC:@"TEL"] == nil)
    {
        [telView setHidden:YES];
        
        [self drawHomePageView];
    }
    else
    {
        // 스크롤뷰에 추가
        [_scrollView addSubview:telView];
        
        _viewStartY += telView.frame.size.height;
        
        [self drawUnderLine2];
    }
    
    // 전화번호 뷰 끝
}

-(void) drawUnderLine2
{
    // 스크롤뷰에 추가
    
    UIImageView *underLine2 = [[UIImageView alloc] init];
    [underLine2 setFrame:CGRectMake(0, _viewStartY, 320, 1)];
    [underLine2 setImage:[UIImage imageNamed:@"poi_list_line_02.png"]];
    
    
    [_scrollView addSubview:underLine2];
    
    _viewStartY += underLine2.frame.size.height;
    
    [self drawHomePageView];
    
}

-(void) drawHomePageView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    UIView *homeView = [[UIView alloc] init];
    [homeView setFrame:CGRectMake(0, _viewStartY, 320, 40)];
    
    
    // 홈피버튼
    UIButton *homeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [homeBtn setFrame:CGRectMake(0, 0, 320, 40)];
    [homeBtn setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [homeBtn addTarget:self action:@selector(homePageBtnClickMv:) forControlEvents:UIControlEventTouchUpInside];
    [homeView addSubview:homeBtn];
    
    // 홈피이미지
    UIImageView *homeImg = [[UIImageView alloc] init];
    [homeImg setFrame:CGRectMake(7, 10, 20, 20)];
    [homeImg setImage:[UIImage imageNamed:@"view_list_address.png"]];
    [homeView addSubview:homeImg];
    
    
    // 홈피라벨
    
    UILabel *homeLabel = [[UILabel alloc] init];
    [homeLabel setBackgroundColor:[UIColor clearColor]];
    // y, 높이 -3 + 3
    [homeLabel setFrame:CGRectMake(35, 10, 260, 18)];
    
    
    NSString *url = [oms.poiDetailDictionary objectForKeyGC:@"URL"];
    
    [homeLabel setText:[oms urlValidCheck:url]];
    
    [homeLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [homeLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [homeView addSubview:homeLabel];
    
    
    
    
    // 홈페이지가 없으면 히든
    if([oms.poiDetailDictionary objectForKeyGC:@"URL"] == nil)
    {
        [homeView setHidden:YES];
        
        
        [self drawBtnView];
    }
    else
    {
        
        [_scrollView addSubview:homeView];
        
        //NSLog(@"viewStartY : %d", _viewStartY);
        _viewStartY += homeView.frame.size.height;
        
        [self drawUnderLine3];
    }
    
}

- (void) drawUnderLine3
{
    
    UIImageView *underLine3 = [[UIImageView alloc] init];
    [underLine3 setFrame:CGRectMake(0, _viewStartY, 320, 1)];
    [underLine3 setImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    [_scrollView addSubview:underLine3];
    
    
    _viewStartY += underLine3.frame.size.height;
    
    [self drawBtnView];
    
}

// 버튼뷰 그리기
- (void) drawBtnView
{
    // 버튼 뷰
    
    UIView *btnView = [[UIView alloc] init];
    [btnView setFrame:CGRectMake(0, _viewStartY, 320, 56)];
    
    UIImageView *btnBg = [[UIImageView alloc] init];
    [btnBg setFrame:CGRectMake(0, 0, 320, 56)];
    [btnBg setImage:[UIImage imageNamed:@"poi_list_menu_bg.png"]];
    [btnView addSubview:btnBg];
    
    
    // 각 버튼
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [startBtn setFrame:CGRectMake(10, 9, 81, 37)];
    [startBtn setImage:[UIImage imageNamed:@"poi_list_btn_start.png"] forState:UIControlStateNormal];
    [startBtn addTarget:self action:@selector(startBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:startBtn];
    
    UIButton *destBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [destBtn setFrame:CGRectMake(96, 9, 81, 37)];
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop.png"] forState:UIControlStateNormal];
    [destBtn addTarget:self action:@selector(destBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:destBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [shareBtn setFrame:CGRectMake(182, 9, 61, 37)];
    [shareBtn setImage:[UIImage imageNamed:@"poi_list_btn_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:shareBtn];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [naviBtn setFrame:CGRectMake(248, 9, 61, 37)];
    [naviBtn setImage:[UIImage imageNamed:@"poi_list_btn_navi.png"] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(naviBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [btnView addSubview:naviBtn];
    
    
    [_scrollView addSubview:btnView];
    
    _viewStartY += btnView.frame.size.height;
    
    _nullStartY = _viewStartY;
    
    //[self drawUnderLine4];
    [self drawMainInfoLabelView];
    // 버튼 뷰 끝
    
}

// 주요정보 라벨 그리기
- (void) drawMainInfoLabelView
{
    
    [_mainInfoLabelView setFrame:CGRectMake(X_VALUE, _viewStartY, _mainInfoLabelView.frame.size.width, _mainInfoLabelView.frame.size.height)];
    [_scrollView addSubview:_mainInfoLabelView];
    
    //OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 너비, 높이
    
    
    _viewStartY = _viewStartY + _mainInfoLabelView.frame.size.height;
    
    [self drawMainInfoView];
}

- (void) drawMainInfoView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *rawStr = [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"HISTORY"];
    
    NSString *refindStr = [rawStr gtm_stringByUnescapingFromHTML];
    
    [_notExtendLabel setText:refindStr];
    
    CGFloat mainInfoViewWidth = CGRectGetWidth(_mainInfoView.bounds);
    CGFloat mainInfoViewHeight = CGRectGetHeight(_mainInfoView.bounds);
    
    _mainInfoViewNotExpendWidth = mainInfoViewWidth;
    _mainInfoViewNotExpendHeight = mainInfoViewHeight;
    
    if([[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"HISTORY"] == nil)
    {
        [_nullMainInfoView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _nullMainInfoView.frame.size.height)];
        [_scrollView addSubview:_nullMainInfoView];
        
        [_mainInfoView setHidden:YES];
        
        _viewStartY += _nullMainInfoView.frame.size.height;
        
        
    }
    else {
        [_notExtendLabel setHidden:NO];
        [_extendBtn setHidden:NO];
        [_extendBtnImg setHidden:NO];
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _mainInfoView.frame.size.height)];
        
        [_scrollView addSubview:_mainInfoView];
        
        _expend = YES;
        
        _prevViewStartY = _viewStartY;
        _viewStartY += _mainInfoView.frame.size.height;
        
    }
    
    [self drawUnderLine5];
    
}

- (void)extendBtnClick:(id)sender
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    if(_expend == YES)
    {
        [_notExtendLabel setHidden:YES];
        [_extendLabel setHidden:NO];
        
        // 너비, 높이
        CGRect mainInfoViewbounds = _mainInfoView.bounds;
        CGFloat mainInfoViewWidth = CGRectGetWidth(mainInfoViewbounds);
        CGFloat mainInfoViewHeight = 0; // mainInfoViewHeight 변수에 값을 할당한뒤에 한번도 사용하지 않고 있음.. 그럴땐 0으로 초기화 :: CGRectGetHeight(mainInfoViewbounds);
        
        
        NSString *rawStr = [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"HISTORY"];
        
        NSString *refindStr = [rawStr gtm_stringByUnescapingFromHTML];
        
        [_extendLabel setText:refindStr];
        
        [_extendLabel setNumberOfLines:0];
        [_extendLabel setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize extendLabelSize = [_extendLabel.text sizeWithFont:_extendLabel.font constrainedToSize:CGSizeMake(280, FLT_MAX) lineBreakMode:_extendLabel.lineBreakMode];
        
        CGRect newFrame = _extendLabel.frame;
        newFrame.size.height = extendLabelSize.height + 16;
        _extendLabel.frame = newFrame;
        
        mainInfoViewHeight = newFrame.size.height + 26;
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _prevViewStartY, mainInfoViewWidth, mainInfoViewHeight)];
        [_extendBtn setFrame:CGRectMake(X_VALUE, mainInfoViewHeight - 26, X_WIDTH, 26)];
        [_extendBtnImg setFrame:CGRectMake(153, mainInfoViewHeight - 8 - 15, 15, 8)];
        [_extendBtnImg setImage:[UIImage imageNamed:@"view_list_up_icon.png"]];
        
        _expend = NO;
        
        _viewStartY = _prevViewStartY + mainInfoViewHeight;
        
        
        
        [self drawUnderLine5];
        
    }
    else if(_expend == NO)
    {
        [_notExtendLabel setHidden:NO];
        [_extendLabel setHidden:YES];
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _prevViewStartY, _mainInfoViewNotExpendWidth, _mainInfoViewNotExpendHeight)];
        [_extendBtn setFrame:CGRectMake(X_VALUE, 32, X_WIDTH, 24)];
        [_extendBtnImg setFrame:CGRectMake(153, 39, 15, 8)];
        [_extendBtnImg setImage:[UIImage imageNamed:@"view_list_down_icon.png"]];
        
        _expend = YES;
        
        _viewStartY = _prevViewStartY + _mainInfoViewNotExpendHeight;
        
        [self drawUnderLine5];
    }
    
    //NSLog(@"뷰스타트 : %d", _viewStartY);
    
    
    
}

// 주요정보 뷰 밑줄
- (void) drawUnderLine5
{
    [_scrollView addSubview:_underLine5];
    //NSLog(@"뷰스타트 밑줄5 : %d", _viewStartY);
    if(_expend == YES)
    {
        [_underLine5 setFrame:CGRectMake(X_VALUE, _viewStartY, _underLine5.frame.size.width, _underLine5.frame.size.height)];
        
        _viewStartY = _viewStartY + _underLine5.frame.size.height;
        
        
    }
    
    else if(_expend == NO) {
        [_underLine5 setFrame:CGRectMake(X_VALUE, _viewStartY, _underLine5.frame.size.width, _underLine5.frame.size.height)];
        _viewStartY = _viewStartY + _underLine5.frame.size.height;
        
        
    }
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    NSString *mId = [oms.poiDetailDictionary objectForKeyGC:@"ORG_DB_ID"];
    
    //NSLog(@"dddddddd : %@", oms.movieListDictionary);
    
    if([oms.movieListDictionary count] > 0)
    {
        [self drawMovieListView];
        
    }
    else {
        [[ServerConnector sharedServerConnection] requestMovieList:self action:@selector(finishRequestMovieList:) mId:(NSString *)mId];
    }
    
    
    
}

- (void)finishRequestMovieInfo:(id)request
{
    if ([request finishCode] == OMSRFinishCode_Completed)
	{
        [self drawTopView];
        
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

- (void) finishRequestMovieList:(id)request
{
    
    
        [self drawMovieListView];
        
    
    
}
- (void) drawMovieListView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_movieLabelView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 35)];
    [_movieLabelView setBackgroundColor:[UIColor colorWithRed:218.0/255.0 green:218.0/255.0 blue:218.0/255.0 alpha:1]];
    [_scrollView addSubview:_movieLabelView];
    //NSLog(@"뷰스타트상영정보라벨 : %d", _viewStartY);
    _viewStartY = _viewStartY + _movieLabelView.frame.size.height;
    
    for (UIView *view in _movieView.subviews)
    {
        [view removeFromSuperview];
    }
    
    
    NSArray *listArr = [oms.movieListDictionary objectForKeyGC:@"PlayMovieList"];
    
    if([listArr count] < 1)
    {
        [_supportLabel setHidden:YES];
        [_homePageBtn setHidden:YES];
        [_movieView setHidden:YES];
        [_nullMovieView setHidden:NO];
        [_nullMovieView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 66)];
        [_nullMoveLbl setFrame:CGRectMake(0, 0, 320, 66)];
        [_scrollView addSubview:_nullMovieView];
        
        _viewStartY = _viewStartY + _nullMovieView.frame.size.height;
    }
    else
    {
        [_supportLabel setHidden:NO];
        [_homePageBtn setHidden:NO];
        [_nullMovieView setHidden:YES];
        [_movieView setHidden:NO];
        
        //NSLog(@"영화리스트 : %@", listArr);
        
        int imgStartY = 13;
        int labelStartY = 14;
        
        UIColor *labelColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
        
        for (NSMutableDictionary *dic in listArr) {
            
            //NSLog(@"딕등급 : %@", [dic objectForKeyGC:@"GRADE"]);
            //NSLog(@"딕이름 : %@", [dic objectForKeyGC:@"MNAME"]);
            
            
            UIImageView *howOld = [[UIImageView alloc] initWithFrame:CGRectMake(10, imgStartY, 18, 15)];
            
            if([[dic objectForKeyGC:@"GRADE"] intValue] == 01)
            {
                [howOld setImage:[UIImage imageNamed:@"movie_age_all.png"]];
            }
            else if ([[dic objectForKeyGC:@"GRADE"] intValue] == 02) {
                [howOld setImage:[UIImage imageNamed:@"movie_age_12.png"]];
            }
            else if ([[dic objectForKeyGC:@"GRADE"] intValue] == 03) {
                [howOld setImage:[UIImage imageNamed:@"movie_age_15.png"]];
            }
            else if ([[dic objectForKeyGC:@"GRADE"] intValue] == 04) {
                [howOld setImage:[UIImage imageNamed:@"movie_age_18.png"]];
            }
            
            imgStartY += 21;
            
            UILabel *movieName = [[UILabel alloc] initWithFrame:CGRectMake(33, labelStartY, 277, 13)];
            
            [movieName setText:[dic objectForKeyGC:@"MNAME"]];
            [movieName setFont:[UIFont systemFontOfSize:13]];
            [movieName setTextColor:labelColor];
            
            labelStartY += 21;
            
            [_movieView addSubview:howOld];
            [_movieView addSubview:movieName];
            
        }
        
        // 경고라벨 Y축
        int waringLabelY = labelStartY + 15;
        
        UILabel *warning = [[UILabel alloc] init];
        
        
        [warning setText:@"(상영작 정보는 실제 상영정보와 다를 수 있으며, 버튼을 선택하면 맥스무비 홈페이지로 이동합니다.)"];
        [warning setFont:[UIFont systemFontOfSize:12]];
        [warning setTextColor:labelColor];
        [warning setLineBreakMode:NSLineBreakByWordWrapping];
        [warning setNumberOfLines:0];
        
        CGSize warnigSize = [warning.text sizeWithFont:warning.font constrainedToSize:CGSizeMake(300, FLT_MAX) lineBreakMode:warning.lineBreakMode];
        
        [warning setFrame:CGRectMake(10, waringLabelY, warnigSize.width, warnigSize.height)];
        
        [_movieView addSubview:warning];
        
        
        CGRect tempRect = _movieView.frame;
        tempRect.size.height = warning.frame.origin.y + warning.frame.size.height + 21;
        _movieView.frame = tempRect;
        
        [_movieView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _movieView.frame.size.height)];
        
        [_scrollView addSubview:_movieView];
        
        _viewStartY = _viewStartY + _movieView.frame.size.height;
        
        
    }
    
    
    
    [self drawUnderLine6];
}

- (void) drawUnderLine6
{
    
    // 스크롤뷰에 밑줄뷰 추가
    [_scrollView addSubview:_underLine6];
    
    [_underLine6 setFrame:CGRectMake(X_VALUE, _viewStartY, _underLine6.frame.size.width, _underLine6.frame.size.height)];
    _viewStartY = _viewStartY + _underLine6.frame.size.height;
    _detailY = _viewStartY;
    _trafficY = _viewStartY;
    
    [self drawDetailTrafficLabelView];
}

- (void) drawDetailTrafficLabelView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    if(_detailBtn.selected)
    {
        [_trafficView setHidden:YES];
        [_detailOptionView setHidden:NO];
        [_detailView setHidden:NO];
        [_detailTrafficLabelBg setImage:[UIImage imageNamed:@"poi_2tab_01.png"]];
        [_detailLabel setTextColor:[UIColor blackColor]];
        [_trafficLabel setTextColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1]];
        
        [_scrollView addSubview:_detailTrafficLabelView];
        [_detailTrafficLabelView setFrame:CGRectMake(X_VALUE, _detailY, _detailTrafficLabelView.frame.size.width, _detailTrafficLabelView.frame.size.height)];
        _viewStartY = _detailY + _detailTrafficLabelView.frame.size.height;
        
        //[self drawdetailOptionView];
        
        
        //NSLog(@"예약? %@", [oms.poiDetailDictionary objectForKeyGC:@"RESERVATION_YN"]);
        
        if([oms.poiDetailDictionary objectForKeyGC:@"RESERVATION_YN"] == nil)
        {
            [_detailOptionView setHidden:YES];
            [self drawdetailView];
        }
        else
        {
            [self drawOptionView];
        }
        
    }
    else if (_trafficBtn.selected)
    {
        [_detailOptionView setHidden:YES];
        [_detailView setHidden:YES];
        [_underLine7 setHidden:YES];
        [_trafficView setHidden:NO];
        [_detailTrafficLabelBg setImage:[UIImage imageNamed:@"poi_2tab_02.png"]];
        [_detailLabel setTextColor:[UIColor colorWithRed:89.0/255.0 green:89.0/255.0 blue:89.0/255.0 alpha:1]];
        [_trafficLabel setTextColor:[UIColor blackColor]];
        
        [_scrollView addSubview:_detailTrafficLabelView];
        [_detailTrafficLabelView setFrame:CGRectMake(X_VALUE, _trafficY, _detailTrafficLabelView.frame.size.width, _detailTrafficLabelView.frame.size.height)];
        _viewStartY = _trafficY + _detailTrafficLabelView.frame.size.height;
        
        [self drawTrafficView];
    }
    
    
    
    //[self drawScrollView];
}

-(void) drawOptionView
{
    
    // 리턴이 예약밖에 안옴....카드, 주차 이런거 안옴...
    [_scrollView addSubview:_detailOptionView];
    [_detailOptionView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _detailOptionView.frame.size.height)];
    
    _viewStartY = _viewStartY + _detailOptionView.frame.size.height;
    
    [self drawUnderLine7];
}

-(void) drawUnderLine7
{
    [_scrollView addSubview:_underLine7];
    [_underLine7 setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _underLine7.frame.size.height)];
    
    _viewStartY += _underLine7.frame.size.height;
    
    [self drawdetailView];
}

//상세정보 그려봄
-(void) drawdetailView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    for (UIView *view in _detailView.subviews)
    {
        [view removeFromSuperview];
    }
    //제목라벨정의(폰트13, x:10, width:64, height:13)
    UIFont *labFont = [UIFont boldSystemFontOfSize:13];
    int lblX = 10;
    int lblWidth = 64;
    int lblHeight = 13;
    
    //내용라벨(글씨색, 폰트13, x:92, width:218, height = 13)
    UIColor *contentColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
    UIFont *contentFont = [UIFont systemFontOfSize:13];
    
    int contentX = 92;
    int contentWidth = 218;
    int contentHeight = 13;
    
    // 라벨 처음 Y축
    int startY = 14;
    // 라벨사이의 간격
    int tempHeight = 40;
    
    //규모정보[ 제목 : (10, 14, 64, 13 고정) 내용 : (92, 14, 218, 13)]
    UILabel *scaleInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, 14, lblWidth, lblHeight)];
    [scaleInfoLabel setText:@"규모정보"];
    [scaleInfoLabel setFont:labFont];
    
    UILabel *scaleInfo = [[UILabel alloc] initWithFrame:CGRectMake(contentX, 14, contentWidth, contentHeight)];
    [scaleInfo setText:@"1"];
    [scaleInfo setFont:contentFont];
    [scaleInfo setTextColor:contentColor];
    
    // 널이면 규모정보 라벨 히든
    //    if([scaleInfo.text isEqualToString:@"1"])
    //    {
    [scaleInfoLabel setHidden:YES];
    [scaleInfo setHidden:YES];
    
    //    }
    //    // 아니면 y축은 간격만큼 증가
    //    else {
    //        startY += tempHeight;
    //    }
    
    // 실시간예매[ 제목 : (10, 54, 64, 13 고정) 내용 : (92, 54, 218, 13)]
    UILabel *realTimeLabel = [[UILabel alloc] init];
    [realTimeLabel setText:@"실시간예매"];
    [realTimeLabel setFont:labFont];
    CGSize sizeRealTimeLabel = [realTimeLabel.text sizeWithFont:realTimeLabel.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    [realTimeLabel setFrame:CGRectMake(lblX, startY, sizeRealTimeLabel.width, lblHeight)];
    
    UILabel *realTime = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentWidth, contentHeight)];
    
    // T 이면 실시간예매 가능
    if([[[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"IS_REALTIME"] isEqualToString:@"T"])
    {
        [realTime setText:@"가능"];
        [realTime setFont:contentFont];
        [realTime setTextColor:contentColor];
        
        startY += tempHeight;
    }
    // Y이면 불가능
    else if([[[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"IS_REALTIME"] isEqualToString:@"F"])
    {
        [realTime setText:@"불가능"];
        [realTime setFont:contentFont];
        [realTime setTextColor:contentColor];
        
        startY += tempHeight;
    }
    
    // 그 외의 값이 오면 히든
    else {
        [realTimeLabel setHidden:YES];
        [realTime setHidden:YES];
    }
    
    // 예매취소[ 제목 : (10, 94, 64, 13 고정) 내용 : (92, 94, 218, 13)]
    UILabel *cancelReservLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, startY, lblWidth, lblHeight)];
    [cancelReservLabel setText:@"예매취소"];
    [cancelReservLabel setFont:labFont];
    
    UILabel *cancelReserv = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentWidth, contentHeight)];
    NSString *cancelTime = [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"RCTTIME"];
    [cancelReserv setText:[NSString stringWithFormat:@"%@ %@ %@", @"상영" ,cancelTime, @"까지"]];
    [cancelReserv setFont:contentFont];
    [cancelReserv setTextColor:contentColor];
    
    // 비었으면 히든 아니면 그대로 출력
    if([[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"RCTTIME"] == nil)
    {
        [cancelReservLabel setHidden:YES];
        [cancelReserv setHidden:YES];
    }
    else
    {
        startY += tempHeight;
    }
    
    // 좌석지정[ 제목 : (10, 134, 64, 13 고정) 내용 : (92, 134, 218, 13)]
    UILabel *selectSeatLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, startY, lblWidth, lblHeight)];
    [selectSeatLabel setText:@"좌석지정"];
    [selectSeatLabel setFont:labFont];
    
    UILabel *selectSeat = [[UILabel alloc] initWithFrame:CGRectMake(contentX, startY, contentWidth, contentHeight)];
    
    // Y이면 좌석지정가능, N이면 불가, 그외는 히든
    if([[[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"SELSEAT_YN"] isEqualToString:@"Y"])
    {
        [selectSeat setText:@"가능"];
        [selectSeat setFont:contentFont];
        [selectSeat setTextColor:contentColor];
        startY += tempHeight;
    }
    else if([[[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"SELSEAT_YN"] isEqualToString:@"N"])
    {
        [selectSeat setText:@"불가능"];
        [selectSeat setFont:contentFont];
        [selectSeat setTextColor:contentColor];
        startY += tempHeight;
    }
    else
    {
        [selectSeatLabel setHidden:YES];
        [selectSeat setHidden:YES];
        startY += tempHeight;
    }
    
    // startY는 상세정보뷰의 높이가 됨
    
    // 뷰에 추가
    [_detailView addSubview:scaleInfoLabel];
    [_detailView addSubview:scaleInfo];
    [_detailView addSubview:realTimeLabel];
    [_detailView addSubview:realTime];
    [_detailView addSubview:cancelReservLabel];
    [_detailView addSubview:cancelReserv];
    [_detailView addSubview:selectSeatLabel];
    [_detailView addSubview:selectSeat];
    
    // 스크롤뷰에 상세뷰 추가
    [_scrollView addSubview:_detailView];
    
    //NSLog(@"startY = %d", startY);
    
    // 상세정보내용 없나?(54이면 아무것도 출력안됨)
    if(startY == 54)
    {
        [_detailView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 80 - OM_STARTY)];
        NSLog(@"없음굿");
        
        UILabel *nodataLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_VALUE, 33, X_WIDTH, 13)];
        [nodataLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        [nodataLabel setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
        [nodataLabel setFont:[UIFont systemFontOfSize:13]];
        [nodataLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_detailView addSubview:nodataLabel];
        
        
    }
    // 내용있으면
    else
    {
        [_detailView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, startY)];
    }
    
    _viewStartY += _detailView.frame.size.height;
    
    [self hiddenCheck];
    
    
}
// 교통정보 그리기
- (void) drawTrafficView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //    NSLog(@"버스정보 : %@", [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"BUS"]);
    //    NSLog(@"지하철정보 : %@", [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"SUBWAY"]);
    
    for (UIView *view in _trafficView.subviews) {
        [view removeFromSuperview];
    }
    // 제목
    int startX = 10;
    int startY = 14;
    
    int labelWidth = 52;
    int labelHeight = 13;
    
    UIFont *lblFont = [UIFont boldSystemFontOfSize:13];
    
    // 내용
    int contentX = 80;
    int contentWidth = 230;
    
    // 간격
    int tempHeight = 27;
    int lastHeight = 19;
    
    // 데이터없을 때
    int trafficNodataViewHeight = 80;
    
    UIColor *contentColor = [UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1];
    UIFont *contentFont = [UIFont systemFontOfSize:13];
    
    if([[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"BUS"] == nil && [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"SUBWAY"] == nil)
    {
        UILabel *trafficNoLabel = [[UILabel alloc] initWithFrame:CGRectMake(X_VALUE, 33, X_WIDTH, 13)];
        [trafficNoLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        [trafficNoLabel setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
        [trafficNoLabel setFont:[UIFont systemFontOfSize:13]];
        [trafficNoLabel setTextAlignment:NSTextAlignmentCenter];
        
        [_trafficView addSubview:trafficNoLabel];
        
        
        [_trafficView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, trafficNodataViewHeight)];
        [_scrollView addSubview:_trafficView];
        
        
        _viewStartY += trafficNodataViewHeight;
        
    }
    else
    {
        
        
        UILabel *subway = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, labelWidth, labelHeight)];
        [subway setText:@"지하철"];
        [subway setFont:lblFont];
        
        UILabel *subwayContent = [[UILabel alloc] init];
        
        NSString *rawStr1 = [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"SUBWAY"];
        
        NSString *refindStr1 = [rawStr1 gtm_stringByUnescapingFromHTML];
        
        [subwayContent setText:refindStr1];
        [subwayContent setTextColor:contentColor];
        [subwayContent setFont:contentFont];
        //[subwayContent setBackgroundColor:[UIColor redColor]];
        [subwayContent setNumberOfLines:0];
        [subwayContent setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize subwaySize = [subwayContent.text sizeWithFont:subwayContent.font constrainedToSize:CGSizeMake(contentWidth, FLT_MAX) lineBreakMode:subwayContent.lineBreakMode];
        
        [subwayContent setFrame:CGRectMake(contentX, startY, subwaySize.width, subwaySize.height)];
        
        if([rawStr1 isEqualToString:@""])
        {
            NSLog(@"지하철업서");
            
            [subway setHidden:YES];
        }
        else
        {
            startY = subwaySize.height + tempHeight;
        }
        
        UILabel *bus = [[UILabel alloc] initWithFrame:CGRectMake(startX, startY, labelWidth, labelHeight)];
        [bus setText:@"버스노선"];
        [bus setFont:lblFont];
        
        UILabel *busContent = [[UILabel alloc] init];
        
        NSString *rawStr = [[[oms.movieDetailDictionary objectForKeyGC:@"TheaterDetail"] objectAtIndexGC:0] objectForKeyGC:@"BUS"];
        
        NSString *refindStr = [rawStr gtm_stringByUnescapingFromHTML];
        [busContent setText:refindStr];
        [busContent setTextColor:contentColor];
        [busContent setFont:contentFont];
        [busContent setNumberOfLines:0];
        [busContent setLineBreakMode:NSLineBreakByWordWrapping];
        
        CGSize busSize = [busContent.text sizeWithFont:subwayContent.font constrainedToSize:CGSizeMake(contentWidth, FLT_MAX) lineBreakMode:busContent.lineBreakMode];
        
        [busContent setFrame:CGRectMake(contentX, startY, busSize.width, busSize.height)];
        
        
        
        if([rawStr isEqualToString:@""])
        {
            NSLog(@"버스업서");
            
            [bus setHidden:YES];
            
        }
        else
        {
            startY += busSize.height + lastHeight;
        }
        
        if(bus.hidden == YES && subway.hidden == YES)
        {
            UILabel *nullLbl = [[UILabel alloc] init];
            [nullLbl setFrame:CGRectMake(0, 0, 320, 80)];
            [nullLbl setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
            [nullLbl setTextAlignment:NSTextAlignmentCenter];
            [nullLbl setFont:[UIFont systemFontOfSize:13]];
            [nullLbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
            
            [_trafficView addSubview:nullLbl];
            
            
            startY = 80;
            
        }
        else
        {
            
            [_trafficView addSubview:subway];
            [_trafficView addSubview:subwayContent];
            [_trafficView addSubview:bus];
            [_trafficView addSubview:busContent];
        }
        
        [_scrollView addSubview:_trafficView];
        [_trafficView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, startY)];
        
        _viewStartY = _viewStartY + startY;
    }
    [self hiddenCheck];
    
}
// 히든체크
- (void) hiddenCheck
{
    if(_movieView.hidden == YES && _mainInfoView.hidden == YES)
    {
        [_mainInfoLabelView setHidden:YES];
        [_nullMainInfoView setHidden:YES];
        [_movieLabelView setHidden:YES];
        [_nullMovieView setHidden:YES];
        [_underLine5 setHidden:YES];
        [_underLine6 setHidden:YES];
        [_detailTrafficLabelView setHidden:YES];
        [_detailView setHidden:YES];
        
        int allNullHeight = self.view.frame.size.height -_nullStartY-37-(37 + OM_STARTY);
        UIView *allNull = [[UIView alloc] init];
        //[allNull setBackgroundColor:[UIColor redColor]];
        [allNull setFrame:CGRectMake(0, _nullStartY, 320, allNullHeight)];
        
        UILabel *allNullLbl = [[UILabel alloc] init];
        [allNullLbl setFrame:CGRectMake(0, (allNullHeight / 2) - 6, 320, 13)];
        [allNullLbl setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
        [allNullLbl setTextAlignment:NSTextAlignmentCenter];
        [allNullLbl setFont:[UIFont systemFontOfSize:13]];
        [allNullLbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        
        
        [allNull addSubview:allNullLbl];
        
        
        [_scrollView addSubview:allNull];
        
        
        
        _viewStartY = _nullStartY + allNullHeight;
    }
    [self drawBottomView];
    
}
// 최하단 버튼
- (void) drawBottomView
{
    
    [_scrollView addSubview:_bottomView];
    [_bottomView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, _bottomView.frame.size.height)];
    
    _viewStartY = _viewStartY + _bottomView.frame.size.height;
    
    [self drawScrollView];
    
}
// 스크롤뷰 사이즈
- (void) drawScrollView
{
    _scrollView.contentSize = CGSizeMake(X_VALUE, _viewStartY);
    [_scrollView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - (OM_STARTY + 37))];
}

- (IBAction)popBtnClick:(id)sender
{
    [[OllehMapStatus sharedOllehMapStatus].searchLocalDictionary setObject:[NSString stringWithFormat:@""] forKey:@"LastExtendNewAddr"];
    
    [MapContainer sharedMapContainer_Main].kmap.delegate = nil;
    
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}
// 지도버튼
- (IBAction)mapBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    [oms.searchResult reset]; // 검색결과 리셋
    [oms.searchResult setUsed:YES];
    [oms.searchResult setIsCurrentLocation:NO];
    [oms.searchResult setStrLocationName:[oms.poiDetailDictionary objectForKeyGC:@"NAME"]];
    [oms.searchResult setStrLocationAddress:[oms.poiDetailDictionary objectForKeyGC:@"ADDR"]];
    
    Coord poiCrd = CoordMake([[oms.poiDetailDictionary objectForKeyGC:@"X"] doubleValue], [[oms.poiDetailDictionary objectForKeyGC:@"Y"] doubleValue]);
    
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    
    [oms.searchResult setCoordLocationPoint:CoordMake(xx, yy)];
    
    [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Normal animated:YES];
}

- (void)telBtnClickMv:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *telNum = [oms.poiDetailDictionary objectForKeyGC:@"TEL"];
    
    [self typeChecker:2];
    [self telViewCallBtnClick:telNum];
}
- (void)homePageBtnClickMv:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    
    NSString *homeURL = [oms.poiDetailDictionary objectForKeyGC:@"URL"];
    
    [self typeChecker:2];
    [self homeViewURLBtnClick:[oms urlValidCheck:homeURL]];
    
    return;
    HomeAlertView *alert = [[HomeAlertView alloc] initWithTitle:homeURL message:@"웹페이지로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    [alert setTag:2];
    [alert show];
}
- (void)startBtnClick:(id)sender
{
    [self typeChecker:2];
    [self btnViewStartBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
}

- (void)destBtnClick:(id)sender
{
    [self typeChecker:2];
    [self btnViewDestBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary ];
    
}

- (void)shareBtnClick:(id)sender
{
    [self typeChecker:2];
    [self btnViewShareBtnClick];
}
- (void)naviBtnClick:(id)sender
{
    [self typeChecker:2];
    [self btnViewNaviBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary ];
}

- (void)movieHomepageBtnClick:(id)sender
{
    HomeAlertView *alert = [[HomeAlertView alloc] initWithTitle:@"http://m.maxmovie.com" message:@"홈페이지로 이동하시겠습니까?" delegate:self cancelButtonTitle:@"아니오" otherButtonTitles:@"예", nil];
    [alert setTag:3];
    [alert show];
    
}
- (void)detailBtnClick:(id)sender
{
    [_detailBtn setSelected:YES];
    [_trafficBtn setSelected:NO];
    [self drawDetailTrafficLabelView];
}

- (void)trafficBtnClick:(id)sender
{
    [_trafficBtn setSelected:YES];
    [_detailBtn setSelected:NO];
    [self drawDetailTrafficLabelView];
}

- (void)favoriteBtnClick:(id)sender
{
    
    // 즐겨찾기 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail/favorite"];
    
    DbHelper *dh = [[DbHelper alloc] init];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    NSString *ujName = [oms.poiDetailDictionary objectForKeyGC:@"UJ_NAME"];
    
    NSMutableDictionary *fdic = [OMDatabaseConverter makeFavoriteDictionary:-1 sortOrder:-1 category:Favorite_Category_Local title1:[oms.poiDetailDictionary objectForKeyGC:@"NAME"] title2:[oms ujNameSegment:ujName] title3:@"" iconType:Favorite_IconType_POI coord1x:[[oms.poiDetailDictionary objectForKeyGC:@"X"] doubleValue] coord1y:[[oms.poiDetailDictionary objectForKeyGC:@"Y"] doubleValue] coord2x:0 coord2y:0 coord3x:0 coord3y:0 detailType:@"MV" detailID:[oms.poiDetailDictionary objectForKeyGC:@"POI_ID"] shapeType:@"" fcNm:@"" idBgm:@"" rdCd:@""];
    
    if([dh favoriteValidCheck:fdic])
    {
        // ver3테스트3번버그
        NSString *favoName = _themeToDetailName;
        if(!favoName || [favoName isEqualToString:@""])
        {
            favoName = [oms.poiDetailDictionary objectForKey:@"NAME"];
        }
        [self typeChecker:2];
        [self bottomViewFavorite:fdic placeHolder:favoName];
        
    }
    
}

- (void)contactBtnClick:(id)sender
{
    [self modalContact:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
}
- (void)infoModifyAskBtnClick:(id)sender
{
    [self typeChecker:2];
    [self modalInfoModify:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
