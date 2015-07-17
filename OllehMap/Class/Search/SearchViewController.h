//
//  SettingViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AudioToolbox/AudioToolbox.h>
#import "SearchResultViewController.h"

// 임시참조
#import "OllehMapStatus.h"
#import "DbHelper.h"
#import "ServerConnector.h"
#import "MapContainer.h"
#import "recentCell2.h"
#import "OmCell.h"
#import "FavoriteViewController.h"
#import "ContactViewController.h"
#import "OMParentViewController.h"
#import "VoiceSearchViewController.h"

@interface RecentTableView : UITableView
@end
@interface RecommandTableView : UITableView
@end

@interface SearchViewController : OMParentViewController< UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UITextFieldDelegate, UIActionSheetDelegate>
{
    
    
    __weak IBOutlet UIView *_anotherSearchView;
    
    __weak IBOutlet TTTAttributedLabel *_anotherSearchLabel;

    int searchOption;
    int willSearchOption;
    
    BOOL _ex;
    int _state;
    
    IBOutlet UILabel *_naviTitleLabel2;
    
    // 키보드 입력 없을 때 서치필드배경
    UIImageView *_noSearchBackGround;
    // 키보드 입력 있을 때 서치필드 배경
    UIImageView *_searchBackGround;
    // 서치텍스트필드
    UITextField *_searchField;
    // X 버튼
    IBOutlet UIButton *_xBtn;
    // x버튼 체커
    BOOL _xClick;
    
    // 즐찾, 연락처, 음성검색 버튼
    IBOutlet UIButton *_favoriteBtn;
    IBOutlet UIButton *_contactBtn;
    IBOutlet UIButton *_voiceBtn;
    
    // 최근검색 테이블
    IBOutlet RecentTableView *_recentTable;
    
    // 최근검색 배열
    NSArray *_recentList;
    // 최근검색 비었을 때 라벨
    UILabel *_recentListEmpty;
    
    // 추천검색
    IBOutlet RecommandTableView *_recommandTable;
    
    // 검색 오류여부
    BOOL searchFailed;
    
    // 검색대상 (출발/도착/경유)에 대한 내부 플래그 (전역 oms는 화면 전환간 변경될수있음)
    int _currentSearchTargetType;
    
    IBOutlet UIView *_emptyView;
    
    int _resultType;
    bool _order;

}

@property (assign, nonatomic) int currentSearchTargetType;
@property (assign, nonatomic) int resultType;
@property (assign, nonatomic) bool order;


@property (strong, nonatomic) IBOutlet UITextField *searchField;
- (IBAction)anotherBtnClick:(id)sender;

- (void)onSearch;


- (IBAction)xBtnClick:(id)sender;


- (IBAction)favoriteBtnClick:(id)sender;
- (IBAction)ContactBtnClick:(id)sender;
- (IBAction)VoiceSearchBtnClick:(id)sender;


- (IBAction)popBtnClick:(id)sender;


@property (nonatomic, strong) NSArray *recentList;
@end
