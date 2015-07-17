//
//  ViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommonMapViewController.h"
#import "mapContainer.h"
#import "OllehMapStatus.h"
#import "ServerConnector.h"

// 임시참조
#import "OMOverlay.h"
#import "SearchViewController.h"
#import "OMNavigationController.h"
#import "ThemeViewController.h"
#import "SettingViewController.h"
#import "CCTVViewController.h"
#import "SearchRouteDialogViewController.h"
#import "LegendViewController.h"
#import "OMMessageBox.h"

// 사각형 안에 좌표가 있는지 확인? 왼쪽X,Y 오른쪽X,Y, 값X,Y
#define SquareIn(leftX, leftY, rightX, rightY, valueX, valueY) (leftX <= returnCrd.x && returnCrd.x <= rightX && leftY <= returnCrd.y && returnCrd.y <= rightY)


typedef struct
{
    double x;
    double y;
} Ppoint;
typedef struct
{
    Ppoint x1;
    Ppoint y1;
} Lline;

@interface MainViewController : CommonMapViewController<UIApplicationDelegate
,KMapViewDelegate, OverlayDelegate
,UIScrollViewDelegate
,UIWebViewDelegate
,UIGestureRecognizerDelegate, UIAlertViewDelegate>
{
    
    // 현재 뷰컨트롤러의 지도렌더링 타입
    int _nMapRenderType;
    // 지도렌더링 타입이 SinglePOI 일때 세부 타입
    int _nMapRenderSinglePOICategory;
    
    UIView *_kmapView;
    
    UIView *_vwNavigationbar;
    UIButton *_eraseBtn;
    
    UIControl *_vwSearchGroup;
    UILabel *_lblSearchKeyword;
    
    UIView *_vwMyLocationButtonGroup;
    UIButton *_btnMyLocation;
    
    UIView *_vwTrafficGroup;
    
    UIView *_vwSideButtonGroup;
    UIButton *_btnSideTraffic;
    UIButton *_btnSideKMapType;
    
    UIView *_vwCurrentAddressGroup;
    UILabel *_lblCurrentAddress;
    
    UIView *_vwBottomButtonGroup;
    UIButton *_btnBottomTheme;
    UIButton *_btnBottomSearchRoute;
    UIButton *_btnBottomConfiguration;
    
    UIView *_vwZoomLevelGroup;
    UIImageView *_imgvwZoomLevel;
    
    UIButton *_btnBottomLegend;
    
    // MUltiPOI 처리를 위한 배열 (4가지 상이한 데이터를 동일형식으로 변환하기위함)
    NSMutableArray *_refinedMultiPOIList;
    // MultiPOI 선택된 인덱스
    int _selectedMultiPOIIndex;
    // MultiPOI 타입
    int _multiPOIMarkingType;
    
    // MultiPOI 리스트 선택 팝업 컨테이너
    UIView *_vwMultiPOISelectorContainer;
    
    
    // 자동업데이트 정보 (추천검색어)
    NSMutableDictionary *_updateInfoAutoRecommWord;
    
    // 테마 업데이트 컨테이너 뷰
    UIView *_vwThemeUpdateContainer;
    UIProgressView *_pvwThemeUpdateProgress;
    
    // 실시간 정보 뷰
    UIView *_vwRealtimeTrafficTimeTableContainer;
    // 실시간 정보 새로고침 버튼
    OMButton *_btnRealtimeRefresh;

    
    // DB 업데이트 알림용 뷰
    UIView *_vwAutoUpdateContainer;
    UILabel *_lblAutoUpdateStatus;
    
    // 팝업 공지용 뷰 컨테이너
    UIView *_vwNoticePopupContainer;
    UIImageView *_imgvwNoticePopupNoReminerCheckbox;
    
    
    // 교통옵션 사용시 마지막으로 렌더링한 좌표값
    Coord _trafficOptionLastRenderCoordinate;
    NSTimeInterval _trafficOptionLastRequestTime;
    // 테마 사용시 마지막으로 렌더링한 좌표값
    Coord _themeLastRenderingCoordinate;
    NSTimeInterval _themeLastRequestTime;
    // 교통&테마 반경검색 관련 딜레이관리용
    NSMutableDictionary *_themesRequestInfo;
    
    NSLock *_trafficCCTVLock, *_trafficBusStationLock, *_trafficSubwayStationLock, *_themeLock;


    // 오버레이 관련
    OMImageOverlayLongtap *_currentLongTapOverlay;
    OMImageOverlay *_currentSingleOverlay;
    OMImageOverlaySearchMulti *_currentMultiOverlay;
    
    BOOL initstart;
    
    // 스테이터스바?
    OMBlackStatusBar *_barBg;

}
@property (assign, nonatomic) int nMapRenderType;
@property (assign, nonatomic) int nMapRenderSinglePOICategory;
@property (assign, nonatomic) int multiPOIMarkingType;

