//
//  GeneralPOIDetailViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 2..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "GeneralPOIDetailViewController.h"

@interface GeneralPOIDetailViewController ()

@end

@implementation GeneralPOIDetailViewController

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
    self.delegate = self;
    [_mapBtn setHidden:!_displayMapBtn];
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self initer];
	// Do any additional setup after loading the view.
    _mainInfoNull = NO;
    
    _detailInfoNull = NO;
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSLog(@"%@", oms.poiDetailDictionary);
    
    self.freeCalling = [NSString stringWithFormat:@"%@", [oms.searchLocalDictionary objectForKey:@"LastExtendFreeCall"]];
    
    self.addrNewStr = stringValueOfDictionary(oms.searchLocalDictionary, @"LastExtendNewAddr");
    
    self.shapeType = oms.searchResult.strShape;
    self.fcNm = oms.searchResult.strShapeFcNm;
    self.idBgm = oms.searchResult.strShapeIdBgm;
    
    
    _viewStartY = 0;
    _expand = NO;
    
    
    [self saveRecentSearch];
    
    // 상단뷰 그리기
    [self drawTopView];
    
    // 주요정보 그리기
    [self drawMainInfoView];
    
    // 상세정보 라벨 그리기
    [self drawDetailInfoLabelView];
    
    
}
- (void) initer
{
    _mainInfoView = [[UIView alloc] init];
    [_mainInfoView setFrame:CGRectMake(0, 0, 321, 58)];
    
    _mainInfoText = [[UILabel alloc] init];
    [_mainInfoText setFrame:CGRectMake(10, 0, 280, 32)];
    [_mainInfoText setFont:[UIFont systemFontOfSize:13]];
    [_mainInfoText setNumberOfLines:2];
    [_mainInfoText setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_mainInfoView addSubview:_mainInfoText];
    [_mainInfoText setHidden:YES];
    
    _expandMainInfoText = [[UILabel alloc] init];
    [_expandMainInfoText setFrame:CGRectMake(10, 0, 280, 32)];
    [_expandMainInfoText setFont:[UIFont systemFontOfSize:13]];
    [_expandMainInfoText setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_mainInfoView addSubview:_expandMainInfoText];
    [_expandMainInfoText setHidden:YES];
    
    
    _expandBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_expandBtn setFrame:CGRectMake(0, 32, 320, 26)];
    [_expandBtn addTarget:self action:@selector(expandClick:) forControlEvents:UIControlEventTouchUpInside];
    [_expandBtn setHidden:YES];
    [_mainInfoView addSubview:_expandBtn];
    
    _expandBtnImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"view_list_down_icon.png"]];
    [_expandBtnImg setFrame:CGRectMake(153, 39, 15, 8)];
    [_expandBtnImg setHidden:YES];
    [_mainInfoView addSubview:_expandBtnImg];
    
    _underLine5 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    UIImageView *line5 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    [_underLine5 addSubview:line5];
    
    _underLine6 = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 1)];
    UIImageView *line6 = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_list_line_02.png"]];
    [_underLine6 addSubview:line6];
    
    // 상세정보라벨
    _detailInfoLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 36)];
    
    UILabel *detaillabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 11, 200, 14)];
    [detaillabel setText:@"상세정보"];
    [detaillabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_detailInfoLabelView addSubview:detaillabel];
    
    
    // 옵션정보
    _detailOptionBtnView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    
    _reservationYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_01.png"]];
    [_reservationYN setFrame:CGRectMake(10, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_reservationYN];
    
    _cardYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_02.png"]];
    [_cardYN setFrame:CGRectMake(51, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_cardYN];
    
    _parkingYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_03.png"]];
    [_parkingYN setFrame:CGRectMake(92, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_parkingYN];
    
    _deliveryYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_04.png"]];
    [_deliveryYN setFrame:CGRectMake(133, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_deliveryYN];
    
    _packingYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_05.png"]];
    [_packingYN setFrame:CGRectMake(174, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_packingYN];
    
    _beerYN = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"poi_btn_s_06.png"]];
    [_beerYN setFrame:CGRectMake(215, 10, 33, 17)];
    [_detailOptionBtnView addSubview:_beerYN];
    
    // 영업시간
    _openingTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 61)];
    
    UILabel *openingLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 52, 13)];
    [openingLbl setText:@"영업시간"];
    [openingLbl setFont:[UIFont systemFontOfSize:13]];
    [_openingTimeView addSubview:openingLbl];
    
    _openingText = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 230, 13)];
    [_openingText setFont:[UIFont systemFontOfSize:13]];
    [_openingText setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_openingText setNumberOfLines:0];
    [_openingTimeView addSubview:_openingText];
    
    // 휴일정보
    _closingTimeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 61)];
    
    UILabel *closingLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 14, 52, 13)];
    [closingLbl setText:@"휴일정보"];
    [closingLbl setFont:[UIFont systemFontOfSize:13]];
    [_closingTimeView addSubview:closingLbl];
    
    _closingText = [[UILabel alloc] initWithFrame:CGRectMake(80, 14, 230, 13)];
    [_closingText setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [_closingText setFont:[UIFont systemFontOfSize:13]];
    [_closingText setNumberOfLines:0];
    [_closingTimeView addSubview:_closingText];
    
    
    _chargeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 61)];
    
    UILabel *chargeLbl = [[UILabel alloc] initWithFrame:CGRectMake(10, 20, 52, 16)];
    [chargeLbl setText:@"이용요금"];
    [chargeLbl setFont:[UIFont systemFontOfSize:13]];
    [_chargeView addSubview:chargeLbl];
    
    _chargeText = [[UILabel alloc] initWithFrame:CGRectMake(80, 20, 230, 16)];
    [_chargeText setFont:[UIFont systemFontOfSize:13]];
    [_chargeText setNumberOfLines:0];
    [_chargeView addSubview:_chargeText];
    
    // 하단버튼
    _bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 37)];
    
    UIButton *favoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoBtn setImage:[UIImage imageNamed:@"poi_botton_btn_01.png"] forState:UIControlStateNormal];
    [favoBtn setFrame:CGRectMake(0, 0, 107, 37)];
    [favoBtn addTarget:self action:@selector(favoriteClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:favoBtn];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setImage:[UIImage imageNamed:@"poi_botton_btn_02.png"] forState:UIControlStateNormal];
    [contactBtn setFrame:CGRectMake(107, 0, 106, 37)];
    [contactBtn addTarget:self action:@selector(contactClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:contactBtn];
    
    UIButton *modifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [modifyBtn setImage:[UIImage imageNamed:@"poi_botton_btn_03.png"] forState:UIControlStateNormal];
    [modifyBtn setFrame:CGRectMake(213, 0, 107, 37)];
    [modifyBtn addTarget:self action:@selector(modifyClick:) forControlEvents:UIControlEventTouchUpInside];
    [_bottomView addSubview:modifyBtn];
    
    
    _detailInfoNoDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 66)];
    
    UILabel *detailNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 50)];
    [detailNoData setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
    [detailNoData setText:NSLocalizedString(@"Msg_Detail_DetailNull", @"")];
    [detailNoData setFont:[UIFont systemFontOfSize:13]];
    [detailNoData setTextAlignment:NSTextAlignmentCenter];
    [_detailInfoNoDataView addSubview:detailNoData];
    
    
    _mainInfoNoDataView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    
    UILabel *mainNoData = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 55)];
    [mainNoData setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
    [mainNoData setText:NSLocalizedString(@"Msg_Detail_MainNull", @"")];
    [mainNoData setFont:[UIFont systemFontOfSize:13]];
    [mainNoData setTextAlignment:NSTextAlignmentCenter];
    [_mainInfoNoDataView addSubview:mainNoData];
    
    // 상세없음
    _blankPOIView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 239)];
    
    _blankPOIlbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 239)];
    [_blankPOIlbl setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
    [_blankPOIlbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
    [_blankPOIlbl setFont:[UIFont systemFontOfSize:13]];
    [_blankPOIlbl setTextAlignment:NSTextAlignmentCenter];
    [_blankPOIView addSubview:_blankPOIlbl];
    
    // 콜링크뷰
    _callLinkView = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, self.view.frame.size.height)];
    //[_callLinkView addTarget:self action:@selector(touchBackGround:) forControlEvents:UIControlEventTouchUpInside];
    [_callLinkView setBackgroundColor:convertHexToDecimalRGBA(@"00", @"00", @"00", 0.7f)];

    _callLinkAlertView = [[UIView alloc] initWithFrame:CGRectMake(116/2, 284/2, 410/2, 390/2)];
    [_callLinkView addSubview:_callLinkAlertView];
    
    UIImageView *alertBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 410/2, 390/2)];
    [alertBg setImage:[UIImage imageNamed:@"popup_bg_02.png"]];
    [_callLinkAlertView addSubview:alertBg];
    
    // 타이틀 렌더링
    {
        UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 410/2, 62/2)];
        
        UILabel *titleLbl = [[UILabel alloc] initWithFrame:CGRectMake(4/2 + 20/2, 16/2, 310/2, 16)];
        [titleLbl setFont:[UIFont systemFontOfSize:16]];
        [titleLbl setText:@"무료통화"];
        [titleLbl setTextColor:convertHexToDecimalRGBA(@"ff", @"51", @"5e", 1.0)];
        [titleView addSubview:titleLbl];
        
        UIButton *titleBtn = [[UIButton alloc] initWithFrame:CGRectMake(4/2 + 348/2, 10/2, 40/2, 40/2)];
        [titleBtn setImage:[UIImage imageNamed:@"btn_close.png"] forState:UIControlStateNormal];
        [titleView addSubview:titleBtn];
        [titleBtn addTarget:self action:@selector(touchBackGround:) forControlEvents:UIControlEventTouchUpInside];
        
        UIImageView *titleUnderLine = [[UIImageView alloc] initWithFrame:CGRectMake(4/2, 60/2, 402/2, 2/2)];
        [titleUnderLine setImage:[UIImage imageNamed:@"popup_title_line.png"]];
        [titleView addSubview:titleUnderLine];
        
        [_callLinkAlertView addSubview:titleView];
    }
    
    UIView *textFieldView = [[UIView alloc] initWithFrame:CGRectMake(4/2, 62/2 + 116/2 + 4/2, 402/2, 90/2)];
    [textFieldView setBackgroundColor:convertHexToDecimalRGBA(@"f4", @"f4", @"f4", 1.0)];
    [_callLinkAlertView addSubview:textFieldView];
    
    
    UIImageView *callTextfieldBg = [[UIImageView alloc] initWithFrame:CGRectMake(20/2, 16/2, 360/2, 60/2)];
    [callTextfieldBg setImage:[UIImage imageNamed:@"popup_text_box.png"]];
    [textFieldView addSubview:callTextfieldBg];
    
    _myNumber = [[UITextField alloc] initWithFrame:CGRectMake(40/2, 32/2, 320/2, 28/2)];
    [_myNumber setFont:[UIFont systemFontOfSize:14]];
    [_myNumber setBorderStyle:UITextBorderStyleNone];
    [_myNumber setKeyboardType:UIKeyboardTypeNumberPad];
    [_myNumber setPlaceholder:@"예시:0212345678"];
    [_myNumber addTarget:self action:@selector(keyboardShow:) forControlEvents:UIControlEventTouchDown];
    [textFieldView addSubview:_myNumber];
    
    UIButton *freeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [freeBtn setFrame:CGRectMake(100/2, 298/2, 210/2, 64/2)];
    [freeBtn setImage:[UIImage imageNamed:@"freecall_btn.png"] forState:UIControlStateNormal];
    [freeBtn setImage:[UIImage imageNamed:@"freecall_btn_pressed.png"] forState:UIControlStateHighlighted];
    [freeBtn addTarget:self action:@selector(goFreeCallClick:) forControlEvents:UIControlEventTouchUpInside];
    [_callLinkAlertView addSubview:freeBtn];
    
}
- (void) saveRecentSearch
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *ujName = [oms.poiDetailDictionary objectForKey:@"UJ_NAME"];
    
    // 최근리스트 저장
    
    NSMutableDictionary *generalPOIDic = [NSMutableDictionary dictionary];
    
    Coord poiCrd;
    
    poiCrd = CoordMake([[oms.poiDetailDictionary objectForKey:@"X"] doubleValue], [[oms.poiDetailDictionary objectForKey:@"Y"] doubleValue]);
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    NSString *tel = stringValueOfDictionary(oms.poiDetailDictionary, @"TEL");
    
    NSLog(@"self.freecall : %@", self.freeCalling);
    
    // ver3테스트2번버그(최근검색에서도 상세이름까지 나오도록...)
    NSString *recentName = _themeToDetailName;
    
    if(!recentName || [recentName isEqualToString:@""])
    {
        recentName = [oms.poiDetailDictionary objectForKey:@"NAME"];
    }
    
    [generalPOIDic setObject:recentName forKey:@"NAME"];
    [generalPOIDic setObject:[oms ujNameSegment:ujName] forKey:@"CLASSIFY"];
    [generalPOIDic setValue:[NSNumber numberWithDouble:xx] forKey:@"X"];
    [generalPOIDic setValue:[NSNumber numberWithDouble:yy] forKey:@"Y"];
    [generalPOIDic setObject:@"MP" forKey:@"TYPE"];
    [generalPOIDic setObject:[oms.poiDetailDictionary objectForKey:@"POI_ID"] forKey:@"ID"];
    [generalPOIDic setObject:tel forKey:@"TEL"];
    [generalPOIDic setObject:[oms.poiDetailDictionary objectForKey:@"ADDR"] forKey:@"ADDR"];
    [generalPOIDic setObject:[NSString stringWithFormat:@"%@", self.freeCalling] forKey:@"FREE"];
    [generalPOIDic setObject:[NSString stringWithFormat:@"%@", self.shapeType] forKey:@"SHAPE_TYPE"];
    [generalPOIDic setObject:[NSString stringWithFormat:@"%@", self.fcNm] forKey:@"FCNM"];
    [generalPOIDic setObject:[NSString stringWithFormat:@"%@", self.idBgm] forKey:@"ID_BGM"];
    [generalPOIDic setObject:[NSNumber numberWithInt:Favorite_IconType_POI] forKey:@"ICONTYPE"];
    
    [oms addRecentSearch:generalPOIDic];
    
    NSLog(@"shape : %@, fcnm = %@, idBgm = %@", self.shapeType, self.fcNm, self.idBgm);
    
    // 최근리스트 저장 끝
    
}
- (void) drawTopView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 최상단 뷰(이름, 주소, 분류, 이미지)
    int topViewHeight = 90;
    
    UIColor *labelBg = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, topViewHeight)];
    [topView setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:244.0/255.0 blue:255.0/255.0 alpha:1]];
    
    
    UILabel *poiName = [[UILabel alloc] initWithFrame:CGRectMake(90, 16, 220, 17)];
    [poiName setText:[oms.poiDetailDictionary objectForKey:@"NAME"]];
    [poiName setFont:[UIFont boldSystemFontOfSize:17]];
    [poiName setAdjustsFontSizeToFitWidth:YES];
    [poiName setNumberOfLines:1];
    [poiName setBackgroundColor:labelBg];
    [topView addSubview:poiName];
    
    NSString *roadAddrDoGu = stringValueOfDictionary(oms.poiDetailDictionary, @"M_NEWADDR1");
    NSString *roadAddr = stringValueOfDictionary(oms.poiDetailDictionary, @"ROAD_NAME");
    NSString *roadBuildNo = stringValueOfDictionary(oms.poiDetailDictionary, @"BUILD_NO");
    
    NSString *zibunAddr = stringValueOfDictionary(oms.poiDetailDictionary, @"ADDR");
    
    int segmentHeight = 60;
    
    if(![self.shapeType isEqualToString:@""])
    {
        UILabel *linePOIAdd = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 220, 13)];
        
        NSString *linePOIAddr = stringValueOfDictionary(oms.poiDetailDictionary, @"URL");
        
        if(![linePOIAddr isEqualToString:@""])
        {
            NSString *lineAddrSegment  = [linePOIAddr substringFromIndex:20];
            
            NSArray *kiJongDist = [lineAddrSegment componentsSeparatedByString:@"/"];
            
            [linePOIAdd setText:[NSString stringWithFormat:@"%@ ~ %@", [kiJongDist objectAtIndexGC:1], [kiJongDist objectAtIndexGC:2]]];
            [linePOIAdd setFont:[UIFont systemFontOfSize:13]];
            [linePOIAdd setAdjustsFontSizeToFitWidth:YES];
            [linePOIAdd setNumberOfLines:1];
            [linePOIAdd setBackgroundColor:labelBg];
            [topView addSubview:linePOIAdd];
            
            CGSize poiAddSize = [linePOIAdd.text sizeWithFont:linePOIAdd.font];
            [linePOIAdd setFrame:CGRectMake(90, 40, poiAddSize.width, 13)];

            UIImageView *segImg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_text_line.png"]];
            [segImg setFrame:CGRectMake(90 + poiAddSize.width, 40, 13, 13)];
            [topView addSubview:segImg];
            
            UILabel *dist = [[UILabel alloc] initWithFrame:CGRectMake(90 + poiAddSize.width + 13, 40, 60, 13)];
            [dist setFont:[UIFont systemFontOfSize:13]];
            [dist setText:[kiJongDist objectAtIndex:3]];
            [topView addSubview:dist];
            
            
        }
        else
        {
            // 라인POI 들어옴(상세주소 필요)
            if([roadAddrDoGu isEqualToString:@""])
            {
                [linePOIAdd setText:self.addrNewStr];
            }
            else
            {
                [linePOIAdd setText:[NSString stringWithFormat:@"%@ %@ %@", roadAddrDoGu, roadAddr, roadBuildNo]];
                
            }
            
            [linePOIAdd setFont:[UIFont systemFontOfSize:13]];
            [linePOIAdd setAdjustsFontSizeToFitWidth:YES];
            [linePOIAdd setNumberOfLines:1];
            [linePOIAdd setBackgroundColor:labelBg];
            [topView addSubview:linePOIAdd];
            
                // 지번주소
                
                // 지번주소이미지
                UIImageView *subZiImg = [[UIImageView alloc] init];
                [subZiImg setImage:[UIImage imageNamed:@"old_address_icon.png"]];
                [subZiImg setFrame:CGRectMake(90, linePOIAdd.frame.origin.y + linePOIAdd.frame.size.height + 6 - 1, 33, 15)];
                
                [topView addSubview:subZiImg];
                
                UILabel *poiAdd = [[UILabel alloc] initWithFrame:CGRectMake(127, linePOIAdd.frame.origin.y +linePOIAdd.frame.size.height + 6 - 1, 183, 13)];
                [poiAdd setText:zibunAddr];
                [poiAdd setFont:[UIFont systemFontOfSize:13]];
                [poiAdd setAdjustsFontSizeToFitWidth:YES];
                [poiAdd setNumberOfLines:1];
                [poiAdd setBackgroundColor:labelBg];
                [topView addSubview:poiAdd];
                
                segmentHeight += 13 + 5;
                topViewHeight = 106;

        }
        
    }
    // 도로명주소 없으면 지번주소
    else if([roadAddrDoGu isEqualToString:@""] || [roadBuildNo isEqualToString:@""] || [roadAddr isEqualToString:@""])
    {
        // 지번주소이미지
        UIImageView *subImg = [[UIImageView alloc] init];
        [subImg setImage:[UIImage imageNamed:@"old_address_icon.png"]];
        [subImg setFrame:CGRectMake(90, 40, 33, 15)];
        
        [topView addSubview:subImg];

        UILabel *poiAdd = [[UILabel alloc] initWithFrame:CGRectMake(127, 40, 183, 13)];
        
        // 지번주소컷해야됨
        
        NSArray *splitArray = [zibunAddr componentsSeparatedByString:@" "];
        
        NSMutableString *fullStr = [[NSMutableString alloc] init];
        
        for (int i=0; i<[splitArray count]; i++)
        {
            NSString *compareStr = [splitArray objectAtIndex:i];
            
            
            if([self BunZiValidCheck:compareStr] || [self BunZiHyphenVaildCheck:compareStr])
            {
                
            }
            else
            [fullStr appendString:[NSString stringWithFormat:@"%@ ", [splitArray objectAtIndex:i]]];
        }
        
        
        
        [poiAdd setText:fullStr];
        [poiAdd setFont:[UIFont systemFontOfSize:13]];
        [poiAdd setAdjustsFontSizeToFitWidth:YES];
        [poiAdd setNumberOfLines:1];
        [poiAdd setBackgroundColor:labelBg];
        [topView addSubview:poiAdd];
    }
    // 도로명주소 있으면 도로명 / 지번
    else
    {
        UILabel *poiNewAdd = [[UILabel alloc] initWithFrame:CGRectMake(90, 40, 220, 13)];
        [poiNewAdd setText:[NSString stringWithFormat:@"%@ %@ %@", roadAddrDoGu, roadAddr, roadBuildNo]];
        [poiNewAdd setFont:[UIFont systemFontOfSize:13]];
        [poiNewAdd setAdjustsFontSizeToFitWidth:YES];
        [poiNewAdd setNumberOfLines:1];
        [poiNewAdd setBackgroundColor:labelBg];
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
        [poiAdd setBackgroundColor:labelBg];
        [topView addSubview:poiAdd];
        
        segmentHeight += 13 + 5;
        topViewHeight = 106;
    }
    
    UILabel *poiUj = [[UILabel alloc] initWithFrame:CGRectMake(90, segmentHeight, 220, 13)];
    [poiUj setText:[oms.poiDetailDictionary objectForKey:@"UJ_NAME"]];
    [poiUj setFont:[UIFont systemFontOfSize:13]];
    [poiUj setTextColor:[UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    [poiUj setAdjustsFontSizeToFitWidth:YES];
    [poiUj setNumberOfLines:1];
    [poiUj setBackgroundColor:labelBg];
    [topView addSubview:poiUj];
    
    UIImageView *poiImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [poiImg setImage:[UIImage imageNamed:@"view_no_img_box.png"]];
    NSString *imageUrl = [oms.poiDetailDictionary objectForKey:@"IMG_URL"];
    // 이미지가 있으면 이미지를 그린다
	if (imageUrl)
    {
        [poiImg setImage:[oms urlGetImage:imageUrl]];
	}
    [topView addSubview:poiImg];
    
    
    UIImageView *poiImgBox = [[UIImageView alloc] init];
    [poiImgBox setFrame:CGRectMake(10, 10, 70, 70)];
    [poiImgBox setImage:[UIImage imageNamed:@"view_img_box.png"]];
    
    [topView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, topViewHeight)];
    [topView addSubview:poiImgBox];

    [_scrollView addSubview:topView];
    
    
    _viewStartY += topViewHeight;
    
    // 상단뷰 밑줄
    [self drawUnderLine1];
    
}
- (BOOL) BunZiValidCheck:(NSString *)keyword
{
    NSString *expression = @"^[0-9]{1,4}$";
    
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:keyword options:0 range:NSMakeRange(0, [keyword length])];
    
    if(match)
        return YES;
    else
        return NO;

}
- (BOOL) BunZiHyphenVaildCheck:(NSString *)keyword
{
    //NSString *expression = @"^[A-Z0-9._%-]+@[A-Z0-9.-]+.[A-Z]{2,4}$";
    //NSString *expression = @"^[0-9]{5,}$";
                //NSString *expression = @"^[0-9]{2}+-[0-9]{3,}$";
    
    NSString *expression = @"^[0-9]{1,4}-[0-9]{1,}$";
    
                NSError *error = NULL;
                
                NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
                
                NSTextCheckingResult *match = [regex firstMatchInString:keyword options:0 range:NSMakeRange(0, [keyword length])];
                
                if(match)
                    return YES;
                else
                    return NO;
                
            }
