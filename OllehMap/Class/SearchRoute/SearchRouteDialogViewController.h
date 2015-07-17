//
//  SearchRouteDialogViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 8..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "OMNavigationController.h"
//#import "OMDimmedView.h"
#import "OMMessageBox.h"
#import "SearchRouteExecuter.h"
#import "MapContainer.h"
#import "MainViewController.h"

@interface SearchRouteDialogViewController : UIViewController
{
    // 딤드창
    UIControl *_vwSearchRouteContainer;
    
    // 검색 다이얼로그 그룹
    UIView *_vwSearchRouteDialog;
    UIImageView *_imgvwSearchRouteDialogBackground;
    
    // 출발지
    UILabel *_lblStart;
    
    // 경유지
    UIImageView *_imgvwVisitIcon;
    UILabel *_lblVisit;
    UIButton *_visitButton;
    UIImageView *_btnVisitAddRemoveButton;
    
    // 도착지
    UILabel *_lblDest;
    
    // 버튼
    UIButton *_btnReset;
    UIButton *_btnRoute;

}
// ===============================
// [ 길찾기 다이얼로그 호출 메소드 ]
// ===============================
+ (SearchRouteDialogViewController *) sharedSearchRouteDialog;
- (void) showSearchRouteDialog;
- (void) showSearchRouteDialogWithAnalytics :(BOOL)analytics;
- (void) resetDialog;
- (void) closeSearchRouteDialog;
// *******************************


// ======================
// [ 길찾기 Interaction ]
// ======================
- (void) touchStart:(id)sender;
- (void) touchVisit:(id)sender;
- (void) touchDest:(id)sender;
- (void) onReset:(id)sender;
- (void) onRoute:(id)sender;
- (void) onCellDown:(id)sender;
- (void) onCellUp:(id)sender;

- (void) onTouchBackground:(id)sender;
// **********************

@end
