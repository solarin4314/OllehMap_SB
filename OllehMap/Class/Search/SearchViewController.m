//
//  SettingViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "SearchViewController.h"

@interface SearchViewController ()

@end

@implementation RecentTableView
@end
@implementation RecommandTableView
@end

@implementation SearchViewController

@synthesize recentList = _recentList;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewDidAppear:(BOOL)animated
{
    
    // 포커스 키보드에게 준다
    [super viewDidAppear:animated];
    
    [_recentTable reloadData];
    
    // 재검색뷰 초기화
    searchOption = 1;
    [_anotherSearchView setHidden:YES];
    _ex = NO;
    
    if (_currentSearchTargetType != SearchTargetType_NONE && _currentSearchTargetType != SearchTargetType_VOICENONE)
    {
        // 셀 생성
        UIControl *vwMyLocation = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 58+1)];
        [vwMyLocation setBackgroundColor:[UIColor whiteColor]];
        [vwMyLocation addTarget:self action:@selector(onMyLocationCell:) forControlEvents:UIControlEventTouchUpInside];
        // 아이콘
        UIImageView *imgvwIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_b_marker_location.png"]];
        [imgvwIcon setFrame:CGRectMake(9, 12, 25, 34)];
        [vwMyLocation addSubview:imgvwIcon];
        // 라벨
        UILabel *lblMyLocation = [[UILabel alloc] initWithFrame:CGRectMake(41, 20, (540-82)/2, 21)];
        [lblMyLocation setFont:[UIFont boldSystemFontOfSize:15]];
        [lblMyLocation setText:NSLocalizedString(@"Body_SR_AutoMyLoc_Start", @"")];
        [vwMyLocation addSubview:lblMyLocation];
        // 하단 라인 삽입
        UIView *vwLine = [[UIView alloc] initWithFrame:CGRectMake(0, 58, 320, 1)];
        [vwLine setBackgroundColor:convertHexToDecimalRGBA(@"DC", @"DC", @"DC", 1.0f)];
        [vwMyLocation addSubview:vwLine];
        // 셀 삽입
        _recentTable.tableHeaderView = vwMyLocation;
    }
    
    
    [_searchField performSelector:@selector(becomeFirstResponder) withObject:nil afterDelay:0.1];
    
    // 싱글POI에서 txtSearchField 에 키워드 스트링을 넣는데 최근검색에서 갈 경우에는 빈 값을 넣어야됨..이렇게 안하면 검색후 다시 최근검색으로 돌아와서 최근검색 리스트를 클릭하면, 전에 검색했던 키워드가 들어있기 때문에 초기화
    [OllehMapStatus sharedOllehMapStatus].keyword = @"";
    
}
// 내위치 버튼액션
- (void) onMyLocationCell :(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    OMSearchResult *omsr = nil;
    
    // 현재 검색대상별로 오브젝트 설정
    switch (_currentSearchTargetType)
    {
        case SearchTargetType_START:
        case SearchTargetType_VOICESTART:
        {
            omsr = oms.searchResultRouteStart;
        }
            break;
            
        case SearchTargetType_VISIT:
        case SearchTargetType_VOICEVISIT:
        {
            omsr = oms.searchResultRouteVisit;
        }
            break;
            
        case SearchTargetType_DEST:
        case SearchTargetType_VOICEDEST:
        {
            omsr = oms.searchResultRouteDest;
        }
            break;
            
        default:
        {
            return;
        }
            break;
    }
    
    // 길찾기 검색조건 채움
    [omsr reset];
    [omsr setUsed:YES];
    [omsr setIsCurrentLocation:YES];
    [omsr setStrLocationName:NSLocalizedString(@"Body_SR_AutoMyLoc_Start", @"")];
    //[omsr setStrLocationAddress:NSLocalizedString(@"Body_SR_AutoMyLoc_Start", @"")];
    if ( [MapContainer CheckLocationServiceWithoutAlert] )
        [omsr setCoordLocationPoint:[MapContainer sharedMapContainer_Main].kmap.getUserLocation];
    else
        [omsr setCoordLocationPoint:OM_DefaultCoord];
    
    // 키보드 내림
    [self.searchField resignFirstResponder];
    
    // 길찾기 팝업 호출
    [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0 && _currentSearchTargetType == SearchTargetType_NONE)
    {
        [_recentTable setHidden:YES];
    }
    
    if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0 && _recommandTable.hidden == YES && _recommandTable.hidden == YES)
    {
        [_recentListEmpty setHidden:NO];
    }
    
    
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    [oms.pushDataBusNumberArray removeAllObjects];
    [oms.pushDataBusStationArray removeAllObjects];

}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //NSLog(@"푸시스테이션 %@ \n 푸시버스 %@", oms.pushDataBusStationArray, oms.pushDataBusNumberArray);
    
    _currentSearchTargetType = oms.currentSearchTargetType;
    
    // 검색타겟 설정(출발, 도착, 경유)에 따른 네비바 텍스트 변경
    switch (oms.currentActionType)
    {
        case ActionType_MAP:
            break;
        case ActionType_SEARCH:
            break;
        case ActionType_SEARCHROUTE:
            if (_currentSearchTargetType == SearchTargetType_START)
            {
                [_naviTitleLabel2 setText:@"출발지 검색"];
            }
            
            else if (_currentSearchTargetType == SearchTargetType_VISIT)
            {
                [_naviTitleLabel2 setText:@"경유지 검색"];
            }
            else if (_currentSearchTargetType == SearchTargetType_DEST)
            {
                [_naviTitleLabel2 setText:@"도착지 검색"];
            }
            break;
        case ActionType_THEME:
            break;
        case ActionType_CONFIG:
            break;
            
        default:
            break;
    }
    
    // x버튼 no 상태
    _xClick = NO;
    
    
    // 텍스트변화 노티캐치
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(UITextFieldDidChange) name:UITextFieldTextDidChangeNotification object:nil];
    
    // 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search"];
    
    // 서치뷰 문제시 주석해제하고 statusbar달아
    [_recommandTable setFrame:CGRectMake(0, OM_STARTY + 83, 320,
                                         self.view.frame.size.height - (OM_STARTY + 83))];
    //
    [_recentTable setFrame:CGRectMake(0, OM_STARTY + 120,
                                      320,
                                      self.view.frame.size.height - (OM_STARTY + 120))];
}
#pragma mark -
#pragma mark textField

