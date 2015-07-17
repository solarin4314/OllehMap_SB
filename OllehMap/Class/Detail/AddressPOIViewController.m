//
//  AddressPOIViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 7..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "AddressPOIViewController.h"

@interface AddressPOIViewController ()

@end

@implementation AddressPOIViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    [_mapBtn setHidden:NO];
    [_mapBtn setHidden:!_displayMapBtn];
    
    // 좌표값이 0이면 disabled
    if(_poiCrd.x == 0 && _poiCrd.y == 0)
        [_mapBtn setHidden:YES];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [_scrollView setFrame:CGRectMake(0, OM_STARTY + 37, 320, 0)];
    
    _viewStartY = GeneralStartY;
    // Do any additional setup after loading the view from its nib.
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    self.rdCd = [NSString stringWithFormat:@"%@", [oms.searchLocalDictionary objectForKey:@"LastExtendRoadCode"]];
    
    if(self.mapToDetail)
        self.rdCd = oms.searchResult.strLocationRoadName;
    
    // 일단 그리고 시작
    [self getDictionary];
    
    [self drawTopView];
}
// 딕셔너리를 만든다
- (void) getDictionary
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [oms.addressPOIDictionary removeAllObjects];
    
    Coord poiCrd = _poiCrd;
    double x = poiCrd.x;
    double y = poiCrd.y;
    
    [oms.addressPOIDictionary setObject:_poiZibunAddress forKey:@"NAME"];
    [oms.addressPOIDictionary setObject:_poiRoadAddress forKey:@"ADDR"];
    [oms.addressPOIDictionary setValue:[NSNumber numberWithDouble:x] forKey:@"X"];
    [oms.addressPOIDictionary setValue:[NSNumber numberWithDouble:y] forKey:@"Y"];
    [oms.addressPOIDictionary setObject:self.rdCd forKey:@"RdCd"];
    
}

#pragma mark -
#pragma mark AddressPOIViewController
- (void) saveRecentSearch
{
    NSString *addName = _poiZibunAddress;
    NSString *newDetail = _poiRoadAddress;
    //NSString *oldOrNew = self.oldOrNew;
    
    if([newDetail isEqualToString:@""] || !newDetail)
    {
        newDetail = @"";
    }
    else
        newDetail = _poiRoadAddress;
    
    NSMutableDictionary *addPOIDic = [NSMutableDictionary dictionary];
    
    Coord addPOICrd = _poiCrd;
    
    double xx = addPOICrd.x;
    double yy = addPOICrd.y;
    
    [addPOIDic setObject:addName forKey:@"NAME"];
    [addPOIDic setObject:newDetail forKey:@"NEWADDRESS"];
    [addPOIDic setObject:self.oldOrNew forKey:@"OLDORNEW"];
    [addPOIDic setObject:@"" forKey:@"CLASSIFY"];
    [addPOIDic setValue:[NSNumber numberWithDouble:xx] forKey:@"X"];
    [addPOIDic setValue:[NSNumber numberWithDouble:yy] forKey:@"Y"];
    [addPOIDic setObject:@"ADDR" forKey:@"TYPE"];
    [addPOIDic setObject:@"" forKey:@"ID"];
    [addPOIDic setObject:@"" forKey:@"TEL"];
    [addPOIDic setObject:addName forKey:@"ADDR"];
    [addPOIDic setObject:[NSNumber numberWithInt:Favorite_IconType_POI] forKey:@"ICONTYPE"];
    
    // 도로명 코드 저장
    [addPOIDic setObject:self.rdCd forKey:@"RD_CD"];
    
    NSLog(@"최근검색저장 : %@", addPOIDic);
    
    [[OllehMapStatus sharedOllehMapStatus] addRecentSearch:addPOIDic];
    
    //self.rdCd = @"";
}