// 상단뷰 밑줄
- (void) drawUnderLine1
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    UIImageView *underLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 1)];
    [underLine1 setImage:[UIImage imageNamed:@"poi_list_line_01.png"]];
    // 스크롤뷰에 밑줄뷰 추가
    [_scrollView addSubview:underLine1];
    
    
    _viewStartY += 1;
    
    NSLog(@"전번시작y : %d", _viewStartY);
    
    self.freeCalling = [NSString stringWithFormat:@"%@", [oms.searchLocalDictionary objectForKey:@"LastExtendFreeCall"]];
    
    NSString *str = stringValueOfDictionary(oms.poiDetailDictionary, @"TEL");
    
    // 무료통화가 있으면 무료통화뷰를 그리고 없으면 일반 전화뷰
    if([self.freeCalling isEqualToString:@"PG1201000000008"] && ![str isEqualToString:@""])
    {
        [self drawFreeTelePhone];
    }
    else if(![str isEqualToString:@""])
    {
        [self drawTelePhone];
    }
    else
    {
        [self drawHomePage];
    }
}


// 전화번호 뷰
- (void) drawTelePhone
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int telViewHeight = 40;
    NSLog(@"전번시작y : %d", _viewStartY);
    UIView *telView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, telViewHeight)];
    
    // 버튼
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 320, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [telView addSubview:button];
    
    // 전화이미지
    UIImageView *telImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 20, 20)];
    [telImg setImage:[UIImage imageNamed:@"view_list_b_call.png"]];
    [telView addSubview:telImg];
    
    
    NSString *telStr = stringValueOfDictionary(oms.poiDetailDictionary, @"TEL");
    
    // 전화번호라벨
    UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 13, 260, 15)];
    [telLabel setText:telStr];
    [telLabel setBackgroundColor:[UIColor clearColor]];
    [telLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [telLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [telView addSubview:telLabel];
    
    
    // 애로우버튼이미지
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(303, 14, 7, 12)];
    [arrowImg setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [telView addSubview:arrowImg];
    
    
    // 전화번호가 없으면 히든
    if([telStr isEqualToString:@""])
    {
        [telView setHidden:YES];
        
        [self drawHomePage];
    }
    else
    {
        // 스크롤뷰에 추가
        [_scrollView addSubview:telView];
        
        
        _viewStartY = _viewStartY + telViewHeight;
        
        [self drawUnderLine2];
    }
    
    // 전화번호 뷰 끝
    
}

// 무료통화 뷰
- (void) drawFreeTelePhone
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int freeCallViewHeight = 40;
    
    UIView *freeCallView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, freeCallViewHeight)];
    
    //일반전화버튼
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 159, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(fgoPhoneClick:) forControlEvents:UIControlEventTouchUpInside];
    [freeCallView addSubview:button];
    
    // 일반전화이미지
    UIImageView *telImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 20, 20)];
    [telImg setImage:[UIImage imageNamed:@"view_list_b_call.png"]];
    [freeCallView addSubview:telImg];
    
    
    NSString *telStr = stringValueOfDictionary(oms.poiDetailDictionary, @"TEL");
    
    // 일반전화라벨
    _telLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 13, 130, 15)];
    [_telLabel setText:telStr];
    [_telLabel setBackgroundColor:[UIColor clearColor]];
    [_telLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [_telLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [freeCallView addSubview:_telLabel];
    
    
    // 일반전화애로우이미지
    UIImageView *arrow = [[UIImageView alloc] initWithFrame:CGRectMake(143, 14, 7, 12)];
    [arrow setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [freeCallView addSubview:arrow];
    
    
    // 세그먼트
    UIImageView *segment = [[UIImageView alloc] initWithFrame:CGRectMake(159, 0, 1, 40)];
    [segment setImage:[UIImage imageNamed:@"list_bg_line.png"]];
    [freeCallView addSubview:segment];
    
    
    //무료전화버튼
    UIButton *fButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [fButton setFrame:CGRectMake(160, 0, 160, 40)];
    [fButton setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [fButton addTarget:self action:@selector(fGoFreeCallClick:) forControlEvents:UIControlEventTouchUpInside];
    [freeCallView addSubview:fButton];
    
    // 무료전화이미지
    UIImageView *freeTelImg = [[UIImageView alloc] initWithFrame:CGRectMake(167, 10, 20, 20)];
    [freeTelImg setImage:[UIImage imageNamed:@"view_list_r_call.png"]];
    [freeCallView addSubview:freeTelImg];
    
    
    // 무료전화라벨
    UILabel *freeTelLabel = [[UILabel alloc] initWithFrame:CGRectMake(195, 13, 130, 15)];
    [freeTelLabel setText:@"무료통화"];
    [freeTelLabel setBackgroundColor:[UIColor clearColor]];
    [freeTelLabel setTextColor:[UIColor colorWithRed:242.0/255.0 green:52.0/255.0 blue:113.0/255.0 alpha:1]];
    [freeTelLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [freeCallView addSubview:freeTelLabel];
    
    
    // 무료전화애로우이미지
    UIImageView *freeArrow = [[UIImageView alloc] initWithFrame:CGRectMake(302, 14, 7, 12)];
    [freeArrow setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [freeCallView addSubview:freeArrow];
    
    
    _viewStartY += freeCallViewHeight;
    
    [_scrollView addSubview:freeCallView];
    
    
    [self drawUnderLine2];
    
}

// 전화번호와 홈페이지 사이의 밑줄
- (void) drawUnderLine2
{
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 1)];
    [underLine2 setImage:[UIImage imageNamed:@"poi_list_line_02.png"]];
    [_scrollView addSubview:underLine2];
    // 밑줄 뷰 위치(0, y, 너비, 높이)
    
    
    _viewStartY += 1;
    
    [self drawHomePage];
}

// 홈페이지 뷰 그리기
- (void) drawHomePage
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int homePageViewHeight = 40;
    
    UIView *homePageView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, homePageViewHeight)];
    
    // 홈피버튼
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 320, 40)];
    [button setBackgroundImage:[UIImage imageNamed:@"poi_busstop_list_bg_pressed.png"] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(goHomePageClick:) forControlEvents:UIControlEventTouchUpInside];
    [homePageView addSubview:button];
    
    // 홈피이미지
    UIImageView *homePageImg = [[UIImageView alloc] initWithFrame:CGRectMake(7, 10, 20, 20)];
    [homePageImg setImage:[UIImage imageNamed:@"view_list_address.png"]];
    [homePageView addSubview:homePageImg];
    
    
    //홈피라벨
    // pqy 잘려서 y축 -3, 높이 3 증가
    UILabel *homePageLabel = [[UILabel alloc] initWithFrame:CGRectMake(35, 10, 260, 18)];
    [homePageLabel setBackgroundColor:[UIColor clearColor]];
    
    NSString *url = [oms.poiDetailDictionary objectForKey:@"URL"];
    [homePageLabel setText:[oms urlValidCheck:(NSString *)url]];
    [homePageLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [homePageLabel setTextColor:[UIColor colorWithRed:26.0/255.0 green:104.0/255.0 blue:201.0/255.0 alpha:1]];
    [homePageView addSubview:homePageLabel];
    
    
    // 애로우버튼이미지
    UIImageView *arrowImg = [[UIImageView alloc] initWithFrame:CGRectMake(303, 14, 7, 12)];
    [arrowImg setImage:[UIImage imageNamed:@"view_list_arrow.png"]];
    [homePageView addSubview:arrowImg];
    
    NSString *urlPre = @"";
    
    NSLog(@"length : %d", (int)stringValueOfDictionary(oms.poiDetailDictionary, @"URL").length);
    
    if(stringValueOfDictionary(oms.poiDetailDictionary, @"URL").length > 21)
     urlPre = [[oms.poiDetailDictionary objectForKeyGC:@"URL"] substringToIndex:21];

    if([stringValueOfDictionary(oms.poiDetailDictionary, @"URL") isEqualToString:@""] || [urlPre compare:@"http://map.olleh.com/" options:NSCaseInsensitiveSearch] == NSOrderedSame)
    {
        [homePageView setHidden:YES];
        
        
        [self drawBtnView];
    }
    else {
        
        [_scrollView addSubview:homePageView];
        
        _viewStartY = _viewStartY + homePageViewHeight;
        
        [self drawUnderLine3];
    }
    
    
    
    
    
}