// 리턴버튼 클릭순서 1(키보드 포커스 닫고 search)
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [_searchField resignFirstResponder];
    [self onSearch];
    return YES;
    
}
// 텍스트 변화 캐치
- (void) UITextFieldDidChange
{
    // X버튼 상태에 변화
    if(_xClick == YES)
    {
        [self recommandShow:YES];
        
        if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0)
        {
            [_recentTable setHidden:YES];
            [_recentListEmpty setHidden:NO];
        }
        _xClick = NO;
    }
    
    else
    {
        [self recommandShow:NO];
        
    }
    
    
    // 이부분 주석하니까 다운 안되는거 같음...
    // 텍스트 변할 떄마다 추천검색 제거
    //[[OllehMapStatus sharedOllehMapStatus].searchAutoMakeArray removeAllObjects];
    
    // 추천검색
    DbHelper *dbh = [[DbHelper alloc] init];
    if(_searchField.text.length > 0)
    {
        [dbh getAutomakeKeyword:_searchField.text];
        [_recommandTable reloadData];
    }
    
    
    // 길이가 0보다 크면 추천검색테이블보여짐
	if(_searchField.text.length > 0)
    {
        [self recommandShow:YES];
        
    }
    // 텍스트 없을때
    if(_searchField.text.length == 0)
    {
        NSLog(@"아무글자도없다");
        
        [self recommandShow:NO];
        
        if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0 && _currentSearchTargetType == SearchTargetType_NONE)
        {
            [_recentTable setHidden:YES];
            
            [_emptyView setHidden:NO];
            
        }
        else
        {
            [_emptyView setHidden:YES];
        }
        
    }
    else
    {
        [_emptyView setHidden:YES];
    }
    
}

- (void) recommandShow:(BOOL)boolean
{
    _favoriteBtn.hidden = boolean;
    _contactBtn.hidden = boolean;
    _voiceBtn.hidden = boolean;
    _noSearchBackGround.hidden = boolean;
    _searchBackGround.hidden = !boolean;
    _recentTable.hidden = boolean;
    _xBtn.hidden = !boolean;
    _xClick = boolean;
    _recommandTable.hidden = !boolean;
    _recentListEmpty.hidden = boolean;
}
// 스트링변화 1스텝(텍스트 40글자 이상이면 입력 막기
// 사실 여기서 노티센터 없이 해야 되는데 여기서는 첫 입력 글자를 잡지 못함
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    
    int maxLength = 40;
    
    
    NSLog(@"String : %@", string);
    NSLog(@"textField : %@", _searchField.text);
    
    //string은 현재 키보드에서 입력한 문자 한개를 의미한다.
    if([string length] && ([_searchField.text length] >= maxLength))
        return NO;
    
    return TRUE;
    
}

#pragma mark -
#pragma mark - 검색
// 검색합니다
- (IBAction)anotherBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *searchType = [[oms.searchLocalDictionary objectForKeyGC:@"SearchType"] objectForKeyGC:@"orgType"];
    
    NSString *mylocationStr = [NSString stringWithFormat:@"현재위치 근처 %@", self.searchField.text];
    NSString *locationNearStr = nil;
    
    
    if([searchType isEqualToString:@"A"] || [searchType isEqualToString:@"B"] || [searchType isEqualToString:@"G"])
        {
            locationNearStr = [NSString stringWithFormat:@"%@ 근처 장소", oms.keyword];
        }
        else if([searchType isEqualToString:@"C"] || [searchType isEqualToString:@"D"] || [searchType isEqualToString:@"E"])
        {
            locationNearStr = [NSString stringWithFormat:@"%@ 근처 %@", [oms poiQueryReturn], [oms r_QueryReturn]];
        }
        
        NSString *oldAddressStr =  nil;
        
        if([searchType isEqualToString:@"B"])
        {
            oldAddressStr = [NSString stringWithFormat:@"지번주소 %@ 근처 장소", [oms poiQueryReturn]];
        }
        else if ([searchType isEqualToString:@"D"])
        {
            oldAddressStr = [NSString stringWithFormat:@"지번주소 %@ 근처 %@", [oms poiQueryReturn], [oms r_QueryReturn]];
        }
        
        UIActionSheet *actionSheet = nil;
        
        // ver3 수정사항 : 구주소 갯수가 1개 이상이어야 옵션3으로 검색가능
        int oldAddCount = (int)[(NSMutableDictionary *)[[OllehMapStatus sharedOllehMapStatus].searchLocalDictionary objectForKeyGC:@"DataAddress"] count];
        
        //NSLog(@"힝 %@", [OllehMapStatus sharedOllehMapStatus].searchLocalDictionary);
        
        if(([searchType isEqualToString:@"B"] || [searchType isEqualToString:@"D"]) && oldAddCount > 1)
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:locationNearStr  otherButtonTitles:mylocationStr, oldAddressStr, nil];
            [actionSheet setTag:2];
            
            actionSheet.destructiveButtonIndex = searchOption-1;
        }
        else
        {
            actionSheet = [[UIActionSheet alloc] initWithTitle:@"" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:locationNearStr otherButtonTitles:mylocationStr , nil];
            [actionSheet setTag:1];
            
            if([oms reSearchException])
                actionSheet.destructiveButtonIndex = searchOption-1;
            else
            {
                if(searchOption == 1)
                    actionSheet.destructiveButtonIndex = 1;
                else if(searchOption == 2)
                    actionSheet.destructiveButtonIndex = 0;
            }
            
            
        }
        
        
        
        [actionSheet showInView:[self view]];
        
    

}