// 최상단 뷰(이름, 주소, 분류, 이미지)
- (void) drawTopView
{
    int topViewHeight = 90;
    
    UIColor *labelBg = [UIColor clearColor];
    
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY, 320, topViewHeight)];
    [topView setBackgroundColor:[UIColor colorWithRed:217.0/255.0 green:244.0/255.0 blue:255.0/255.0 alpha:1]];
    
    
    int betweenSubAndSubSub = 0;
    
    // 지번주소에서 넘어왔다 지번-도로명-행정
    if([self.oldOrNew isEqualToString:@"Old"])
    {
        // 지번주소
        UILabel *poiName = [[UILabel alloc] init];
        [poiName setText:_poiZibunAddress];
        [poiName setFont:[UIFont boldSystemFontOfSize:13]];
        [poiName setBackgroundColor:labelBg];
        [poiName setNumberOfLines:1];
        [poiName setFrame:CGRectMake(90, 16, 210, 13)];
        [poiName setAdjustsFontSizeToFitWidth:YES];
//        CGSize poiNameSize = [poiName.text sizeWithFont:poiName.font constrainedToSize:CGSizeMake(183, FLT_MAX)];
//        
//        [poiName setFrame:CGRectMake(127, 16, poiNameSize.width, poiNameSize.height)];

        [topView addSubview:poiName];

        if(![self.poiRoadAddress isEqualToString:@""])
        {
            
            // 도로명주소이미지
            UIImageView *subImg = [[UIImageView alloc] init];
            
            [subImg setImage:[UIImage imageNamed:@"new_address_icon.png"]];
            
            [subImg setFrame:CGRectMake(90, 35, 33, 15)];
            
            [topView addSubview:subImg];
            
        // 도로명주소
        UILabel *subAddr = [[UILabel alloc] init];
        [subAddr setFont:[UIFont systemFontOfSize:13]];
        [subAddr setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        [subAddr setText:self.poiRoadAddress];
        //[subAddr setNumberOfLines:0];
        [subAddr setAdjustsFontSizeToFitWidth:YES];
        [subAddr setBackgroundColor:[UIColor clearColor]];
        [subAddr setFrame:CGRectMake(127, 36, 183, 13)];
        [topView addSubview:subAddr];
 
            betweenSubAndSubSub += 20;
        }
        
        
        
        if(![self.poiHangAddress isEqualToString:@""])
        {
        // 도로명주소
        UILabel *subSubAddr = [[UILabel alloc] init];
        [subSubAddr setFont:[UIFont systemFontOfSize:13]];
        [subSubAddr setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        [subSubAddr setText:self.poiHangAddress];
        //[subSubAddr setNumberOfLines:0];
        [subSubAddr setBackgroundColor:[UIColor clearColor]];
        [subSubAddr setAdjustsFontSizeToFitWidth:YES];
        
        [subSubAddr setFrame:CGRectMake(127, 36 + betweenSubAndSubSub, 183, 13)];
        [topView addSubview:subSubAddr];
        
        // 행정동주소이미지(이미지요청)
        UIImageView *subImg = [[UIImageView alloc] init];
        
        [subImg setImage:[UIImage imageNamed:@"hangjung_address_icon.png"]];
        
        [subImg setFrame:CGRectMake(90, 35 + betweenSubAndSubSub, 33, 15)];
        
        [topView addSubview:subImg];
            
        }

    }
    // 도로명주소에서 넘어왔다 도로명-지번
    else
    {
        
        // 도로명주소
        UILabel *poiName = [[UILabel alloc] init];
        [poiName setText:_poiZibunAddress];
        [poiName setFont:[UIFont boldSystemFontOfSize:13]];
        [poiName setBackgroundColor:labelBg];
        [poiName setAdjustsFontSizeToFitWidth:YES];
        //[poiName setNumberOfLines:0];
        
        [poiName setFrame:CGRectMake(90, 16, 220, 13)];
        
//        CGSize poiNameSize = [poiName.text sizeWithFont:poiName.font constrainedToSize:CGSizeMake(220, FLT_MAX)];
//        
//        [poiName setFrame:CGRectMake(90, 16, poiNameSize.width, poiNameSize.height)];
        
        [topView addSubview:poiName];
        
        if(![self.poiRoadAddress isEqualToString:@""])
        {
        // 지번주소
        UILabel *subAddr = [[UILabel alloc] init];
        [subAddr setFont:[UIFont systemFontOfSize:13]];
        [subAddr setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
        [subAddr setText:self.poiRoadAddress];
        [subAddr setBackgroundColor:[UIColor clearColor]];
        [subAddr setFrame:CGRectMake(127, 36 + betweenSubAndSubSub, 183, 13)];
        [subAddr setAdjustsFontSizeToFitWidth:YES];
        [topView addSubview:subAddr];
        
        
        // 지번주소이미지
        UIImageView *subImg = [[UIImageView alloc] init];

        [subImg setImage:[UIImage imageNamed:@"old_address_icon.png"]];
        
        [subImg setFrame:CGRectMake(90, 35 + betweenSubAndSubSub, 33, 15)];
        
        [topView addSubview:subImg];
        
        }
        
    }

    UIImageView *poiImg = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 70, 70)];
    [poiImg setImage:[UIImage imageNamed:@"view_default_img_box.png"]];
    [topView addSubview:poiImg];
    
    
    UIImageView *poiImgBox = [[UIImageView alloc] init];
    [poiImgBox setFrame:CGRectMake(10, 10, 70, 70)];
    [poiImgBox setImage:[UIImage imageNamed:@"view_img_box.png"]];
    [topView addSubview:poiImgBox];
    
    
    [_scrollView addSubview:topView];
    
    
    _viewStartY += topViewHeight;
    
    // 상단뷰 밑줄
    [self drawUnderLine1];
    
}