// 홈페이지뷰 밑줄 그리기

- (void) drawUnderLine3
{
    
    UIImageView *underLine3 = [[UIImageView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 1)];
    [underLine3 setImage:[UIImage imageNamed:@"poi_list_line_03.png"]];
    
    [_scrollView addSubview:underLine3];
    
    
    _viewStartY += 1;
    
    [self drawBtnView];
    
}

// 버튼뷰 그리기
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
    [startBtn addTarget:self action:@selector(startClick:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setEnabled:[self.shapeType isEqualToString:@""] ? YES : NO];
        [startBtn setImage:[UIImage imageNamed:@"poi_list_btn_start_disabled.png"] forState:UIControlStateDisabled];
    
    [btnView addSubview:startBtn];
    
    UIButton *destBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    destBtn.frame = CGRectMake(96, 9, 81, 37);
    
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop.png"] forState:UIControlStateNormal];
    [destBtn addTarget:self action:@selector(destClick:) forControlEvents:UIControlEventTouchUpInside];
    [destBtn setEnabled:[self.shapeType isEqualToString:@""] ? YES : NO];
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop_disabled.png"] forState:UIControlStateDisabled];
    [btnView addSubview:destBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(182, 9, 61, 37);
    
    [shareBtn setImage:[UIImage imageNamed:@"poi_list_btn_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:shareBtn];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.frame = CGRectMake(248, 9, 61, 37);
    
    [naviBtn setImage:[UIImage imageNamed:@"poi_list_btn_navi.png"] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(naviClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:naviBtn];
    
    
    [_scrollView addSubview:btnView];
    _viewStartY += btnViewHeight;
    
    [self drawMainInfoLabelView];
    // 버튼 뷰 끝
    
}
// 주요정보 라벨 그리기
- (void) drawMainInfoLabelView
{
    int mainInfoLabelViewHeight = 36;
    
    _mainInfoLabelView = [[UIView alloc] initWithFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, mainInfoLabelViewHeight)];
    
    
    UILabel *mainInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 280, 14)];
    [mainInfoLabel setText:@"주요정보"];
    [mainInfoLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_mainInfoLabelView addSubview:mainInfoLabel];
    
    
    [_scrollView addSubview:_mainInfoLabelView];
    
    
    _blankStartY = _viewStartY;
    _viewStartY = _viewStartY + mainInfoLabelViewHeight;
    
    
}

// 주요정보 그리기
- (void) drawMainInfoView
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *rawDesp = [oms.poiDetailDictionary objectForKey:@"DESP"];
    
    NSString *desp = [rawDesp gtm_stringByUnescapingFromHTML];
    
    //NSString *desp = @"ㅇㅇㅇ";
    
    //NSString *desp = @"aaaa=asdasasdasdda";
    [_mainInfoText setText:desp];
    
    
    
    //NSLog(@"desp : %@", [oms.poiDetailDictionary objectForKey:@"DESP"]);
    
    // 너비, 높이
    CGRect mainInfoViewbounds = _mainInfoView.bounds;
    CGFloat mainInfoViewWidth = CGRectGetWidth(mainInfoViewbounds);
    CGFloat mainInfoViewHeight = CGRectGetHeight(mainInfoViewbounds);
    //    mainInfoViewHeight = (IS_4_INCH) ? mainInfoViewHeight + 47 : mainInfoViewHeight;
    
    // 확장 전 너비와 높이 저장
    _mainInfoViewNotExpendWidth = mainInfoViewWidth;
    _mainInfoViewNotExpendHeight = mainInfoViewHeight;
    
    NSLog(@"desp.length : %d", (int)desp.length);
    
    // 주요정보가 없으면 등록된 정보가 없다는 뷰(mainInfoNoDataView)를 띄움
    if ([oms.poiDetailDictionary objectForKey:@"DESP"] == nil) {
        
        _mainInfoNull = YES;
        // 너비, 높이
        CGRect mainInfoNoDataViewbounds = _mainInfoNoDataView.bounds;
        CGFloat mainInfoNoDataViewHeight = CGRectGetHeight(mainInfoNoDataViewbounds);
        
        //NSLog(@"zzzzzzzzzzz : %d", _viewStartY);
        [_mainInfoNoDataView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, mainInfoNoDataViewHeight)];
        
        [_scrollView addSubview:_mainInfoNoDataView];
        
        // 주요정보 뷰는 히든
        [_mainInfoView setHidden:YES];
        
        _viewStartY = _viewStartY + mainInfoNoDataViewHeight;
        
    }
    else
    {
        // 축소되었을때 주요정보 라벨
        [_mainInfoText setHidden:NO];
        // 확장버튼
        [_expandBtn setHidden:NO];
        // 축소버튼
        [_expandBtnImg setHidden:NO];
        
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _viewStartY, mainInfoViewWidth, mainInfoViewHeight)];
        
        [_scrollView addSubview:_mainInfoView];
        
        _expand = YES;
        _prevViewStartY = _viewStartY;
        _viewStartY = _viewStartY + mainInfoViewHeight;
        
        
    }
    
    [self drawUnderLine5];
    
}