- (void)onSearch
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    
    if(self.searchField.text.length > 0)
        oms.keyword = _searchField.text;
    
    // 기본은 정확도 검색이지만 외부에서 공유했을 때 거리순을 공유했다면 order값이 yes
    NSString *myOrder = @"Rank";
    if(self.order == YES)
    {
        myOrder = @"DIS";
    }
    
    
    NSLog(@"키워드 : %@", oms.keyword);
    
    [oms resetLocalSearchDictionary:@"Place"];
    [oms resetLocalSearchDictionary:@"Address"];
    [oms resetLocalSearchDictionary:@"PublicBusStation"];
    [oms resetLocalSearchDictionary:@"PublicBusNumber"];
    [oms resetLocalSearchDictionary:@"PublicSubwayStation"];
    
    
    // 장소검색먼저
    [[ServerConnector sharedServerConnection]
     requestSearchPlaceAndAddress:self
     action:@selector(didFinishSearch_Place:)
     key:oms.keyword
     mapX:[MapContainer sharedMapContainer_Main].kmap.centerCoordinate.x
     mapY:[MapContainer sharedMapContainer_Main].kmap.centerCoordinate.y
     s:@"p"
     sr:myOrder
     p_startPage:0
     a_startPage:0
     n_startPage:0
     indexCount:15 option:searchOption];
    
}
- (void) didFinishSearch_Place :(id)request
{
    // 장소검색 성공했으면 주소검색은 0로 카운트만 검색 / 장소검색 성공했으나 데이터 없으면 주소검색 15카운트검색
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        int countPlace = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountPlace"] intValue];
        
        // 기본은 정확도 검색이지만 외부에서 공유했을 때 거리순을 공유했다면 order값이 yes
        NSString *myOrder = @"Rank";
        if(self.order == YES)
        {
            myOrder = @"DIS";
        }
        
        // 장소 검색결과에 따라  실제데이터 or 카운트 처리
        int requestAddressCount = 15;
        if  ( countPlace > 0 ) requestAddressCount = 0;
        
        [[ServerConnector sharedServerConnection]
         requestSearchPlaceAndAddress:self
         action:@selector(didFinishSearch_Address:)
         key:oms.keyword
         mapX:[MapContainer sharedMapContainer_Main].kmap.centerCoordinate.x
         mapY:[MapContainer sharedMapContainer_Main].kmap.centerCoordinate.y
         s:@"an"
         sr:myOrder
         p_startPage:0
         a_startPage:0
         n_startPage:0
         indexCount:15 option:searchOption];
    }
    // 검색중 오류 발생했으면 모든 검색 중단,
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) didFinishSearch_Address :(id)request
{
    // 주소검색까지 성공했으면 버스정류장 검색
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        if([oms number5VaildCheck:oms.keyword] || [oms uniqueVaildCheck:oms.keyword])
        {
            [[ServerConnector sharedServerConnection] requestSearchPublicBusStationUnique:self action:@selector(didFinishSearch_PublicBusStation:) UniqueId:oms.keyword];
        }
        else
        {
            
            [[ServerConnector sharedServerConnection]
             requestSearchPublicBusStation:self
             action:@selector(didFinishSearch_PublicBusStation:)
             Name:oms.keyword
             ViewCnt:15
             Page:0];
            
        }
    }
    // 검색중 오류 발생했으면 모든 검색 중단,
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) didFinishSearch_PublicBusStation :(id)request
{
    // 버스정류장 검색 성공했으면 버스노선 검색
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        [[ServerConnector sharedServerConnection]
         requestSearchPublicBusNumber:self
         action:@selector(didFinishSearch_PublicBusNumber:)
         key:oms.keyword
         startPage:0
         indexCount:15];
    }
    // 검색중 오류 발생했으면 모든 검색 중단,
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) didFinishSearch_PublicBusNumber :(id)request
{
    // 버스노선 검색 성공했으면 지하철 검색
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        [[ServerConnector sharedServerConnection]
         requestSearchPublicSubwayStation:self
         action:@selector(didFinishSearch_PublicSubwayStation:)
         Name:oms.keyword];
        
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    // 검색중 오류 발생했으면 모든 검색 중단,
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) didFinishSearch_PublicSubwayStation :(id)request
{
    // 지하철검색 까지 성공햇으면 모든검색 종료 /// 결과에 따라 처리
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        // 검색결과 카운트 계산
        int countPlace, countAddress, countNewAddress, countPublicBs, countPublicBn, countPublicSs, countPublic, countTotal;
        countPlace =  [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountPlace"] intValue];
        countAddress = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountAddress"] intValue];
        countNewAddress = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountNewAddress"] intValue];
        countPublicBs = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountPublicBusStation"] intValue];
        countPublicBn = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountPublicBusNumber"] intValue];
        countPublicSs = [[oms.searchLocalDictionary objectForKeyGC:@"TotalCountPublicSubwayStation"] intValue];
        countPublic = countPublicBs + countPublicBn + countPublicSs;
        countTotal = countPlace + countAddress + countNewAddress + countPublic;
        
        if([(NSMutableDictionary *)[oms.searchLocalDictionary objectForKeyGC:@"Na_Result"] count] > 1)
        {
        [oms.prevSearchLocalDictionary setObject:[oms.searchLocalDictionary objectForKeyGC:@"Na_Result" ] forKey:@"Na_Result"];
        [oms.prevSearchLocalDictionary setObject:[oms.searchLocalDictionary objectForKeyGC:@"QueryResult" ] forKey:@"QueryResult"];
        [oms.prevSearchLocalDictionary setObject:[oms.searchLocalDictionary objectForKeyGC:@"SearchType"] forKey:@"SearchType"];
        }
        
        
        // 검색결과 한개라도 존재하면 화면 새로 그림
        if (countTotal > 0)
        {
            // 검색결과살려
            // 혹시 모를 중복 검색완료 들어올 경우 대비해서 최상위뷰컨트롤러에 하나의 검색결과뷰만 들어가게ㅐ 처리
            
            if ( ![[[OMNavigationController sharedNavigationController].viewControllers objectAtIndexGC:[OMNavigationController sharedNavigationController].viewControllers.count-1] isKindOfClass:[SearchResultViewController class]])
            {
                SearchResultViewController *srvc = [self.storyboard instantiateViewControllerWithIdentifier:@"SearchResultView"];
                
                [srvc setCurrentSearchTargetType:_currentSearchTargetType];
                [srvc setBaseOption:searchOption];
                
                [srvc setSearchKeyword:oms.keyword];
                
                NSLog(@"topType %d\n", self.resultType);
                NSLog(@"radioType %@", self.order ? @"dist" : @"rank");
                srvc.topType = self.resultType;
                
                
                // 기본검색은 여길 패스하고 검색결과 공유시 장소/주소/교통인지 선택
                // resultType = 1 : 장소
                // resultType = 2 : 주소
                // resultType = 3 : 교통
                
                // 교통일 경우엔 버스정류장, 버스노선, 지하철 카운트를 체크해서 먼저 보여줄 것을 선택(공항화물청사역 검색시엔 지하철 밖에 카운트가 없기 때문에...)
                if(self.resultType == 3)
                {
                    if(countPublicBs > 0)
                        srvc.radioType = 13;
                    else if (countPublicBn > 0)
                        srvc.radioType = 14;
                    else if (countPublicBn > 0)
                        srvc.radioType = 15;
                    else
                        srvc.radioType = 13;
                    
                }
                // order가 true이면 거리순 검색이다
                else if(self.order == YES)
                {
                    srvc.radioType = 12;
                }
                
                //* 서치할때 한번 더 추천검색 (추가됨...키보드있을때 없을때
                DbHelper *dbh = [[DbHelper alloc] init];
                
                
                [dbh getAutomakeKeyword:oms.keyword];
                //[dbh chosungFinal:searchField.text];
                [_recommandTable reloadData];
                
                // * 끝
                [[OMNavigationController sharedNavigationController] pushViewController:srvc animated:NO];
            }
        }
        // 경고메세지 노출
        else
        {
            // 검색결과가 없습니다.
            [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailed", @"")];
            
            if([(NSMutableDictionary *)[oms.searchLocalDictionary objectForKeyGC:@"QueryResult"] count] > 1)
            {
                NSLog(@"옵션보자");
                [self anotherSearchView];
            }
            else
                NSLog(@"서버응답없으니 보지말자");
            
        }
        
    }
    // 검색중 오류 발생했으면 모든 검색 중단,
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) anotherSearchView
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *search1 = [oms poiQueryReturn];
    NSString *search3 = [oms r_QueryReturn];
    NSString *searchType = [[oms.searchLocalDictionary objectForKeyGC:@"SearchType"] objectForKeyGC:@"orgType"];
    NSString *lblText = nil;
    
    
    [_anotherSearchView setHidden:NO];
    [_anotherSearchLabel setNumberOfLines:1];
    [_anotherSearchLabel setBackgroundColor:[UIColor clearColor]];
    [_anotherSearchLabel setTextColor:convertHexToDecimalRGBA(@"19", @"a8", @"c7", 1.0)];
    [_anotherSearchLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [_anotherSearchLabel setTextAlignment:NSTextAlignmentCenter];
    
    NSLog(@"타입보까? %@", [oms.searchLocalDictionary objectForKeyGC:@"SearchType"]);
    //NSLog(@"오엠에스 키워드 : %@", oms.keyword);
    if([searchType isEqualToString:@"H"])
    {
        return;
        
    }
    else if(searchOption == 1 && [oms reSearchException])
    {
        if([searchType isEqualToString:@"A"] || [searchType isEqualToString:@"B"] || [searchType isEqualToString:@"G"])
            
        {
            lblText = [NSString stringWithFormat:@"%@ 근처 장소", oms.keyword];
        }
        else if([searchType isEqualToString:@"C"] || [searchType isEqualToString:@"D"] || [searchType isEqualToString:@"E"])
        {
            lblText = [NSString stringWithFormat:@"%@ 근처 %@", search1, search3];
        }
        
    }
    // 마포갈비처럼 예외로 들어오는 ㅡㅡ
    else if(searchOption == 1 && ![oms reSearchException] && [searchType isEqualToString:@"C"])
    {
        lblText = [NSString stringWithFormat:@"현재위치 근처 %@", self.searchField.text];
    }
    else if(searchOption == 2 && [oms reSearchException] && ([searchType isEqualToString:@"A"] || [searchType isEqualToString:@"B"] || [searchType isEqualToString:@"G"]))
    {
        lblText = [NSString stringWithFormat:@"현재위치 근처 %@", self.searchField.text];
    }
    else if (searchOption == 2 && [oms reSearchException] && ([searchType isEqualToString:@"C"] ||[searchType isEqualToString:@"D"] || [searchType isEqualToString:@"E"]))
    {
        lblText = [NSString stringWithFormat:@"현재위치 근처 %@", self.searchField.text];
    }
    else if(searchOption == 2 && ![oms reSearchException] && ([searchType isEqualToString:@"A"] || [searchType isEqualToString:@"B"] || [searchType isEqualToString:@"G"]))
    {
        lblText = [NSString stringWithFormat:@"현재위치 근처 %@", self.searchField.text];
    }
    else if (searchOption == 2 && ![oms reSearchException] && ([searchType isEqualToString:@"C"] ||[searchType isEqualToString:@"D"] || [searchType isEqualToString:@"E"]))
    {
        lblText = [NSString stringWithFormat:@"%@ 근처 %@", search1, search3];
    }
    else if(searchOption == 3 && [searchType isEqualToString:@"B"])
    {
        lblText = [NSString stringWithFormat:@"지번주소 %@ 근처 장소", search1];
    }
    else if(searchOption == 3 && [searchType isEqualToString:@"D"])
    {
        lblText = [NSString stringWithFormat:@"지번주소 %@ 근처 %@", search1, search3];
    }
    
    [_anotherSearchLabel setText:lblText afterInheritingLabelAttributesAndConfiguringWithBlock: ^(NSMutableAttributedString *mutableAttributedString) {
        NSRange colorRange = [lblText rangeOfString: @"근처" options: NSCaseInsensitiveSearch];
        if (colorRange.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:colorRange];
        }
        
        NSRange colorRange2 = [lblText rangeOfString: @"새주소" options: NSCaseInsensitiveSearch];
        if (colorRange2.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:colorRange2];
        }
        NSRange colorRange3 = [lblText rangeOfString: @"현재위치" options: NSCaseInsensitiveSearch];
        if (colorRange3.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:colorRange3];
        }
        NSRange colorRange4 = [lblText rangeOfString: @"장소" options: NSCaseInsensitiveSearch];
        if (colorRange4.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:colorRange4];
        }
        NSRange colorRange5 = [lblText rangeOfString: @"지번주소" options: NSCaseInsensitiveSearch];
        if (colorRange5.location != NSNotFound) {
            [mutableAttributedString addAttribute:(NSString *) kCTForegroundColorAttributeName value:(id)[[UIColor blackColor] CGColor] range:colorRange5];
        }
        
        
        return mutableAttributedString;
    }];
    
}
#pragma mark -
#pragma mark - 테이블
#pragma mark -
#pragma mark TableViewDataSource Delegate(테이블뷰데이터)