// 상단뷰 밑줄
- (void) drawUnderLine1
{
    UIImageView *underLine1 = [[UIImageView alloc] initWithFrame:CGRectMake(0, _viewStartY, 320, 1)];
    [underLine1 setImage:[UIImage imageNamed:@"poi_list_line_01.png"]];
    // 스크롤뷰에 밑줄뷰 추가
    [_scrollView addSubview:underLine1];
    _viewStartY += 1;

    // 일단 전번 없으니 바로 밑줄로 가겠어
    [self drawBtnView];
}

// 중간 버튼뷰 : 출발지, 도착지, 위치공유, 올레Navi
- (void) drawBtnView
{
    int btnViewHeight = 56;
    
    NSLog(@"%@", [self.rdCd isEqualToString:@""] ? @"도로아님" : @"도로임");
    
    UIView *btnView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY, 320, btnViewHeight)];
    UIImageView *btnBg = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 320, btnViewHeight)];
    
    [btnBg setImage:[UIImage imageNamed:@"poi_list_menu_bg.png"]];
    
    [btnView addSubview:btnBg];
    
    UIButton *startBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    startBtn.frame = CGRectMake(10, 9, 81, 37);
    
    [startBtn setImage:[UIImage imageNamed:@"poi_list_btn_start.png"] forState:UIControlStateNormal];
    [startBtn setEnabled:[self.rdCd isEqualToString:@""] ? YES : NO];
    [startBtn addTarget:self action:@selector(startClickAd:) forControlEvents:UIControlEventTouchUpInside];
    [startBtn setImage:[UIImage imageNamed:@"poi_list_btn_start_disabled.png"] forState:UIControlStateDisabled];
    
    [btnView addSubview:startBtn];
    
    UIButton *destBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    destBtn.frame = CGRectMake(96, 9, 81, 37);
    
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop.png"] forState:UIControlStateNormal];
    [destBtn setEnabled:[self.rdCd isEqualToString:@""] ? YES : NO];
    [destBtn addTarget:self action:@selector(destClickAd:) forControlEvents:UIControlEventTouchUpInside];
    [destBtn setImage:[UIImage imageNamed:@"poi_list_btn_stop_disabled.png"] forState:UIControlStateDisabled];
    
    [btnView addSubview:destBtn];
    
    UIButton *shareBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    shareBtn.frame = CGRectMake(182, 9, 61, 37);
    
    [shareBtn setImage:[UIImage imageNamed:@"poi_list_btn_share.png"] forState:UIControlStateNormal];
    [shareBtn addTarget:self action:@selector(shareClickAd:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:shareBtn];
    
    UIButton *naviBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    naviBtn.frame = CGRectMake(248, 9, 61, 37);
    
    [naviBtn setImage:[UIImage imageNamed:@"poi_list_btn_navi.png"] forState:UIControlStateNormal];
    [naviBtn addTarget:self action:@selector(naviClickAd:) forControlEvents:UIControlEventTouchUpInside];
    
    [btnView addSubview:naviBtn];
    
    
    [_scrollView addSubview:btnView];
    
    _viewStartY += btnViewHeight;

    if([self.rdCd isEqualToString:@""] || ![self.poiRoadAddress isEqualToString:@""])
    {
        [self drawNullLabel];
    }
    else
        [[ServerConnector sharedServerConnection] requestRoadNameSearch:self action:@selector(finishedRoadNameSearchEnd:) roadCode:self.rdCd];
    
}
- (void) finishedRoadNameSearchEnd:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        UIView *mainInfoLabelView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY + OM_STARTY, 320, 36)];
        
        UILabel *mainInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, 280, 14)];
        [mainInfoLabel setText:@"주요정보"];
        [mainInfoLabel setFont:[UIFont boldSystemFontOfSize:14]];
        [mainInfoLabelView addSubview:mainInfoLabel];
        
        [_scrollView addSubview:mainInfoLabelView];
        
        _viewStartY += 36;
        
        UIView *mainInfoView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY, 320, 170)];
        
        
        UILabel *startPoint = [[UILabel alloc] initWithFrame:CGRectMake(10, 15, 300, 15)];
        [startPoint setFont:[UIFont systemFontOfSize:14]];
        [startPoint setText:[NSString stringWithFormat:@"* 기점 : %@", [[[[[OllehMapStatus sharedOllehMapStatus].roadNameDictionary objectForKeyGC:@"RoadCode"] objectAtIndexGC:1] objectForKey:@"info"] objectForKey:@"RBP_CN"]]];
        [mainInfoView addSubview:startPoint];
        
        UILabel *destPoint = [[UILabel alloc] initWithFrame:CGRectMake(10, 40, 300, 15)];
        [destPoint setFont:[UIFont systemFontOfSize:14]];
        [destPoint setText:[NSString stringWithFormat:@"* 종점 : %@", [[[[[OllehMapStatus sharedOllehMapStatus].roadNameDictionary objectForKeyGC:@"RoadCode"] objectAtIndexGC:1] objectForKey:@"info"] objectForKey:@"REP_CN"]]];
        [mainInfoView addSubview:destPoint];
        
        UILabel *reason = [[UILabel alloc] init];
        [reason setFrame:CGRectMake(10, 60, 300, 90)];
        [reason setFont:[UIFont systemFontOfSize:14]];
        [reason setNumberOfLines:0];
        [reason setText:[NSString stringWithFormat:@"* 도로명 부여 사유 : %@", [[[[[OllehMapStatus sharedOllehMapStatus].roadNameDictionary objectForKeyGC:@"RoadCode"] objectAtIndexGC:1] objectForKey:@"info"] objectForKey:@"ALWNC_RESN"]]];
        [mainInfoView addSubview:reason];
        
        [_scrollView addSubview:mainInfoView];
        
        _viewStartY = self.view.frame.size.height - OM_STARTY - 37;
        
        NSLog(@"viewStartY : %d", _viewStartY);
        
        [self drawBottomView];
    }
    else
    {
        [self drawNullLabel];
    }
}
// 공백라벨
- (void) drawNullLabel
{
    // 높이
    _nullSizeY = ([UIScreen mainScreen].bounds.size.height
                  - 37
                  - 20) - _viewStartY;
    
    int nullLblY = ((_nullSizeY / 2) - 26) + _viewStartY;
    
    UILabel *nullLbl = [[UILabel alloc] init];
    
    [nullLbl setFrame:CGRectMake(0, nullLblY, 320, 13)];
    [nullLbl setText:NSLocalizedString(@"Msg_Detail_InfoNull", @"")];
    [nullLbl setFont:[UIFont systemFontOfSize:13]];
    [nullLbl setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1.0)];
    [nullLbl setTextAlignment:NSTextAlignmentCenter];
    
    [_scrollView addSubview:nullLbl];

    _viewStartY += _nullSizeY;
    NSLog(@"viewStartY : %d", _viewStartY);
    
    [self drawBottomView];
}