- (void)expandClick:(id)sender
{
    // 확장되었을 때
    if(_expand == YES)
    {
        [_mainInfoText setHidden:YES];
        [_expandMainInfoText setHidden:NO];
        
        // 너비, 높이
        CGRect mainInfoViewbounds = _mainInfoView.bounds;
        CGFloat mainInfoViewWidth = CGRectGetWidth(mainInfoViewbounds);
        // mainInfoViewHeight 변수는 0으로 초기화해도 무방함, 실제로 아래라인에서 mainInfoViewHeight 변수에 다시 실제값을 할당하는 구조라
        // 이시점에서 메소드를 통해 값을 할당하는 액션은 리소스낭비로 볼수있음 ..  Dead store..
        CGFloat mainInfoViewHeight = 0; // CGRectGetHeight(mainInfoViewbounds);
        
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        // 바로 _expandMainInfoText에 넣으면 잘림....그리고 html 섞여있음 아놔
        // 그래서 스트링에 넣음
        
        NSString *rawDesp = [oms.poiDetailDictionary objectForKey:@"DESP"];
        
        NSString *desp = [rawDesp gtm_stringByUnescapingFromHTML];
        
        [_expandMainInfoText setText:desp];
        
        
        // 넘버라인 0이면 무한대로 늘어남
        // 텍스트가 라벨사이즈보다 초과되면 자동줄바꿈
        [_expandMainInfoText setNumberOfLines:0];
        [_expandMainInfoText setLineBreakMode:NSLineBreakByWordWrapping];
        
        // 라벨 사이즈 맞추기
        CGSize maximumLabelSize = CGSizeMake(280,9999);
        CGSize expectedLabelSize = [_expandMainInfoText.text sizeWithFont:_expandMainInfoText.font
                                                        constrainedToSize:maximumLabelSize
                                                            lineBreakMode:_expandMainInfoText.lineBreakMode];
        
        CGRect newFrame = _expandMainInfoText.frame;
        newFrame.size.height = expectedLabelSize.height + 16;
        _expandMainInfoText.frame = newFrame;
        
        // 라벨높이
        //NSLog(@"%f", newFrame.size.height);
        
        
        // 메인뷰의 높이(라벨크기 + 버튼높이(24고정))
        mainInfoViewHeight = newFrame.size.height + 26;
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _prevViewStartY, mainInfoViewWidth, mainInfoViewHeight)];
        [_expandBtn setFrame:CGRectMake(X_VALUE, mainInfoViewHeight - 26, X_WIDTH, 26)];
        [_expandBtnImg setFrame:CGRectMake(153, mainInfoViewHeight - 8 - 15, 15, 8)];
        [_expandBtnImg setImage:[UIImage imageNamed:@"view_list_up_icon.png"]];
        
        _expand = NO;
        
        _viewStartY = _prevViewStartY + mainInfoViewHeight;
        
        [self drawUnderLine5];
    }
    
    // 축소되었을 때
    else if(_expand == NO) {
        
        [_mainInfoText setHidden:NO];
        [_expandMainInfoText setHidden:YES];
        
        
        [_mainInfoView setFrame:CGRectMake(X_VALUE, _prevViewStartY, _mainInfoViewNotExpendWidth, _mainInfoViewNotExpendHeight)];
        [_expandBtn setFrame:CGRectMake(X_VALUE, 32, X_WIDTH, 26)];
        [_expandBtnImg setFrame:CGRectMake(153, 39, 15, 8)];
        [_expandBtnImg setImage:[UIImage imageNamed:@"view_list_down_icon.png"]];
        
        _expand = YES;
        
        _viewStartY = _prevViewStartY + _mainInfoViewNotExpendHeight;
        
        [self drawUnderLine5];
    }
    
    //[self drawUnderLine5];
    [self drawDetailInfoLabelView];
    
}