//행의 갯수
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // 최근검색
    if([tableView isKindOfClass:[RecentTableView class]])
    {
        return [[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount];
    }
    // 추천검색
    else
    {
        return [[OllehMapStatus sharedOllehMapStatus] getRecommWordRowCount];
    }
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isKindOfClass:[RecentTableView class]])
    {
        NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
        
        if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
        {
            if( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
            {
                return 78;
            }
            
        }
        return 58;
    }
    else
    {
        return 34;
    }
}

//행을 그림
//indexPath는 row와 section을 프로퍼티로 갖는 셀에대한 포인트 클래스
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"RecentCell";
    static NSString *CellIdentifier2 = @"CustomizeCell";
    
    // 세퍼레이터 설정
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
    // 최근검색일 때는 recentCell
    if([tableView isKindOfClass:[RecentTableView class]])
    {
        recentCell2 *ccell = (recentCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if( ccell == nil )
        {
            NSBundle *nbd = [NSBundle mainBundle];
            NSArray *nib = [nbd loadNibNamed:@"recentCell2" owner:self options:nil];
            for (id oneObject in nib)
            {
                if([oneObject isKindOfClass:[recentCell2 class]])
                    ccell = (recentCell2 *)oneObject;
            }
            
            UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
            [selectedBackgroundView setBackgroundColor:convertHexToDecimalRGBA(@"d9", @"f4", @"ff", 1)];
            ccell.selectedBackgroundView = selectedBackgroundView;
        }
        
        
        NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
        
        int iconType = [[rdic objectForKeyGC:@"ICONTYPE"] intValue];
        
        UIImage *iconImage = nil;
        
        if ( iconType == Favorite_IconType_BusStop )
            iconImage = [UIImage imageNamed:@"list_b_marker_busstop.png"];
        else if ( iconType == Favorite_IconType_CCTV )
            iconImage = [UIImage imageNamed:@"list_b_marker_cctv.png"];
        else if ( iconType == Favorite_IconType_Course )
            iconImage = [UIImage imageNamed:@"list_b_marker_course.png"];
        else if ( iconType == Favorite_IconType_None )
            iconImage = [UIImage imageNamed:@"list_b_marker.png"];
        else if ( iconType == Favorite_IconType_POI )
            iconImage = [UIImage imageNamed:@"list_b_marker_poi.png"];
        else if ( iconType == Favorite_IconType_Subway )
            iconImage = [UIImage imageNamed:@"list_b_marker_subway.png"];
        else
            iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"info_icon_%02d", iconType]];
        
        ccell.poiImage.image = iconImage;
        
        CGRect iconRect = ccell.poiImage.frame;
        
        iconRect.size = iconImage.size;
        iconRect.origin = CGPointMake(9, 12);
        [ccell.poiImage setFrame:iconRect];
        
        // 버스번호일때
        if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"TR_BUSNO"])
        {
            [ccell.poiImage setFrame:CGRectMake(6, 12, 29, 18)];
        }
        
        // 길찾기일때
        if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
        {
            
            
            [ccell.placeName setHidden:YES];
            [ccell.classification setHidden:YES];
            [ccell.startLbl setHidden:NO];
            [ccell.destLbl setHidden:NO];
            [ccell.startContent setHidden:NO];
            [ccell.destContent setHidden:NO];
            
            ccell.startContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"START_NAME"]];
            
            ccell.destContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"STOP_NAME"]];
            
            [ccell.destLbl setFrame:CGRectMake(41, 31, 28, 15)];
            [ccell.destContent setFrame:CGRectMake(78, 32, 192, 13)];
            
            // 경유지 있나 판단
            if( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
            {
                [ccell.visitLbl setHidden:NO];
                [ccell.visitContent setHidden:NO];
                ccell.visitContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"VISIT_NAME"]];
                [ccell.destLbl setFrame:CGRectMake(41, 51, 28, 15)];
                [ccell.destContent setFrame:CGRectMake(78, 52, 192, 13)];
            }
            
        }
        else
        {
            NSString *subName = [rdic objectForKeyGC:@"SUBNAME"];
            NSLog(@"subName : %@", subName);
            
            if(subName == nil)
            {
                ccell.placeName.text = [rdic objectForKeyGC:@"NAME"];
            }
            else
            {
                ccell.placeName.text = [NSString stringWithFormat:@"%@ %@", [rdic objectForKeyGC:@"NAME"], [rdic objectForKeyGC:@"SUBNAME"]];
            }
            
            
            //NSLog(@"rdicc : %@", rdic);
            
            NSString *classify = stringValueOfDictionary(rdic, @"CLASSIFY");
            //[rdic objectForKeyGC:@"CLASSIFY"];
            if([classify isEqualToString:@""])
            {
                [ccell.placeName setFrame:CGRectMake(41, 21, 229, 15)];
                [ccell.classification setHidden:YES];
            }
            else
            {
                ccell.classification.text = classify;
            }
        }
        
        //[ccell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return ccell;
        
    }
    
    // 추천검색일 때는 omCell
    else
    {
        
        NSString *recommWord = [[OllehMapStatus sharedOllehMapStatus] getRecommWord:(int)indexPath.row];
        NSLog(@"진짜 추천검색어 이것 : %@",  recommWord);
        
        OmCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if(cell == nil)
        {
            cell = [[OmCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier2];
            
            UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
            [selectedBackgroundView setBackgroundColor:convertHexToDecimalRGBA(@"d9", @"f4", @"ff", 1)];
            cell.selectedBackgroundView = selectedBackgroundView;
        }
        
        // 색깔 바꿔서 출력
        //[cell setString:[[OllehMapStatus sharedOllehMapStatus].searchAutoMakeArray objectAtIndexGC:indexPath.row] searchString:searchField.text];
        [cell setString:recommWord searchString:_searchField.text];
        
        
        //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        return cell;
    }
    
}


