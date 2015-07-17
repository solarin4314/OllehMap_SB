//
//  ThemeViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMNavigationController.h"
#import <QuartzCore/QuartzCore.h>
#import "MapContainer.h"
#import "ServerConnector.h"
#import "ThemeCommon.h"
#import "MainViewController.h"
#import "OMParentViewController.h"

@interface ThemeViewController : OMParentViewController
{
    UIScrollView *_scrollView;
    
    int _viewHeight;
    
    // 확장뷰
    UIView *_folderView;
    UIView *_folderinView;
    UIImageView *_folderBg;
    UIImageView *_shadowTopBg;
    UIImageView *_shadowBottomBg;
    
    // 확장아래 스샷부분
    UIControl *_elseView;
    UIImageView *_elseViewBg;
    
    // 테마갯수
    double themeCount;
    // 테마상세갯수
    double themeDetailCount;
    // 테마높이
    int themeViewHeight;
    
    // 선택 테두리
    UIImageView *_selectImg;
    // 버튼센더 태그값
    int index;
    // 버튼좌표값 딕셔너리
    NSMutableDictionary *_btnCrdDictionary;
    // 클릭한 Rect 저장
    CGRect prevRect;
    // 블러뷰 배열
    NSMutableArray *_blurArr;
}

@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) IBOutlet UIView *folderView;
@property (nonatomic, strong) IBOutlet UIControl *elseView;
@property (nonatomic, strong) IBOutlet UIImageView *elseViewBg;
@property (nonatomic, strong) IBOutlet UIImageView *folderBg;
@property (nonatomic, strong) IBOutlet UIImageView *shadowTopBg;
@property (nonatomic, strong) IBOutlet UIImageView *shadowBottomBg;

- (IBAction)closeBtnClick:(id)sender;
- (IBAction)elseViewTab:(id)sender;

@end