// 주요정보 뷰 밑줄
- (void) drawUnderLine5
{
    [_scrollView addSubview:_underLine5];
    
    // 너비, 높이
    CGRect line2Viewbounds = _underLine5.bounds;
    CGFloat line2ViewWidth = CGRectGetWidth(line2Viewbounds);
    CGFloat line2ViewHeight = CGRectGetHeight(line2Viewbounds);
    if(_expand == YES)
    {
        [_underLine5 setFrame:CGRectMake(X_VALUE, _viewStartY, line2ViewWidth, line2ViewHeight)];
        _viewStartY = _viewStartY + line2ViewHeight;
    }
    
    else if(_expand == NO) {
        [_underLine5 setFrame:CGRectMake(X_VALUE, _viewStartY, line2ViewWidth, line2ViewHeight)];
        _viewStartY = _viewStartY + line2ViewHeight;
    }
    
}

// 상세정보 라벨 그리기
- (void) drawDetailInfoLabelView
{
    
    [_detailInfoLabelView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 36)];
    [_scrollView addSubview:_detailInfoLabelView];
    
    //OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 너비, 높이
    CGRect detailInfoLabelViewbounds = _detailInfoLabelView.bounds;
    CGFloat detailInfoLabelHeight = CGRectGetHeight(detailInfoLabelViewbounds);
    
    _viewStartY = _viewStartY + detailInfoLabelHeight;
    
    [self drawOptionView];
}