// 셀을 선택
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([tableView isKindOfClass:[RecentTableView class]])
    {
        
        // 최근검색 선택 통계
        [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/recent_POI"];
        NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
        
        // 타입이 버스번호일때
        if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"TR_BUSNO"])
        {
            // 길찾기모드일때 버스번호는 선택할 수 없다
            if(_currentSearchTargetType != SearchTargetType_NONE)
            {
                [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Popup_ClickBusNumber", @"")];
                [_recentTable deselectRowAtIndexPath:indexPath animated:YES];
                return;
            }
            
            // 버스상세로 푸시
            [[ServerConnector sharedServerConnection] requestBusNumberInfo:self action:@selector(didFinishRequestBusNumDetail:) laneId:[rdic objectForKeyGC:@"ID"]];
            
        }
        // 경로일 때?
        else if ([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
        {
            // 길찾기 검색일땐 경고메세지
            if(_currentSearchTargetType != SearchTargetType_NONE)
            {
                [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Popup_ClickRoute", @"")];
                [_recentTable deselectRowAtIndexPath:indexPath animated:YES];
                
                return;
            }
            
            // 길찾기 데이터 채우기
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            
            // 출발지
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            [oms.searchResultRouteStart setIsCurrentLocation:NO];
            [oms.searchResultRouteStart setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"START_NAME"]]];
            [oms.searchResultRouteStart setStrLocationAddress:@""];
            [oms.searchResultRouteStart setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"START_X"] doubleValue] , [[rdic objectForKeyGC:@"START_Y"] doubleValue] ) ];
            // 경유지
            [oms.searchResultRouteVisit reset];
            if ( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
            {
                [oms.searchResultRouteVisit setUsed:YES];
                [oms.searchResultRouteVisit setIsCurrentLocation:NO];
                [oms.searchResultRouteVisit setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"VISIT_NAME"]]];
                [oms.searchResultRouteVisit setStrLocationAddress:@""];
                [oms.searchResultRouteVisit setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"VISIT_X"] doubleValue] , [[rdic objectForKeyGC:@"VISIT_Y"] doubleValue] ) ];
            }
            // 도착지
            [oms.searchResultRouteDest reset];
            [oms.searchResultRouteDest setUsed:YES];
            [oms.searchResultRouteDest setIsCurrentLocation:NO];
            [oms.searchResultRouteDest setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"STOP_NAME"]]];
            [oms.searchResultRouteDest setStrLocationAddress:@""];
            [oms.searchResultRouteDest setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"STOP_X"] doubleValue] , [[rdic objectForKeyGC:@"STOP_Y"] doubleValue] ) ];
            
            // 길찾기 검색전 기존 검색 데이터 클리어
            [[OllehMapStatus sharedOllehMapStatus].searchRouteData reset];
            
            // 길찾기 시도
            [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Car:SearchRoute_Car_SearchType_RealTime];
            
        }
        // 그냥 최근검색일때
        else
        {
            NSString *name = [rdic objectForKeyGC:@"NAME"];
            NSString *add = [rdic objectForKeyGC:@"ADDR"];
            NSNumber *xx = [rdic objectForKeyGC:@"X"];
            NSNumber *yy = [rdic objectForKeyGC:@"Y"];
            NSString *type = [rdic objectForKeyGC:@"TYPE"];
            NSString *detailid = [rdic objectForKeyGC:@"ID"];
            NSString *tel = stringValueOfDictionary(rdic, @"TEL");
            NSString *free = stringValueOfDictionary(rdic, @"FREE");
            //[rdic objectForKeyGC:@"FREE"];
            NSString *subName = stringValueOfDictionary(rdic, @"SUBNAME");
            
            
            NSString *newAddName = stringValueOfDictionary(rdic, @"NEWADDRESS");
            
            NSString *oldOrNew = stringValueOfDictionary(rdic, @"OLDORNEW");
            
            NSString *shapeType = stringValueOfDictionary(rdic, @"SHAPE_TYPE");
            NSString *fcNm = stringValueOfDictionary(rdic, @"FCNM");
            NSString *idBgm = stringValueOfDictionary(rdic, @"ID_BGM");
            NSString *rdcd = stringValueOfDictionary(rdic, @"RD_CD");
            
            double x = [xx doubleValue];
            double y = [yy doubleValue];
            
            [_recentTable deselectRowAtIndexPath:indexPath animated:YES];
            
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            [oms.searchResult reset]; // 검색결과 리셋
            [oms.searchResult setUsed:YES];
            [oms.searchResult setIsCurrentLocation:NO];
            [oms.searchResult setStrLocationName:[NSString stringWithFormat:@"%@%@", name, subName]];
            [oms.searchResult setStrLocationRoadName:rdcd];
            [oms.searchResult setStrShape:shapeType];
            [oms.searchResult setStrShapeFcNm:fcNm];
            [oms.searchResult setStrShapeIdBgm:idBgm];
            
            if([type isEqualToString:@"ADDR"])
            {
                [oms.searchResult setStrLocationAddress:name];
                [oms.searchResult setStrLocationSubAddress:newAddName];
                [oms.searchResult setStrLocationOldOrNew:oldOrNew];
            }
            else
            {
                [oms.searchResult setStrLocationAddress:add];
                [oms.searchResult setStrLocationSubAddress:@""];
                [oms.searchResult setStrLocationOldOrNew:@""];
            }
            
            [oms.searchResult setStrType:type];
            [oms.searchResult setStrID:detailid];
            [oms.searchResult setStrTel:tel];
            [oms.searchResult setCoordLocationPoint:CoordMake(x, y)];
            [oms.searchResult setStrSTheme:free];
            [oms.searchLocalDictionary setObject:free forKey:@"LastExtendFreeCall"];
            
            if (![rdcd isEqualToString:@""] || ![shapeType isEqualToString:@""])
            {
                // 라인POI 검색일땐 경고메세지
                if(_currentSearchTargetType != SearchTargetType_NONE)
                {
                    [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Popup_ClickLinePOI", @"")];
                    [_recentTable deselectRowAtIndexPath:indexPath animated:YES];
                    return;
                }
            }
            if(![rdcd isEqualToString:@""])
            {
                [[ServerConnector sharedServerConnection] requestRoadNameSearch:self action:@selector(SearchFinishedRoadNameInfo:) roadCode:rdcd];
            }
            else if([shapeType isEqualToString:@""] || [fcNm isEqualToString:@""] || [idBgm isEqualToString:@""])
            {
                [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:NO];
            }
            
            else
            {
                [[ServerConnector sharedServerConnection] requestPolygonSearch:self action:@selector(SearchfinishedPolygonInfo:) table:fcNm loadKey:idBgm];
            }
            
        }
        
        
    }
    
    else
    {
        // 추천검색 선택 통계
        [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/recommended_query"];
        NSString *tempText = [[OllehMapStatus sharedOllehMapStatus] getRecommWord:(int)indexPath.row];
        _searchField.text = tempText;
        NSLog(@"onSearch 가자");
        [self onSearch];
        
    }
    
    
}
// 버스번호상세 콜백
- (void)didFinishRequestBusNumDetail:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        _state = 0;
        BusLineViewController *bndvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BusLineView"];
        [[OMNavigationController sharedNavigationController] pushViewController:bndvc animated:NO];
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
- (void) SearchFinishedRoadNameInfo:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        if([(NSMutableDictionary *)[[OllehMapStatus sharedOllehMapStatus].roadNameDictionary objectForKeyGC:@"RoadCode"] count] == 0)
        {
            [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:YES];
        }
        else
        {
            [MainViewController markingRoadCodeSearch];
        }
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    
}
- (void) SearchfinishedPolygonInfo:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        if([(NSMutableDictionary *)[[OllehMapStatus sharedOllehMapStatus].linePolygonDictionary objectForKeyGC:@"LinePolygon"] count] == 0)
        {
            [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:YES];
        }
        else
        {
            [MainViewController markingLinePolygonPOI];
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


#pragma mark -
#pragma mark - 액션
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)xBtnClick:(id)sender
{
    _searchField.text = @"";
    
    _favoriteBtn.hidden = NO;
    _contactBtn.hidden = NO;
    _voiceBtn.hidden = NO;
    _noSearchBackGround.hidden = NO;
    _searchBackGround.hidden = YES;
    _recentTable.hidden = NO;
    _recommandTable.hidden = YES;
    _xBtn.hidden = YES;
    _xClick = NO;
    
    [_anotherSearchView setHidden:YES];
    
}

