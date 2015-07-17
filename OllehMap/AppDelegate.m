//
//  AppDelegate.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "AppDelegate.h"

#import <MapKit/MKDirectionsRequest.h>
//#import "URLParser.h"
#import "NSURL+QueryParser.h"

static NSString *const kAllowTracking = @"allowTracking";

@implementation AppDelegate
- (id) init
{
    self = [super init];
    if ( self )
    {
        _rootViewContoller = nil;
    }
    return self;
}
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
//#ifdef DEBUG
//    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-33033628-1" dispatchPeriod:1 delegate:nil];
//#else
//    [[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-32576408-1" dispatchPeriod:1 delegate:nil];
//#endif
    
    // 네트워크 연결 상태 체크
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"네트워크" :@"네트워크에 접속할수없습니다. 3G 또는 WiFi 상태를 확인바랍니다."];
        
    }
    
    // 슬립모드 방지
    NSString *strIdleTimerDisabled = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKeyGC:@"IdleTimerDisabled"]];
    // NO일경우 슬립모드 유지
    if ([strIdleTimerDisabled isEqualToString:@"NO"])
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
    // NO가 아닐경우 슬립모드 방지
    else
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        // NO 가 아닌데, YES 도 아닌 경우 기본값 YES 설정
        if ([strIdleTimerDisabled isEqualToString:@"YES"] == NO)
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IdleTimerDisabled"];
        }
    }
    
    // 설정 기록 (오류메세지 && 앱실행여부)
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithBool:NO] forKey:@"IsStartup"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    UIStoryboard *story = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
    
    self.rootViewContoller = [story instantiateViewControllerWithIdentifier:@"MainView"];
    self.window.rootViewController = [OMNavigationController setNavigationController:self.rootViewContoller];

    // 특화지도상태
    NSInteger special_up = [[[NSUserDefaults standardUserDefaults] objectForKeyGC:@"private_up"] intValue];
    NSInteger special_down = [[[NSUserDefaults standardUserDefaults] objectForKeyGC:@"private_down"] intValue];
    
    
    if(special_up == Up_None)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:Up_None forKey:@"private_up"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if(special_up == Up_CCTV || special_up == Up_BusStation || special_up == Up_SubWay)
        {
            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:Up_None forKey:@"private_up"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    if(special_down == Down_None)
    {
        [[NSUserDefaults standardUserDefaults] setInteger:Down_None forKey:@"private_down"];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    else
    {
        if(special_down == Down_Cadastral || special_down == Down_Traffic)
        {
            
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setInteger:Down_None forKey:@"private_down"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
    
    //self.window.backgroundColor = [UIColor yellowColor];
    [application setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    // Override point for customization after application launch.
    
    [GAI sharedInstance].trackUncaughtExceptions = YES;
    //[GAI sharedInstance].optOut = YES;
    // Optional: set Google Analytics dispatch interval to e.g. 20 seconds.
    [GAI sharedInstance].dispatchInterval = -1;
    
    // Optional: set Logger to VERBOSE for debug information.
    
#ifdef DEBUG
    //[[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelVerbose];
#else
    [[[GAI sharedInstance] logger] setLogLevel:kGAILogLevelNone];
#endif
    
    // Initialize tracker.
    [[GAI sharedInstance] defaultTracker];
    
    
    [[GAI sharedInstance] trackerWithTrackingId:@"UA-47565237-1"];
    //[[GAI sharedInstance] trackerWithTrackingId:@"UA-32576408-1"];
        //[[GANTracker sharedTracker] startTrackerWithAccountID:@"UA-32576408-1" dispatchPeriod:1 delegate:nil];

    
    
    
    return YES;
}
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    //[GAI sharedInstance].optOut = ![[NSUserDefaults standardUserDefaults] boolForKey:kAllowTracking];
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
// URL 받는다(mmv 등 외부 앱에서)
- (BOOL) application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    // 메인화면 정상로딩될때까지 조금만 기다려주자
    for (int cnt=0, maxcnt=3; cnt < maxcnt; cnt++)
    {
        [NSThread sleepForTimeInterval:1.0];
        if ( _rootViewContoller && _rootViewContoller.isViewLoaded ) break;
    }
    
    // 길찾기 요청이 들어온 경우 처리
    if ( [MKDirectionsRequest isDirectionsRequestURL:url] )
    {
        
        MKDirectionsRequest* directionsInfo = [[MKDirectionsRequest alloc] initWithContentsOfURL:url];
        MKMapItem *source = directionsInfo.source;
        MKMapItem *destination = directionsInfo.destination;
        
        // 메인맵으로 초기화
        [[OMNavigationController sharedNavigationController] popToRootViewControllerAnimated:NO];
        
        [self openURLRoute:source:destination];
        
        return YES;
    }
    else if ([FBSession.activeSession handleOpenURL:url])
    {
        return YES;
    }
    // 페북추가
    // 올레맵 진짜아디  170614009631423 // substringToIndex 갯수 주의 17자린지 18자린지
    else if([[[url absoluteString] substringToIndex:18] caseInsensitiveCompare:[NSString stringWithFormat:@"fb%@", facebooksId]] == NSOrderedSame)
    {
        return [FBSession.activeSession handleOpenURL:url];
    }

    // 기타 요청 처리(위치공유 접근)
    else
    {
        
        [self openURLShare:url];
        
    }
    
    return YES;
}
- (BOOL) openURLRoute:(MKMapItem *)source :(MKMapItem *)destination
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    // 길찾기 결과도 미리 초기화
    [oms.searchRouteData reset];
    
    // 출발지 설정
    NSString *sourceAddress = [NSString stringWithFormat:@"%@ %@ %@"
                               , stringValueOfDictionary(source.placemark.addressDictionary, @"State")
                               , stringValueOfDictionary(source.placemark.addressDictionary, @"SubLocality")
                               , stringValueOfDictionary(source.placemark.addressDictionary, @"Street")
                               ];
    
    [oms.searchResultRouteStart reset];
    [oms.searchResultRouteStart setUsed:YES];
    if ( source.isCurrentLocation)
    {
        [oms.searchResultRouteStart setIsCurrentLocation:YES];
        [oms.searchResultRouteStart setStrLocationName:@"현재 위치"];
        [oms.searchResultRouteStart setCoordLocationPoint:CoordMake(0, 0)];
    }
    // 현재위치 아니면서, 주소가 없을 경우
    else if ( [sourceAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0 )
    {
        Coord startCoordinateWgs84 = CoordMake(source.placemark.coordinate.longitude, source.placemark.coordinate.latitude);
        Coord startCoordinateUtmk = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:startCoordinateWgs84 inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
        
        [oms.searchResultRouteStart setIsCurrentLocation:NO];
        [oms.searchResultRouteStart setStrLocationName:@""];
        [oms.searchResultRouteStart setCoordLocationPoint:startCoordinateUtmk];
    }
    else
    {
        Coord startCoordinateWgs84 = CoordMake(source.placemark.coordinate.longitude, source.placemark.coordinate.latitude);
        Coord startCoordinateUtmk = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:startCoordinateWgs84 inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
        
        [oms.searchResultRouteStart setIsCurrentLocation:NO];
        [oms.searchResultRouteStart setStrLocationName:sourceAddress];
        [oms.searchResultRouteStart setCoordLocationPoint:startCoordinateUtmk];
    }
    
    
    // 경유지 초기화
    [oms.searchResultRouteVisit reset];
    
    // 도착지 초기화
    NSString *destinationAddress = [NSString stringWithFormat:@"%@ %@ %@"
                                    , stringValueOfDictionary(destination.placemark.addressDictionary, @"State")
                                    , stringValueOfDictionary(destination.placemark.addressDictionary, @"SubLocality")
                                    , stringValueOfDictionary(destination.placemark.addressDictionary, @"Street")
                                    ];
    
    [oms.searchResultRouteDest reset];
    [oms.searchResultRouteDest setUsed:YES];
    if (destination.isCurrentLocation)
    {
        [oms.searchResultRouteDest setIsCurrentLocation:YES];
        [oms.searchResultRouteDest setStrLocationName:@"현재 위치"];
        [oms.searchResultRouteDest setCoordLocationPoint:CoordMake(0, 0)];
    }
    // 현재위치 아니면서, 주소가 없을 경우
    else if ( [destinationAddress stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]].length <= 0 )
    {
        Coord destCoordinateWgs84 = CoordMake(destination.placemark.coordinate.longitude, destination.placemark.coordinate.latitude);
        Coord destCoordinateUtmk = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:destCoordinateWgs84 inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
        
        [oms.searchResultRouteDest setIsCurrentLocation:NO];
        [oms.searchResultRouteDest setStrLocationName:@""];
        [oms.searchResultRouteDest setCoordLocationPoint:destCoordinateUtmk];
    }
    else
    {
        Coord destCoordinateWgs84 = CoordMake(destination.placemark.coordinate.longitude, destination.placemark.coordinate.latitude);
        Coord destCoordinateUtmk = [[MapContainer sharedMapContainer_Main].kmap convertCoordinate:destCoordinateWgs84 inCoordType:KCoordType_WGS84 outCoordType:KCoordType_UTMK];
        
        [oms.searchResultRouteDest setIsCurrentLocation:NO];
        [oms.searchResultRouteDest setStrLocationName:destinationAddress];
        [oms.searchResultRouteDest setCoordLocationPoint:destCoordinateUtmk];
    }
    
    // 길찾기 활성화
    [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
    [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Public:0 pubicSearchIndex:0];
    
    return YES;
}

- (void) openURLShare:(NSURL *)url
{
    NSLog(@"유알엘 = %@", url);
    
    NSDictionary *urlQueryParam = [url queryDictionary];
    
    
    //URLParser *parser = [[URLParser alloc] initWithURLString:url.absoluteString];
    
    @try
    {
        
        NSString *srcApp = [urlQueryParam objectForKeyGC:@"srcApp"]; //[parser valueForVariable:@"srcApp"];
        
        NSString *ptype = [urlQueryParam objectForKeyGC:@"ptype"]; // [parser valueForVariable:@"ptype"];

        // 필수항목 첫번재 // openUrl 타입을 체크한다.
        
        // 공유 url 검색결과
        if (ptype && [ptype isEqualToString:@"m_search"])
        {
            
            OMNavigationController *nav = [OMNavigationController sharedNavigationController];
            
            // 일단 무조건 모든작업 클리어
            if ( nav.viewControllers.count > 1 )
                [nav popToRootViewControllerAnimated:NO];
            [[ThemeCommon sharedThemeCommon] clearThemeSearchResult];
            [[MapContainer sharedMapContainer_Main].kmap removeAllOverlaysWithoutTraffic];
            [[SearchRouteDialogViewController sharedSearchRouteDialog] closeSearchRouteDialog];
            
            
            NSString *query = [urlQueryParam objectForKeyGC:@"query"]; // [parser valueForVariable:@"query"];
            NSString *searchType = [urlQueryParam objectForKeyGC:@"searchtype"]; // [parser valueForVariable:@"searchtype"];
            NSString *order = [urlQueryParam objectForKeyGC:@"order"]; // [parser valueForVariable:@"order"];
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            SearchViewController *svc = [board instantiateViewControllerWithIdentifier:@"SearchView"];
            
            // 정확도순 검색일땐 order값이 false
            // 거리순 검색일 경우엔 order 값을 true로 준다
            if([order.uppercaseString isEqualToString:@"DIS"])
                svc.order = YES;
            
            // 검색결과에서 장소/주소/교통 먼저 보여주기(장소 : 1, 주소 : 2, 교통: 3)
            if([searchType.uppercaseString isEqualToString:@"PLACE"])
                svc.resultType = 1;
            else if ([searchType.uppercaseString isEqualToString:@"ADDRESS"])
                svc.resultType = 2;
            else if ([searchType.uppercaseString isEqualToString:@"TRAFFIC"])
                svc.resultType = 3;
            
            [OllehMapStatus sharedOllehMapStatus].keyword = [query stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            [svc onSearch];
            
        }
        // 공유 url 지도
        else if (ptype && [ptype isEqualToString:@"m_map"])
        {
            float x = [[urlQueryParam objectForKeyGC:@"x"] floatValue]; // [[parser valueForVariable:@"x"] floatValue];
            float y = [[urlQueryParam objectForKeyGC:@"y"] floatValue]; // [[parser valueForVariable:@"y"] floatValue];
            Coord coordinate = CoordMake(x, y);
            
            NSString *poiId = [urlQueryParam objectForKeyGC:@"pid"]; // [parser valueForVariable:@"pid"];
            
            NSString *poiName = [urlQueryParam objectForKeyGC:@"name"]; // [parser valueForVariable:@"name"];
            
            NSString *poiAddr = [urlQueryParam objectForKeyGC:@"addr"];
            
            if(poiAddr == nil)
                poiAddr = @"";
            else
                poiAddr = [poiAddr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            if (poiName == nil)
                poiName = @"";
            else
                poiName = [poiName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *mapType = [urlQueryParam objectForKeyGC:@"maptype"]; // [parser valueForVariable:@"maptype"];
            
            // addr은 필요없음
            // tel도 필요없음
            
            if ( poiId == nil ) poiId = @"";
            NSString *poiType = [urlQueryParam objectForKeyGC:@"detailtype"]; // [parser valueForVariable:@"detailtype"];
            
            if ( poiType == nil ) poiType = @"";
            
            int type = [poiType intValue];
            
            switch (type) {
                    
                case 1:
                    poiType = @"TR_BUS";
                    break;
                case 2:
                    poiType = @"TR";
                    break;
                case 3:
                    poiType = @"CCTV";
                    break;
                case 4:
                    poiType = @"ADDR";
                    break;
                default:
                    poiType = @"MP";
                    break;
            }
            
            
            NSString *level = [urlQueryParam objectForKeyGC:@"zoom"]; // [parser valueForVariable:@"zoom"];
            if ( level == nil ) level = @"9"; // 기본값 9 사용
            
            // 필수값 체크
            //if ( x <= 0 || y <= 0 || !poiName || poiName.length <= 0 )
            if (( x <= 0 || y <= 0) && type != 3)
                [NSException raise:@"Ollehmap OpenURL InvalidParameter" format:@""];
            
            
            // 인디케이터 비활성화
            //[[OMIndicator sharedIndicator] forceStopAnimation];
            
            MapContainer *mc = [MapContainer sharedMapContainer_Main];
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            OMNavigationController *nav = [OMNavigationController sharedNavigationController];
            
            // POI 정보 입력
            OMSearchResult *searchResult =[OllehMapStatus sharedOllehMapStatus].searchResultOneTouchPOI ;
            [searchResult reset];
            [searchResult setUsed:YES];
            [searchResult setCoordLocationPoint:coordinate];
            [searchResult setStrType:poiType];
            
            // 추가끝
            [searchResult setStrID:poiId];
            
            if(type == 4)
            {
                [searchResult setStrLocationName:poiAddr];
            }
            else
                [searchResult setStrLocationName:poiName];
            
            //MainMapViewController *mmvc = (MainMapViewController*)[[OMNavigationController sharedNavigationController].viewControllers objectAtIndexGC:0];
            MainViewController *mmvc = _rootViewContoller;
            
            // 일단 무조건 모든작업 클리어
            if ( nav.viewControllers.count > 1 )
                [nav popToRootViewControllerAnimated:NO];
            [[ThemeCommon sharedThemeCommon] clearThemeSearchResult];
            [mc.kmap removeAllOverlaysWithoutTraffic];
            [[SearchRouteDialogViewController sharedSearchRouteDialog] closeSearchRouteDialog];
            
            
            // 지도설정 타입 설정
            if ( mapType == nil ) mapType  = @"";
            if ( [mapType.uppercaseString isEqualToString:@"AIR"] || [mapType.uppercaseString isEqualToString:@"HYBRID"] )
                [mmvc toggleKMapStyle:KMapTypeHybrid];
            else
                [mmvc toggleKMapStyle:KMapTypeStandard];
            
            // 내위치 비활성화
            oms.calledOpenURL = YES;
            [mmvc toggleMyLocationMode:MapLocationMode_None];
            
            
            if(type == 3)
            {
                [[ServerConnector sharedServerConnection] requestTrafficOptionCCTVInfo:self action:@selector(finishTrafficOptionCCTVInfo:) cctvid:poiId cctvCoordinate:CoordMake(0, 0)];
            }
            else
            {
                // OneTouchPOI 로 렌더링하기 **최소한 POI명이 존재해야 POI렌더링한다.
                if ( poiName.length > 0 )
                    [mmvc pinLongtapPOIOverlay:YES];
                
                [mc.kmap setCenterCoordinate:coordinate];
            }
            
            
            // 지도 줌레벨 설정
            [NSThread sleepForTimeInterval:0.5];
            [mc.kmap setAdjustZoomLevel:(int)[level integerValue]];
            
            
        }
        // 공유url 상세
        else if (ptype && [ptype isEqualToString:@"m_detail"])
        {
            
            OMNavigationController *nav = [OMNavigationController sharedNavigationController];
            
            // 일단 무조건 모든작업 클리어
            if ( nav.viewControllers.count > 1 )
                [nav popToRootViewControllerAnimated:NO];
            [[ThemeCommon sharedThemeCommon] clearThemeSearchResult];
            [[MapContainer sharedMapContainer_Main].kmap removeAllOverlaysWithoutTraffic];
            [[SearchRouteDialogViewController sharedSearchRouteDialog] closeSearchRouteDialog];
            
            NSString *detailType = [urlQueryParam objectForKeyGC:@"detailtype"]; // [parser valueForVariable:@"detailtype"];
            NSString *poiId = [urlQueryParam objectForKeyGC:@"pid"]; // [parser valueForVariable:@"pid"];
            NSString *stid = [urlQueryParam objectForKeyGC:@"stid"]; // [parser valueForVariable:@"stid"];
            
            NSString *addr = [urlQueryParam objectForKeyGC:@"addr"]; // [parser valueForVariable:@"addr"];
            NSString *cctvId = [urlQueryParam objectForKeyGC:@"cctv"]; // [parser valueForVariable:@"cctv"];
            NSString *decodeAddr = [addr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            //NSString *info = [NSString stringWithFormat:@"id : %@, type : %@, stid : %@", poiId, detailType, stid];
            //[OMMessageBox showAlertMessage:@"상세정보" :info];
            
            int type = [detailType intValue];
            
            switch (type) {
                case 1:
                    [[ServerConnector sharedServerConnection] requestBusStationInfoStid:self action:@selector(finishRequestBusDetail:) stId:stid];
                    break;
                case 2:
                    [[ServerConnector sharedServerConnection] requestSubStation:self action:@selector(finishRequestSubwayDetail:) stationId:stid];
                    
                    break;
                case 3:
                    [[ServerConnector sharedServerConnection] requestTrafficOptionCCTVInfo:self action:@selector(finishTrafficOptionCCTVInfo:) cctvid:cctvId cctvCoordinate:CoordMake(0, 0)];
                    break;
                case 4:
                {
                    UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                    
                    AddressPOIViewController *apc = [board instantiateViewControllerWithIdentifier:@"AddressPOIView"];
                    apc.poiZibunAddress = decodeAddr;
                    
                    // 좌표를 0을 주면 지도버튼 disable
                    apc.poiCrd = CoordMake(0, 0);
                    apc.poiRoadAddress = @"";
                    apc.oldOrNew = @"Old";
                    apc.rdCd = @"";
                    [[OMNavigationController sharedNavigationController] pushViewController:apc animated:NO];
                    
                }
                    break;
                default:
                    [[ServerConnector sharedServerConnection] requestPoiDetailAtPoiId:self action:@selector(finishRequestPOIDetail:) poiId:poiId];
                    break;
            }
        }
        else if ([srcApp isEqualToString:@"0"])
        {
            // 인디케이터 활성화
            //[[OMIndicator sharedIndicator] startAnimating];
            //[[OMToast sharedToast] showToastMessagePopup:@"데이터를 분석중입니다." superView:self.window maxBottomPoint:self.window.frame.size.height/2 autoClose:YES];
            
            // type.0 좌표, POI명, POI타입 모든 정보를 입력받아서 렌더링한다.
            // MP1210011453884 / 946392 1943191
            // KTolleh00047://?srcapp=0&NAME=MikSystem&ptype=MP&pid=MP1210011453884&x=946392&y=1943191&id=0&level=9&maptype=
            
            float x = [[urlQueryParam objectForKeyGC:@"X"] floatValue]; // [[parser valueForVariable:@"X"] floatValue];
            float y = [[urlQueryParam objectForKeyGC:@"Y"] floatValue]; // [[parser valueForVariable:@"Y"] floatValue];
            Coord coordinate = CoordMake(x, y);
            NSString *poiName = [urlQueryParam objectForKeyGC:@"Name"]; // [parser valueForVariable:@"Name"];
            if (poiName == nil) poiName = @"";
            else poiName = [poiName stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            NSString *poiId = [urlQueryParam objectForKeyGC:@"ID"]; // [parser valueForVariable:@"ID"];
            if ( poiId == nil ) poiId = @"";
            NSString *poiType = [[urlQueryParam objectForKeyGC:@"Ptype"] uppercaseString]; // [[parser valueForVariable:@"Ptype"] uppercaseString];
            if ( poiType == nil ) poiType = @"";
            NSString *poiDocId = [urlQueryParam objectForKeyGC:@"Pid"]; // [parser valueForVariable:@"Pid"];
            if ( poiDocId == nil ) poiDocId = @"";
            NSString *mapType = [urlQueryParam objectForKeyGC:@"Maptype"]; // [parser valueForVariable:@"Maptype"];
            if ( mapType == nil ) mapType = @"";
            NSString *level = [urlQueryParam objectForKeyGC:@"Level"]; //[parser valueForVariable:@"Level"];
            if ( level == nil ) level = @"9"; // 기본값 9 사용
            
            // 필수값 체크
            //if ( x <= 0 || y <= 0 || !poiName || poiName.length <= 0 )
            if ( x <= 0 || y <= 0 )
                [NSException raise:@"Ollehmap OpenURL InvalidParameter" format:@""];
            
            MapContainer *mc = [MapContainer sharedMapContainer_Main];
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            OMNavigationController *nav = [OMNavigationController sharedNavigationController];
            
            // POI 정보 입력
            OMSearchResult *searchResult =[OllehMapStatus sharedOllehMapStatus].searchResultOneTouchPOI ;
            [searchResult reset];
            [searchResult setUsed:YES];
            [searchResult setCoordLocationPoint:coordinate];
            [searchResult setStrType:poiType];
            // 영화관(MV), 주유소(OL) 일경우 ID대신 DocID  사용
            //                if ( [poiType isEqualToString:@"MV"] || [poiType isEqualToString:@"OL"] )
            //                    [searchResult setStrID:poiDocId];
            //                else
            //                    [searchResult setStrID:poiId];
            // 20130227 docid없을때는 id가 docid 추가
            if([poiDocId isEqualToString:@""] || poiDocId == nil)
            {
                poiDocId = poiId;
            }
            // 추가끝
            [searchResult setStrID:poiDocId];
            
            [searchResult setStrLocationName:poiName];
            
            //MainMapViewController *mmvc = (MainMapViewController*)[[OMNavigationController sharedNavigationController].viewControllers objectAtIndexGC:0];
            MainViewController *mmvc = _rootViewContoller;
            
            // 일단 무조건 모든작업 클리어
            if ( nav.viewControllers.count > 1 )
                [nav popToRootViewControllerAnimated:NO];
            [[ThemeCommon sharedThemeCommon] clearThemeSearchResult];
            [mc.kmap removeAllOverlaysWithoutTraffic];
            
            // 20140306
            // 딜리게이트 닐때문에 위치공유 롱탭에서 원터치로 오버레이 안지워짐 고로 주석
            // 하지만 찝찝하기 때문에 일단 주석해제
            [mc.kmap setDelegate:nil];
            [mc.kmap selectPOIOverlay:nil];
            
            [[SearchRouteDialogViewController sharedSearchRouteDialog] closeSearchRouteDialog];
            
            // 지도설정 타입 설정
            if ( mapType == nil ) mapType  = @"";
            if ( [mapType.uppercaseString isEqualToString:@"AIR"] )
                [mmvc toggleKMapStyle:KMapTypeHybrid];
            else
                [mmvc toggleKMapStyle:KMapTypeStandard];
            
            // 내위치 비활성화
            oms.calledOpenURL = YES;
            [mmvc toggleMyLocationMode:MapLocationMode_None];
            [mc.kmap setCenterCoordinate:coordinate];
            
            // OneTouchPOI 로 렌더링하기 **최소한 POI명이 존재해야 POI렌더링한다.
            if ( poiName.length > 0 )
                [mmvc pinLongtapPOIOverlay:YES];
            
            // 지도 줌레벨 설정
            [NSThread sleepForTimeInterval:0.5];
            [mc.kmap setAdjustZoomLevel:(int)[level integerValue]];
            
        }
        else if (ptype && ([ptype isEqualToString:@"m_route"] || [ptype isEqualToString:@"m_route_car"]))
        {
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            
            // 길찾기 결과도 미리 초기화
            [oms.searchRouteData reset];
            
            // 출발지 설정
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            float startX = [[urlQueryParam objectForKeyGC:@"sx"] floatValue]; // [[parser valueForVariable:@"sx"] floatValue];
            float startY = [[urlQueryParam objectForKeyGC:@"sy"] floatValue]; // [[parser valueForVariable:@"sy"] floatValue];
            
            float destX = [[urlQueryParam objectForKeyGC:@"gx"] floatValue]; // [[parser valueForVariable:@"gx"] floatValue];
            float destY = [[urlQueryParam objectForKeyGC:@"gy"] floatValue]; // [[parser valueForVariable:@"gy"] floatValue];
            
            float visitX = [[urlQueryParam objectForKeyGC:@"vx"] floatValue]; // [[parser valueForVariable:@"vx"] floatValue];
            float visitY = [[urlQueryParam objectForKeyGC:@"vy"] floatValue]; // [[parser valueForVariable:@"vy"] floatValue];
            
            NSString *startName = [[urlQueryParam objectForKeyGC:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *destName = [[urlQueryParam objectForKeyGC:@"gnm"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"gnm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *visitName = [[urlQueryParam objectForKeyGC:@"vnm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"vnm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 출발지 초기화
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            Coord startCoordnate = CoordMake(startX, startY);
            [oms.searchResultRouteStart setIsCurrentLocation:NO];
            [oms.searchResultRouteStart setStrLocationName:startName];
            [oms.searchResultRouteStart setCoordLocationPoint:startCoordnate];
            
            
            // 경유지 초기화
            [oms.searchResultRouteVisit reset];
            
            if(visitName == nil)
            {
                [oms.searchResultRouteVisit setUsed:NO];
            }
            else
            {
                [oms.searchResultRouteVisit setUsed:YES];
                
                Coord visitCoordnate = CoordMake(visitX, visitY);
                [oms.searchResultRouteVisit setIsCurrentLocation:NO];
                [oms.searchResultRouteVisit setStrLocationName:visitName];
                [oms.searchResultRouteVisit setCoordLocationPoint:visitCoordnate];
            }

            
            [oms.searchResultRouteDest reset];
            [oms.searchResultRouteDest setUsed:YES];
            
            Coord destCoordinate = CoordMake(destX, destY);
            [oms.searchResultRouteDest setIsCurrentLocation:NO];
            [oms.searchResultRouteDest setStrLocationName:destName];
            [oms.searchResultRouteDest setCoordLocationPoint:destCoordinate];
            
            
            NSString *priority = [urlQueryParam objectForKeyGC:@"priority"]; // [parser valueForVariable:@"priority"];
            
            int optionType = 0;
            
            if([priority isEqualToString:@"shortest"])
            {
                optionType = SearchRoute_Car_SearchType_ShortDistance;
            }
            else if([priority isEqualToString:@"free"])
            {
                optionType = SearchRoute_Car_SearchType_FreePass;
            }
            else if ([priority isEqualToString:@"express"])
            {
                optionType = SearchRoute_Car_SearchType_HighWay;
            }
            else
            {
                optionType = SearchRoute_Car_SearchType_RealTime;
            }
            
            
            // 길찾기 활성화
            [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];

            [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Car:optionType];
            
                //[[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Public];
        }
        else if (ptype && ([ptype isEqualToString:@"m_route_pub_list"]))
        {
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            
            // 길찾기 결과도 미리 초기화
            [oms.searchRouteData reset];
            
            // 출발지 설정
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            float startX = [[urlQueryParam objectForKeyGC:@"sx"] floatValue]; // [[parser valueForVariable:@"sx"] floatValue];
            float startY = [[urlQueryParam objectForKeyGC:@"sy"] floatValue]; // [[parser valueForVariable:@"sy"] floatValue];
            
            float destX = [[urlQueryParam objectForKeyGC:@"gx"] floatValue]; // [[parser valueForVariable:@"gx"] floatValue];
            float destY = [[urlQueryParam objectForKeyGC:@"gy"] floatValue]; // [[parser valueForVariable:@"gy"] floatValue];

            NSString *startName = [[urlQueryParam objectForKeyGC:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *destName = [[urlQueryParam objectForKeyGC:@"gnm"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"gnm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

            // 출발지
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            Coord startCoordnate = CoordMake(startX, startY);
            [oms.searchResultRouteStart setIsCurrentLocation:NO];
            [oms.searchResultRouteStart setStrLocationName:startName];
            [oms.searchResultRouteStart setCoordLocationPoint:startCoordnate];
            
            
            // 경유지
            [oms.searchResultRouteVisit reset];
            
            
            // 도착지
            [oms.searchResultRouteDest reset];
            [oms.searchResultRouteDest setUsed:YES];
            
            Coord destCoordinate = CoordMake(destX, destY);
            [oms.searchResultRouteDest setIsCurrentLocation:NO];
            [oms.searchResultRouteDest setStrLocationName:destName];
            [oms.searchResultRouteDest setCoordLocationPoint:destCoordinate];
            
            
            NSString *priority = [urlQueryParam objectForKeyGC:@"priority"];
            
            int optionType = 0;
            
            if([priority isEqualToString:@"bus"])
            {
                optionType = 1;
            }
            else if([priority isEqualToString:@"subway"])
            {
                optionType = 2;
            }
            else if ([priority isEqualToString:@"complex"])
            {
                optionType = 3;
            }
            else if([priority isEqualToString:@"recommand"])
            {
                optionType = 0;
            }
            
            
            // 길찾기 활성화
            [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];

            [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Public:optionType pubicSearchIndex:0];
        }
        else if (ptype && [ptype isEqualToString:@"m_route_pub_result"])
        {
            OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
            
            // 길찾기 결과도 미리 초기화
            [oms.searchRouteData reset];
            
            // 출발지 설정
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            float startX = [[urlQueryParam objectForKeyGC:@"sx"] floatValue]; // [[parser valueForVariable:@"sx"] floatValue];
            float startY = [[urlQueryParam objectForKeyGC:@"sy"] floatValue]; // [[parser valueForVariable:@"sy"] floatValue];
            
            float destX = [[urlQueryParam objectForKeyGC:@"gx"] floatValue]; // [[parser valueForVariable:@"gx"] floatValue];
            float destY = [[urlQueryParam objectForKeyGC:@"gy"] floatValue]; // [[parser valueForVariable:@"gy"] floatValue];
            
            NSString *startName = [[urlQueryParam objectForKeyGC:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"snm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            NSString *destName = [[urlQueryParam objectForKeyGC:@"gnm"]stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding]; // [[parser valueForVariable:@"gnm"] stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
            
            // 출발지
            [oms.searchResultRouteStart reset];
            [oms.searchResultRouteStart setUsed:YES];
            
            Coord startCoordnate = CoordMake(startX, startY);
            [oms.searchResultRouteStart setIsCurrentLocation:NO];
            [oms.searchResultRouteStart setStrLocationName:startName];
            [oms.searchResultRouteStart setCoordLocationPoint:startCoordnate];
            
            
            // 경유지
            [oms.searchResultRouteVisit reset];
            
            
            // 도착지
            [oms.searchResultRouteDest reset];
            [oms.searchResultRouteDest setUsed:YES];
            
            Coord destCoordinate = CoordMake(destX, destY);
            [oms.searchResultRouteDest setIsCurrentLocation:NO];
            [oms.searchResultRouteDest setStrLocationName:destName];
            [oms.searchResultRouteDest setCoordLocationPoint:destCoordinate];
            
            
            NSString *priority = [urlQueryParam objectForKeyGC:@"priority"]; // [parser valueForVariable:@"priority"];
            
            int optionType = 0;
            
            if([priority isEqualToString:@"bus"])
            {
                optionType = 1;
            }
            else if([priority isEqualToString:@"subway"])
            {
                optionType = 2;
            }
            else if ([priority isEqualToString:@"complex"])
            {
                optionType = 3;
            }
            else if([priority isEqualToString:@"recommand"])
            {
                optionType = 0;
            }
            
            int index = [[urlQueryParam objectForKeyGC:@"num"] intValue]; //[[parser valueForVariable:@"num"] intValue];
            
            // 길찾기 활성화
            [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
            
            [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Public:optionType pubicSearchIndex:index];
        }
        
        
        
    }
    @catch (NSException *exception)
    {
        [OMMessageBox showAlertMessage:@"" :@"올레 map을 잘못된 방식으로 호출하고 있어 작업을 진행할 수 없습니다." ];
        //[[OMIndicator sharedIndicator] forceStopAnimation];
    }
    @finally
    {
        
    }
    
}
- (void) finishTrafficOptionCCTVInfo :(ServerRequester*)request
{
    if ( [request finishCode] == OMSRFinishCode_Completed )
    {
        NSDictionary *cctvInfo = (NSDictionary*)[request userObject];
        
        NSLog(@"cctvInfo : %@", cctvInfo);
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        
        CCTVViewController *cctvVC = [board instantiateViewControllerWithIdentifier:@"CCTVView"];
        [[OMNavigationController sharedNavigationController] pushViewController:cctvVC animated:NO];
        [cctvVC showCCTV:cctvInfo];
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    // 오류발생했을 경우 경고메세지
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}

// 일반상세
-(void)finishRequestPOIDetail:(id)request
{
    
    if ([request finishCode] == OMSRFinishCode_Completed)
    {
        
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        if([oms.poiDetailDictionary count] <= 0)
        {
            [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_POI_DetailView_NothingInfo", @"")];
        }
        else
        {
            // POI상세 선택 통계
            [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail"];
            
            NSString *type = [oms.poiDetailDictionary objectForKeyGC:@"ORG_DB_TYPE"];
            
            if([type isEqualToString:@"OL"])
            {
                // POI상세 선택 통계
                [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail"];
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                OilPOIDetailViewController *opdvc = [board instantiateViewControllerWithIdentifier:@"OilPOIDetailView"];
                
                [[OMNavigationController sharedNavigationController] pushViewController:opdvc animated:NO];
            }
            else if ([type isEqualToString:@"MV"])
            {
                // POI상세 선택 통계
                [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail"];
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                MoviePOIDetailViewController *mpdvc = [board instantiateViewControllerWithIdentifier:@"MoviePOIDetailView"];
                // ver3테스트3번버그(일반상세API에는 상세이름까지 없다...결과에서넘겨줘야됨 ㅡㅡ)
                NSString *name = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
                
                [mpdvc setThemeToDetailName:name];
                
                [[OMNavigationController sharedNavigationController] pushViewController:mpdvc animated:NO];
            }
            else
            {
                
                UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
                
                GeneralPOIDetailViewController *gpdvc = [board instantiateViewControllerWithIdentifier:@"GeneralPOIDetailView"];
                
                // ver3테스트3번버그(일반상세API에는 상세이름까지 없다...결과에서넘겨줘야됨 ㅡㅡ)
                NSString *name = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
                
                [gpdvc setThemeToDetailName:name];
                
                [[OMNavigationController sharedNavigationController] pushViewController:gpdvc animated:NO];
            }
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
// 버스정류장상세 UI콜백
- (void) finishRequestBusDetail:(id)request
{
    
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        
        UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
        // POI상세 선택 통계
        [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail"];
        
        BusStationPOIDetailViewController *bspdvc = [board instantiateViewControllerWithIdentifier:@"BusStationPOIDetailView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:bspdvc animated:NO];
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
// 지하철상세 UI콜백
-(void)finishRequestSubwayDetail:(id)request
{
    
    if ([request finishCode] == OMSRFinishCode_Completed)
    {
        
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        if([oms.subwayDetailDictionary count] <= 0)
        {
            [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_POI_DetailView_NothingInfo", @"")];
        }
        else
        {
            
            UIStoryboard *board = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle:nil];
            // POI상세 선택 통계
            [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/POI_detail"];
            
            SubwayPOIDetailViewController *spdvc = [board instantiateViewControllerWithIdentifier:@"SubwayPOIDetailView"];
            
            
            [[OMNavigationController sharedNavigationController] pushViewController:spdvc animated:NO];
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

@end