// 옵션정보뷰 그리기
- (void) drawOptionView
{
    [_detailOptionBtnView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 37)];
    [_scrollView addSubview:_detailOptionBtnView];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    CGRect detailOptionBtnViewbounds = _detailOptionBtnView.bounds;
    CGFloat detailOptionBtnViewHeight = CGRectGetHeight(detailOptionBtnViewbounds);
    
    // 각 이미지의 넓이를 저장
    CGRect reserv = _reservationYN.bounds;
    CGFloat reservWidth = CGRectGetWidth(reserv);
    CGRect pac = _packingYN.bounds;
    CGFloat pacWidth = CGRectGetWidth(pac);
    CGRect car = _cardYN.bounds;
    CGFloat carWidth = CGRectGetWidth(car);
    CGRect par = _parkingYN.bounds;
    CGFloat parkWidth = CGRectGetWidth(par);
    CGRect deliv = _deliveryYN.bounds;
    CGFloat delivWidth = CGRectGetWidth(deliv);
    
    // 포장이 안되면 포장이미지넓이는 0
    if([oms.poiDetailDictionary objectForKey:@"PACK_YN"] == nil)
    {
        [_packingYN setHidden:YES];
        pacWidth = 0;
    }
    
    //NSLog(@"pack Width = %f", pacWidth);
    
    // 배달 안되면 배달이미지넓이는 0
    if([oms.poiDetailDictionary objectForKey:@"DELIVERY_YN"] == nil)
    {
        [_deliveryYN setHidden:YES];
        delivWidth = 0;
    }
    
    
    //NSLog(@"deliver Width = %f", delivWidth);
    
    // 카드 안되면 카드이미지넓이는 0
    if([oms.poiDetailDictionary objectForKey:@"CARD_YN"] == nil)
    {
        [_cardYN setHidden:YES];
        carWidth = 0;
    }
    
    //NSLog(@"card Width = %f", carWidth);
    
    // 주차 안되면 주차이미지넓이는 0
    if([oms.poiDetailDictionary objectForKey:@"PARKING_YN"] == nil)
    {
        [_parkingYN setHidden:YES];
        parkWidth = 0;
    }
    
    //NSLog(@"park Width = %f", parkWidth);
    
    // 예약 안되면 예약이미지넓이는 0
    if([oms.poiDetailDictionary objectForKey:@"RESERVATION_YN"] == nil)
    {
        [_reservationYN setHidden:YES];
        reservWidth = 0;
    }
    
    //NSLog(@"reservation Width = %f", reservWidth);
    
    int distanceR = 5;
    int distanceC = 5;
    int distanceP = 5;
    int distanceD = 5;
    // 우선순위(예약, 카드, 주차, 배달, 포장)
    // 위치(10(고정값), 10(고정값), 예약넓이, 17(고정값))
    [_reservationYN setFrame:CGRectMake(DETAILOPTION_X, DETAILOPTION_Y, reservWidth, DETAILOPTION_HEIGHT)];
    
    if(_reservationYN.hidden == YES)
        distanceR = 0;
    
    // 위치(10(고정값) + 예약너비 + 5(고정값), 10(고정값), 카드너비 + 17(고정값)
    [_cardYN setFrame:CGRectMake(DETAILOPTION_X + reservWidth + distanceR, DETAILOPTION_Y, carWidth, DETAILOPTION_HEIGHT)];
    
    if(_cardYN.hidden == YES)
        distanceC = 0;
    
    [_parkingYN setFrame:CGRectMake(DETAILOPTION_X + reservWidth + distanceR + carWidth + distanceC, DETAILOPTION_Y, parkWidth, DETAILOPTION_HEIGHT)];
    
    if(_parkingYN.hidden == YES)
        distanceP = 0;
    
    [_deliveryYN setFrame:CGRectMake(DETAILOPTION_X + reservWidth + distanceR + carWidth + distanceC + parkWidth + distanceP, DETAILOPTION_Y, delivWidth, DETAILOPTION_HEIGHT)];
    
    if(_deliveryYN.hidden == YES)
        distanceD = 0;
    
    [_packingYN setFrame:CGRectMake(DETAILOPTION_X + reservWidth + distanceR + carWidth + distanceC + parkWidth + distanceP + delivWidth + distanceD, DETAILOPTION_Y, pacWidth, DETAILOPTION_HEIGHT)];
    
    NSLog(@"옵션들 %f %f %f %f %f", _reservationYN.frame.origin.x, _cardYN.frame.origin.x, _parkingYN.frame.origin.x, _deliveryYN.frame.origin.x, _packingYN.frame.origin.x);
    // 일단 주류는 히든
    [_beerYN setHidden:YES];
    
    
    // 전부다 히든이면 옵션뷰 히든
    if(_beerYN.hidden == YES && _reservationYN.hidden == YES && _parkingYN.hidden == YES && _cardYN.hidden == YES && _deliveryYN.hidden == YES && _packingYN.hidden == YES)
    {
        
        
        [_detailOptionBtnView setHidden:YES];
    }
    else
    {
        
        _viewStartY = _viewStartY + detailOptionBtnViewHeight;
        
        [self drawUnderLine6];
    }
    
    [self drawOpeningTimeView];
    
}

// 옵션뷰 밑줄 그리기
- (void) drawUnderLine6
{
    [_scrollView addSubview:_underLine6];
    
    // 너비, 높이
    CGRect line2Viewbounds = _underLine6.bounds;
    CGFloat line2ViewWidth = CGRectGetWidth(line2Viewbounds);
    CGFloat line2ViewHeight = CGRectGetHeight(line2Viewbounds);
    
    [_underLine6 setFrame:CGRectMake(X_VALUE, _viewStartY, line2ViewWidth, line2ViewHeight)];
    _viewStartY = _viewStartY + line2ViewHeight;
}