@property (strong, nonatomic) IBOutlet UIView *kmapView;
@property (strong, nonatomic) IBOutlet UIView *vwNavigationbar;


@property (strong, nonatomic) IBOutlet UIButton *eraseBtn;
- (IBAction)eraseBtnClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIControl *vwSearchGroup;
@property (strong, nonatomic) IBOutlet UILabel *lblSearchKeyword;
- (IBAction)searchBoxClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *vwMyLocationButtonGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnMyLocation;
- (IBAction)locaionBtnClick:(id)sender;

@property (strong, nonatomic) IBOutlet UIView *vwSideButtonGroup;

@property (strong, nonatomic) IBOutlet UIView *vwTrafficGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnSideTraffic;
@property (strong, nonatomic) IBOutlet UIButton *btnSideKMapType;

- (IBAction)trafficGroupBtnClick:(id)sender;
- (IBAction)hybridBtnClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIView *vwCurrentAddressGroup;
@property (strong, nonatomic) IBOutlet UILabel *lblCurrentAddress;

@property (strong, nonatomic) IBOutlet UIView *vwBottomButtonGroup;
@property (strong, nonatomic) IBOutlet UIButton *btnBottomTheme;
- (IBAction)themeBtnClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnBottomSearchRoute;
- (IBAction)SearchRouteBtnClick:(id)sender;


@property (strong, nonatomic) IBOutlet UIButton *btnBottomConfiguration;
- (IBAction)SettingBtnClick:(id)sender;




@property (strong, nonatomic) IBOutlet UIView *vwZoomLevelGroup;
@property (strong, nonatomic) IBOutlet UIImageView *imgvwZoomLevel;


@property (strong, nonatomic) IBOutlet UIButton *btnBottomLegend;
- (IBAction)legendBtnClick:(id)sender;

@property (nonatomic, assign) Coord themeLastRenderingCoordinate;
@property (nonatomic, assign) NSTimeInterval themeLastRequestTime;
@property (atomic, readonly) NSMutableDictionary *themesRequestInfo;

- (void) pinFavoritePOIOverlay :(BOOL)isDisplay;
- (void) toggleMyLocationMode :(int)mode;


// 외부
- (void) pinRecentPOIOverlay:(BOOL)isDisplay;
- (void) pinRouteStartPOIOverlay;
- (void) pinRouteDestPOIOverlay;
- (void) pinRouteVisitPOIOverlay;
- (void) clearRealtimeTrafficTimeTableForce;
- (void) toggleScreenMode :(int)mode :(BOOL)animated;
- (void) toggleKMapStyle:(OllehMapType)type;
- (void) pinLongtapPOIOverlay:(BOOL)isDisplay;
- (void) markingLinePolyGon;
- (void) markingRoadInfo;

+ (void) markingSinglePOI_RenderType:(int)type category:(int)category animated:(BOOL)animated;
+ (void) markingMultiPOI_RenderType:(int)type animated:(BOOL)animated;
+ (void) markingBusLineRoute_BusName:(NSString*)busname animated:(BOOL)animated;
+ (void) markingLinePolygonPOI;
+ (void) markingRoadCodeSearch;
+ (void) markingThemePOI_ThemeCode:(NSString*)themeCode mainThemeCode:(NSString*)mainThemeCode maxRenderingZoomLevel:(int)maxRenderingZoomLevel selectedThemeName:(NSString *)selectedThemeName animated:(BOOL)animated;
@end