- (IBAction)favoriteBtnClick:(id)sender
{
    // 즐겨찾기 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/favorite"];
    
    FavoriteViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteView"];
    [[OMNavigationController sharedNavigationController] pushViewController:fvc animated:YES];
    
}

- (IBAction)ContactBtnClick:(id)sender
{
    // 연락처 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/address_book"];
    
    if ( [ContactViewController checkAddressBookAuth] )
    {
        ContactViewController *cvc = [self.storyboard instantiateViewControllerWithIdentifier:@"ContactView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:cvc animated:YES];
    }
    
}

- (IBAction)VoiceSearchBtnClick:(id)sender
{
        //if([self microphoneCheck])
        //{
            //[self pushVoiceSearch];
        //}
    if(OM_IOSVER)
    {
        [self microphoneCheck];
    }
    else
        [self pushVoiceSearch];
        
}
- (void) pushVoiceSearch
{
    // 음성검색 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/voice_search"];
    
    VoiceSearchViewController *vsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"VoiceView"];
    
    // 음성검색 검색대상 설정
    switch (_currentSearchTargetType)
    {
        case SearchTargetType_START:
            [vsvc setCurrentSearchTargetType:SearchTargetType_VOICESTART];
            break;
        case SearchTargetType_VISIT:
            [vsvc setCurrentSearchTargetType:SearchTargetType_VOICEVISIT];
            break;
        case SearchTargetType_DEST:
            [vsvc setCurrentSearchTargetType:SearchTargetType_VOICEDEST];
            break;
        case SearchTargetType_NONE:
        default:
            [vsvc setCurrentSearchTargetType:SearchTargetType_VOICENONE];
            break;
    }
    
    [[OMNavigationController sharedNavigationController] pushViewController:vsvc animated:NO];
}
- (void) microphoneCheck
{
    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted)
        {
            if(granted){
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    @autoreleasepool {
//                        
//                        NSLog(@"권한있슴");
//                [self pushVoiceSearch];
//                    }
//                    });
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"Voice"])
                {
                    [self pushVoiceSearch];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @autoreleasepool {
                            
                        
                        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Voice"];
                            
                            [self pushVoiceSearch];
                            
                        }
                    });
                }  
            }
            else
            {
                if([[NSUserDefaults standardUserDefaults] boolForKey:@"Voice"])
                {
                    [OMMessageBox showAlertMessage:@"" :@"올레 map이 마이크에 접근할 수 있는 권한이 없습니다."];
                }
                else
                {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        @autoreleasepool {
                            
                            
                            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"Voice"];
                            
                            [OMMessageBox showAlertMessage:@"" :@"올레 map이 마이크에 접근할 수 있는 권한이 없습니다."];
                            
                        }
                    });
                }
                
            }
        }];
}
- (IBAction)popBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}
#pragma mark -
#pragma mark 스크롤뷰

