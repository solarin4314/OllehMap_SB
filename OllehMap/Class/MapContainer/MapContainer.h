//
//  MapContainer.h
//  StoryBoardTest
//
//  Created by 이제민 on 13. 9. 25..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import <CoreLocation/CoreLocation.h>
#import <CoreGraphics/CoreGraphics.h>
#import <AudioToolbox/AudioToolbox.h>
#import <MessageUI/MFMailComposeViewController.h>
#import <MessageUI/MFMessageComposeViewController.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>

// 기타참조
//#import "OllehMapStatus.h"

// KMap 참조
#import "KMapView.h"
#import "KGeometry.h"
#import "KMapTypes.h"

// 임시참조
#import "OMMessageBox.h"
#import "OMOverlay.h"
#import "OllehMapStatus.h"
#import "MyImage.h"

// 기존 Kmap 커스터마이징
@interface OMKMapView : KMapView
{
    // 스레드에 안전한 오버레이 관리를 위한 큐
    dispatch_queue_t overlayWorkQueue;
    
    // 지도교통옵션을 위한 변수 (CCTV/버스정류장/지하철역)
    bool _trafficCCTV;
    bool _trafficBusStation;
    bool _trafficSubwayStation;
    //  테마를 위한 변수
    bool _theme;
    // 지도좌표 상태변수
    Coord _lastLongTapCoordinate;
    Coord _lastMapCenterCoordinate;
    NSInteger _lastMapZoomLevel;
}
// 지도교통옵션을 위한 변수 (CCTV/버스정류장/지하철역)
@property (nonatomic,assign) bool trafficCCTV;
@property (nonatomic,assign) bool trafficBusStation;
@property (nonatomic,assign) bool trafficSubwayStation;
// 태마변수
@property (nonatomic, assign) bool theme;
// 지도좌표 상태변수
@property (nonatomic, assign) Coord lastLongTapCoordinate;
@property (nonatomic, assign) Coord lastMapCenterCoordinate;
@property (nonatomic, assign) NSInteger lastMapZoomLevel;
// 오버레이 관리 메소드
- (NSArray*) getOverlays;
- (void) removeAllOverlaysWithoutTraffic;
- (void) removeAllOverlaysWithoutTrafficWithoutLinePoly;
- (void) removeAllOverlaysWithoutLinePoly;
- (void) removeAllOverlaysWithoutTrafficRoute;
- (void) removeAllTrafficOverlay;
- (void) removeAllThemeOverlay;
- (void) removeAllRouteOverlay;
- (void) removePolygonOverlay;
- (void) removeSpecialOverlaysKindOfClass :(Class)classKind;
- (void) removeSpecialOverlaysMemberOfClass:(Class)classMember;
- (void) selectPOIOverlay :(OMImageOverlay*)overlay;
- (int) adjustZoomLevel;
- (void) setAdjustZoomLevel :(int)level;
@end

@interface MapContainer : UIView<UIApplicationDelegate,KMapViewDelegate, OverlayDelegate>
{
    OMKMapView *_kmap;
}
@property (nonatomic, retain) OMKMapView *kmap;

+ (MapContainer *) sharedMapContainer_Main;
+ (MapContainer *) sharedMapContainer_SearchRouteResult;
+ (MapContainer *) resetMapContainer_SearchRouteResult;
+ (void) closeMapContainer_SearchRouteResult;
+ (void) closeMapContainer_Main;
+ (void) changeMapDisplayResolution :(int)resolution;
+ (void) refreshMapLocationImage;

- (void) showMapContainer :(UIView *)sView :(id)delegate;
- (NSInteger) convertToDistanceFromZoomLevel :(int)zoomLevel;
- (NSInteger) getCurrentMapZoomLevelMeterWithScreen;

+ (BOOL) CheckLocationService;
+ (BOOL) CheckLocationServiceWithoutAlert;
- (Coord) getCurrentUserLocation;

@end

// KMap 렌더링 관련
enum MapContainer_KMapContainer_ActionType
{
    KMapContainer_ActionType_Normal = 0, KMapContainer_ActionType_SearchResult = 1, KMapContainer_ActionType_SearchRouteResult = 2
};