// 버튼뷰 : 즐겨찾기 추가, 연락처 추가, 정보수정 요청
- (void) drawBottomView
{
    UIView *bottomView = [[UIView alloc] initWithFrame:CGRectMake(0, _viewStartY - 37, 320, 37)];
    
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBtn setFrame:CGRectMake(0, 0, 107, 37)];
    [favoriteBtn setImage:[UIImage imageNamed:@"poi_botton_btn_01.png"] forState:UIControlStateNormal];
    [favoriteBtn addTarget:self action:@selector(favoBtnClickAd:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:favoriteBtn];
    
    UIButton *contactBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [contactBtn setFrame:CGRectMake(107, 0, 106, 37)];
    [contactBtn setImage:[UIImage imageNamed:@"poi_botton_btn_02.png"] forState:UIControlStateNormal];
    [contactBtn addTarget:self action:@selector(contactBtnClickAd:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:contactBtn];
    
    
    UIButton *infoModifyBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [infoModifyBtn setFrame:CGRectMake(213, 0, 107, 37)];
    [infoModifyBtn setImage:[UIImage imageNamed:@"poi_botton_btn_03.png"] forState:UIControlStateNormal];
    [infoModifyBtn addTarget:self action:@selector(modifyBtnClickAd:) forControlEvents:UIControlEventTouchUpInside];
    [bottomView addSubview:infoModifyBtn];
    
    [_scrollView addSubview:bottomView];
    
    //_viewStartY += 37;
    
    [self drawScrollViewHeight];
}
- (void) drawScrollViewHeight
{
    _scrollView.contentSize = CGSizeMake(320, _viewStartY);
    [_scrollView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - (OM_STARTY + 37))];
    //[_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_scrollView setAutoresizesSubviews:YES];
    
    [self saveRecentSearch];
}