// 드래그 할 때 키보드 내림
- (void) scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self.searchField resignFirstResponder];
}

-(void)actionSheet:(UIActionSheet *)actionSheet didDismissWithButtonIndex:(NSInteger)buttonIndex
{
    switch (actionSheet.tag) {
        case 1:
            if(buttonIndex == [actionSheet cancelButtonIndex])
            {
                
            }
            else if ( buttonIndex == 0)
            {
                    if([[OllehMapStatus sharedOllehMapStatus] reSearchException])
                    {
                        willSearchOption = searchOption;
                        searchOption = 1;
                    }
                    else
                    {
                        willSearchOption = searchOption;
                        searchOption = 2;
                    }

                [self onSearch];
                
            }
            else if ( buttonIndex == 1)
            {
                    if([[OllehMapStatus sharedOllehMapStatus] reSearchException])
                    {
                        willSearchOption = searchOption;
                        searchOption = 2;

                    }
                    else
                    {
                        willSearchOption = searchOption;
                        searchOption = 1;

                    }
                    [self onSearch];
                
            }
            
            break;
            
        case 2:
            if(buttonIndex == [actionSheet cancelButtonIndex])
            {
                //NSLog(@"취소 Click..");
            }
            else if ( buttonIndex == 0)
            {
                willSearchOption = searchOption;
                searchOption = 1;
                [self onSearch];
                
            }
            else if ( buttonIndex == 1)
            {
                willSearchOption = searchOption;
                searchOption = 2;
                [self onSearch];
                
            }
            else if ( buttonIndex == 2)
            {
                willSearchOption = searchOption;
                searchOption = 3;
                [self onSearch];
            }
            break;
        default:
            break;
    }
    
}

@end