// 영업시간 그리기
- (void) drawOpeningTimeView
{
    [_openingTimeView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 30)];
    [_scrollView addSubview:_openingTimeView];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *str = [oms.poiDetailDictionary objectForKey:@"BUSINESS_HOUR"];
    
    [_openingText setText:str];
    
    NSLog(@"영업시가아아안~ : %@", [oms.poiDetailDictionary objectForKey:@"BUSINESS_HOUR"]);
    // 정보없으면 히든
    if([oms.poiDetailDictionary objectForKey:@"BUSINESS_HOUR"] == nil)
    {
        [_openingTimeView setHidden:YES];
    }
    else {
        
        // 넘버라인 0이면 무한대로 늘어남
        // 텍스트가 라벨사이즈보다 초과되면 자동줄바꿈
        [_openingText setNumberOfLines:0];
        [_openingText setLineBreakMode:NSLineBreakByWordWrapping];
        
        // 라벨 사이즈 맞추기
        //CGSize maximumLabelSize = CGSizeMake(280,9999);
        CGSize expectedLabelSize = [_openingText.text sizeWithFont:_openingText.font
                                                 constrainedToSize:CGSizeMake(230, FLT_MAX)
                                                     lineBreakMode:_openingText.lineBreakMode];
        
        
        CGRect tempRect = _openingText.frame;
        tempRect.size.height = expectedLabelSize.height;
        _openingText.frame = tempRect;
        
        [_openingTimeView setFrame:CGRectMake(X_VALUE, _viewStartY, 320, _openingText.frame.size.height)];
        
        _viewStartY = _viewStartY + 20 + tempRect.size.height;
        
    }
    [self drawClosingTimeView];
    
}

// 휴일정보 그리기
- (void) drawClosingTimeView
{
    [_closingTimeView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 30)];
    [_scrollView addSubview:_closingTimeView];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [_closingText setText:[oms.poiDetailDictionary objectForKey:@"HOLIDAY_INFO"]];
    
    if([oms.poiDetailDictionary objectForKey:@"HOLIDAY_INFO"] == nil)
    {
        [_closingTimeView setHidden:YES];
    }
    else {
        CGRect closingTimeViewbounds = _closingTimeView.bounds;
        CGFloat closingTimeViewHeight = CGRectGetHeight(closingTimeViewbounds);
        
        _viewStartY = _viewStartY + closingTimeViewHeight;
    }
    
    
    [self drawChargeView];
}

// 이용요금 그리기
- (void) drawChargeView
{
    [_chargeView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 50)];
    [_scrollView addSubview:_chargeView];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *charge = [oms.poiDetailDictionary objectForKey:@"CHARGE_INFO"];
    
    UILabel *chargeTex = [[UILabel alloc] init];
    
    [chargeTex setText:charge];
    [chargeTex setFont:[UIFont systemFontOfSize:13]];
    [chargeTex setTextColor:[UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    
    [_chargeView addSubview:chargeTex];
    
    if([oms.poiDetailDictionary objectForKey:@"CHARGE_INFO"] == nil)
    {
        [_chargeView setHidden:YES];
    }
    else
    {
        [chargeTex setNumberOfLines:0];
        
        CGSize chareSize = [chargeTex.text sizeWithFont:chargeTex.font constrainedToSize:CGSizeMake(230, FLT_MAX)];
        
        [chargeTex setFrame:CGRectMake(80, 20, 230, chareSize.height)];
        
        [_chargeView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 20 + chareSize.height + 20)];
        _viewStartY = _viewStartY + 20 + chareSize.height + 20;
        
    }
    
    //    [_chargeText setText:charge];
    //
    //    if([oms.poiDetailDictionary objectForKey:@"CHARGE_INFO"] == nil)
    //    {
    //        [_chargeView setHidden:YES];
    //    }
    //    else {
    //
    //        // 넘버라인 0이면 무한대로 늘어남
    //        // 텍스트가 라벨사이즈보다 초과되면 자동줄바꿈
    //        [_chargeText setNumberOfLines:0];
    //        [_chargeText setLineBreakMode:NSLineBreakByWordWrapping];
    //
    //        // 라벨 사이즈 맞추기
    //        //CGSize maximumLabelSize = CGSizeMake(280,FLT_MAX);
    //        CGSize expectedLabelSize = [_chargeText.text sizeWithFont:_chargeText.font
    //                                                constrainedToSize:CGSizeMake(280, FLT_MAX)
    //                                                    lineBreakMode:_chargeText.lineBreakMode];
    //
    ////        CGRect newFrame = _chargeText.frame;
    ////        newFrame.size.height = expectedLabelSize.height;
    ////        _chargeText.frame = newFrame;
    //
    //        NSLog(@"%f", expectedLabelSize.height);
    //
    //        //    CGRect chargeViewbounds = _chargeView.bounds;
    //        //    CGFloat chargeViewHeight = CGRectGetHeight(chargeViewbounds);
    //
    //        [_chargeView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 20 + expectedLabelSize.height + 20)];
    //        _viewStartY = _viewStartY + 20 + expectedLabelSize.height + 20;
    //
    //    }
    [self checkHidden];
    //[self drawNearlyRestView];
}

// 주변식다
- (void) drawNearlyRestView
{
    //    [_nearlyRestView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 30)];
    //    [_scrollView addSubview:_nearlyRestView];
    //
    //    _viewStartY = _viewStartY + 30;
    //
    
    
    
}

// 히든체크하기
- (void) checkHidden
{
    //상세정보가 모두 히든이면 상세정보없는뷰 그리기
    if(_detailOptionBtnView.hidden == YES && _openingTimeView.hidden == YES && _closingTimeView.hidden == YES && _chargeView.hidden == YES)
    {
        int remainY = (IS_4_INCH) ? 89 : 0;
        
        _detailInfoNull = YES;
        [_detailInfoNoDataView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 66 + remainY)];
        [_scrollView addSubview:_detailInfoNoDataView];
        _viewStartY = _viewStartY + 66 + remainY;
    }
    else if (_openingTimeView.hidden == YES && _closingTimeView.hidden == YES && _chargeView.hidden == YES)
    {
        [_underLine6 setHidden:YES];
    }
    
    //    //주요정보없음, 상세정보 없음이면 블랭크POI 뷰
    if(_detailInfoNull == YES && _mainInfoNull == YES)
    {
        _mainInfoLabelView.hidden = YES;
        _underLine5.hidden = YES;
        _detailInfoNoDataView.hidden = YES;
        _mainInfoNoDataView.hidden = YES;
        _detailInfoLabelView.hidden = YES;
        
        int remainY = [[UIScreen mainScreen] bounds].size.height - 20 - 37 - 37;
        
        int blankHeight = remainY - _blankStartY;
        
        [_blankPOIView setFrame:CGRectMake(X_VALUE, _blankStartY, X_WIDTH, blankHeight)];
        [_blankPOIlbl setFrame:CGRectMake(0, 0, 320, blankHeight)];
        [_blankPOIlbl setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
        
        [_scrollView addSubview:_blankPOIView];
        _viewStartY = _blankStartY + blankHeight;
    }
    
    float currentScrollViewHeight = [[UIScreen mainScreen] bounds].size.height - 20 - 37;
    if(_viewStartY + 37 <= currentScrollViewHeight)
    {
        //_viewStartY = _scrollView.frame.size.height - 37;
        _viewStartY = currentScrollViewHeight - 37;
    }
    
    [self drawBottomView];
}

// 하단 버튼3개 뷰
- (void) drawBottomView
{
    [_bottomView setFrame:CGRectMake(X_VALUE, _viewStartY, X_WIDTH, 37)];
    [_scrollView addSubview:_bottomView];
    
    _viewStartY = _viewStartY + 37;
    
    NSLog(@"버튼뷰 좌표 : %d", _viewStartY);
    [self drawScrollHeight];
}