#pragma mark -
#pragma mark IBAction
- (IBAction)popBtnClick:(id)sender
{
    [MapContainer sharedMapContainer_Main].kmap.delegate = nil;
    
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}
- (IBAction)mapBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    [oms.searchResult reset]; // 검색결과 리셋
    [oms.searchResult setUsed:YES];
    [oms.searchResult setIsCurrentLocation:NO];
    [oms.searchResult setStrLocationName:_poiZibunAddress];
    [oms.searchResult setStrLocationAddress:_poiRoadAddress];
    
    Coord poiCrd = _poiCrd;
    
    double xx = poiCrd.x;
    double yy = poiCrd.y;
    [oms.searchResult setCoordLocationPoint:CoordMake(xx, yy)];
    [oms.searchResult setStrLocationRoadName:self.rdCd];
    
//    MainViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
//    main.nMapRenderType = MapRenderType_SearchResult_SinglePOI;
//    main.nMapRenderSinglePOICategory = MainMap_SinglePOI_Type_Normal;
//    [[OMNavigationController sharedNavigationController] pushViewController:main animated:YES];
    
    if(![self.rdCd isEqualToString:@""])
    {
        [[ServerConnector sharedServerConnection] requestRoadNameSearch:self action:@selector(finishedRoadNameSearch:) roadCode:self.rdCd];
    }
    else
    [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Normal animated:YES];
    
}
- (void) finishedRoadNameSearch:(id)request
{
    if ([request finishCode] == OMSRFinishCode_Completed)
	{
        [MainViewController markingRoadCodeSearch];
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
- (void) startClickAd:(id)sender
{
    [self typeChecker:4];
    [self btnViewStartBtnClick:[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary];
}
- (void) destClickAd:(id)sender
{
    [self typeChecker:4];
    [self btnViewDestBtnClick:[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary];
}
- (void) shareClickAd:(id)sender
{
    [self typeChecker:4];
    [self btnViewShareBtnClick];
}
- (void) naviClickAd:(id)sender
{
    [self typeChecker:4];
    [self btnViewNaviBtnClick:[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary];
}

- (void) favoBtnClickAd:(id)sender
{
    DbHelper *dh = [[DbHelper alloc] init];
    
    NSMutableDictionary *fdic = [OMDatabaseConverter makeFavoriteDictionary:-1 sortOrder:-1 category:Favorite_Category_Local title1:_poiZibunAddress title2:_poiRoadAddress title3:@"" iconType:Favorite_IconType_POI coord1x:_poiCrd.x coord1y:_poiCrd.y coord2x:0 coord2y:0 coord3x:0 coord3y:0 detailType:@"ADDR" detailID:@"" shapeType:@"" fcNm:@"" idBgm:@"" rdCd:[[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary objectForKeyGC:@"RdCd"]];
    
    if([dh favoriteValidCheck:fdic])
    {
        [self typeChecker:4];
        [self bottomViewFavorite:fdic placeHolder:stringValueOfDictionary([OllehMapStatus sharedOllehMapStatus].addressPOIDictionary, @"NAME")];
    }
    
}
- (void) contactBtnClickAd:(id)sender
{
    [self modalContact:[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary];
}

- (void) modifyBtnClickAd:(id)sender
{
    [self typeChecker:4];
    [self modalInfoModify:[OllehMapStatus sharedOllehMapStatus].addressPOIDictionary];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