// 스크롤 높이
- (void) drawScrollHeight
{
    _scrollView.contentSize = CGSizeMake(X_WIDTH, _viewStartY);
    [_scrollView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - (OM_STARTY + 37))];
}
#pragma mark -
#pragma mark 버튼액션

// 이전버튼
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
    [oms.searchResult setStrLocationName:[oms.poiDetailDictionary objectForKey:@"NAME"]];
    [oms.searchResult setStrLocationAddress:[oms.poiDetailDictionary objectForKey:@"ADDR"]];
    
    [oms.searchResult setStrShape:self.shapeType];
    
    [oms.searchResult setStrSTheme:stringValueOfDictionary(oms.searchLocalDictionary, @"LastExtendFreeCall")];
    
    Coord poiCrd = CoordMake([[oms.poiDetailDictionary objectForKey:@"X"] doubleValue], [[oms.poiDetailDictionary objectForKey:@"Y"] doubleValue]);
    
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    
    [oms.searchResult setCoordLocationPoint:CoordMake(xx, yy)];
    
//    MainViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
//    main.nMapRenderType = MapRenderType_SearchResult_SinglePOI;
//    main.nMapRenderSinglePOICategory = MainMap_SinglePOI_Type_Normal;
//    [[OMNavigationController sharedNavigationController] pushViewController:main animated:YES];
    
    if(![self.shapeType isEqualToString:@""])
        [[ServerConnector sharedServerConnection] requestPolygonSearch:self action:@selector(finishedSearchLinePOI:) table:self.fcNm loadKey:self.idBgm];
    
    else
    [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Normal animated:YES];
    
   
}
- (void)finishedSearchLinePOI:(id)request
{
    if ([request finishCode] == OMSRFinishCode_Completed)
	{
        [MainViewController markingLinePolygonPOI];
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
// 전화걸기버튼
-(void)goPhoneClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    
    NSString *telNum = [oms.poiDetailDictionary objectForKey:@"TEL"];
    
    [self typeChecker:1];
    [self telViewCallBtnClick:telNum];
    
}

// 무료통화 걸기
- (void)fgoPhoneClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    //
    //
    NSString *telNum = [oms.poiDetailDictionary objectForKey:@"TEL"];
    [self typeChecker:1];
    [self telViewCallBtnClick:telNum];
}
// 무료통화 클릭시 뷰
- (void)fGoFreeCallClick:(id)sender
{
    [self.view addSubview:_callLinkView];
    
}
- (void)keyboardShow:(id)sender
{
    int callLinkAlertY = IS_4_INCH ? 0 : 88;
    
    [_callLinkAlertView setFrame:CGRectMake(116/2, 284/2 - callLinkAlertY, 410/2, 390/2)];
}
// 무료통화 걸기
- (void)goFreeCallClick:(id)sender
{
    
    // 무료통화 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail/call_link"];

    if([self telNumberCheck:_myNumber.text])
    {
        
        [[ServerConnector sharedServerConnection] requestCallLink:self action:@selector(finishCallLinks:) mid:@"ollehmap" caller:_myNumber.text called:_telLabel.text];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_FreeCall_SendError", @"")];
    }
    
}
- (void) finishCallLinks:(id)request
{
    
    //_myNumber.text = @"";
    
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        
        NSString *msg = (NSString *)[request userObject];
        
        NSLog(@"MSG : %@", msg);
        // 전송실패 e80, 90

        // 전송실패 e01, e10, e20, e30
        if ([msg isEqualToString:@"E:E01"] || [msg isEqualToString:@"E:E10"] || [msg isEqualToString:@"E:E20"] || [msg isEqualToString:@"E:E30"] || [msg isEqualToString:@"E:E80"] || [msg isEqualToString:@"E:E90"])
        {
            TelAlertView *alert = [[TelAlertView alloc] initWithTitle:@"" message:NSLocalizedString(@"Msg_FreeCall_SendError_second", @"") delegate:self cancelButtonTitle:@"통화취소" otherButtonTitles:@"유료통화", nil];
            [alert setTag:5];
            [alert show];
            
        }
        // 전송성공
        else
        {
            [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_FreeCall_SendOK", @"")];
            
            [self touchBackGround:nil];
        }
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
- (BOOL)telNumberCheck:(NSString *)tele
{
    NSString *expression = @"^(01[016789]{1}|02|0[3-9]{1}[0-9]{1})?[0-9]{3,4}?[0-9]{4}$";
    NSError *error = NULL;
    
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:expression options:NSRegularExpressionCaseInsensitive error:&error];
    
    NSTextCheckingResult *match = [regex firstMatchInString:tele options:0 range:NSMakeRange(0, [tele length])];
    
    if (!match)
        return FALSE;
    else
        return TRUE;
}

- (void)touchBackGround:(id)sender;
{
    [_callLinkAlertView setFrame:CGRectMake(116/2, 284/2, 410/2, 390/2)];
    [_callLinkView removeFromSuperview];
    
}

- (void) freeCallRemoveFromSuperViewDelegate
{
    [self touchBackGround:nil];
}

// 홈페이지 버튼
- (void)goHomePageClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *homeURL = [oms.poiDetailDictionary objectForKey:@"URL"];
    
    [self homeViewURLBtnClick:[oms urlValidCheck:homeURL]];
    
    return;
}

#pragma mark -
#pragma mark - 확장버튼 액션
// 출발지버튼
- (void)startClick:(id)sender
{
    [self typeChecker:1];
    [self btnViewStartBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
}
// 도착지버튼
- (void)destClick:(id)sender
{
    [self typeChecker:1];
    [self btnViewDestBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary ];
}
// 위치공유 버튼
- (void)shareClick:(id)sender
{
    [self typeChecker:1];
    [self btnViewShareBtnClick];
}
// 네비버튼
- (void)naviClick:(id)sender
{
    [self typeChecker:1];
    [self btnViewNaviBtnClick:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
}

#pragma mark -
#pragma mark - 하단 버튼뷰 액션
// 즐겨찾기 추가 버튼
- (void)favoriteClick:(id)sender
{
    //
    // 즐겨찾기 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail/favorite"];
    
    DbHelper *dh = [[DbHelper alloc] init];
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    NSString *ujName = [oms.poiDetailDictionary objectForKey:@"UJ_NAME"];
    
    NSMutableDictionary *fdic = [OMDatabaseConverter makeFavoriteDictionary:-1 sortOrder:-1 category:Favorite_Category_Local title1:[oms.poiDetailDictionary objectForKey:@"NAME"] title2:[oms ujNameSegment:ujName] title3:[NSString stringWithFormat:@"%@", stringValueOfDictionary(oms.searchLocalDictionary, @"LastExtendFreeCall")] iconType:Favorite_IconType_POI coord1x:[[oms.poiDetailDictionary objectForKey:@"X"] doubleValue] coord1y:[[oms.poiDetailDictionary objectForKey:@"Y"] doubleValue] coord2x:0 coord2y:0 coord3x:0 coord3y:0 detailType:@"MP" detailID:[oms.poiDetailDictionary objectForKey:@"POI_ID"] shapeType:self.shapeType fcNm:self.fcNm idBgm:self.idBgm rdCd:@""];
    
    // 중복인지 체크
    if([dh favoriteValidCheck:fdic])
    {
        // ver3테스트3번버그
        NSString *favoName = _themeToDetailName;
        
        if(!favoName || [favoName isEqualToString:@""])
        {
            favoName = [oms.poiDetailDictionary objectForKey:@"NAME"];
        }
        [self typeChecker:1];
        [self bottomViewFavorite:fdic placeHolder:favoName];
        
    }
    
}
// 연락처 추가 버튼
- (void)contactClick:(id)sender
{
    [self modalContact:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
    
}
// 정보수정 버튼
- (void)modifyClick:(id)sender
{
    [self typeChecker:1];
    [self modalInfoModify:[OllehMapStatus sharedOllehMapStatus].poiDetailDictionary];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
