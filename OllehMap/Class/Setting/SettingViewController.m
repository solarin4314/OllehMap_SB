//
//  SettingViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 27..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self drawStart];
}
- (void) drawStart
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    NSString *deviceUnique = [oms generateUuidString];
    
    NSUserDefaults *nd = [NSUserDefaults standardUserDefaults];
    
    if(![nd objectForKeyGC:@"PhoneUniqueId"])
    {
        [nd setObject:deviceUnique forKey:@"PhoneUniqueId"];
        [nd synchronize];
    }
    
    
    // 첫 뷰와 스크롤뷰 사이의 공간
    _viewStartY = 0;
    
    // 공지리스트에 체크하기 넣음
    NSLog(@"notilistcount : %d, notilist : %@", [oms getNoticeCheckCount], [oms getNoticeCheckList]);
    
    //_notiArr = [[oms.noticeListDictionary objectForKeyGC:@"NOTICELIST"] copy];
    
    [self drawSettingView];
}
- (void) drawSettingView
{
    
    //UIColor *titleColor = [UIColor colorWithRed:25.0/255.0 green:168.0/255.0 blue:199.0/255.0 alpha:1];
    //UIFont *titleFont = [UIFont boldSystemFontOfSize:17];
    //int lblX = 21;
    int lblY = 0;
    // 라벨과 박스거리
    int lbl_box = 8;
    int boxX = 10;
    int boxHeight = 45;
    // 박스라벨
    int box_lbl = 16;
    UIFont *boxFont = [UIFont boldSystemFontOfSize:14];
    
    UIView *settingView = [[UIView alloc] init];
    [settingView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    //    // 환경설정
    //    UILabel *settingLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 200, 17)];
    //    [settingLabel setText:@"환경설정"];
    //    [settingLabel setTextColor:titleColor];
    //    [settingLabel setFont:titleFont];
    //    [settingLabel setBackgroundColor:[UIColor clearColor]];
    
    lblY += lbl_box;
    // 환경설정 박쓰
    UIImageView *settingBg = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *setting = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    
    
    if ([OllehMapStatus sharedOllehMapStatus].isRetinaDisplay == NO)
    {
        [settingBg setImage:[UIImage imageNamed:@"setting_box_01.png"]];
    }
    else
    {
        [settingBg setImage:[UIImage imageNamed:@"setting_box_top.png"]];
    }
    
    [settingView addSubview:settingBg];
    [settingView addSubview:setting];
    
    lblY += boxHeight;
    
    // 박스라벨
    UILabel *turnOutPrevent = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [turnOutPrevent setText:@"화면 꺼짐 방지"];
    [turnOutPrevent setFont:boxFont];
    [setting addSubview:turnOutPrevent];
    
    // 스위치(5.0 보다 작으면 스위치가 옛날껄로...옛날껀 width가 더 큼)
    float Version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    
    if ( Version >= 7.0f )
    {
        [_screenSwitch setFrame:CGRectMake(222 + 28, 16, _screenSwitch.frame.size.width, _screenSwitch.frame.size.height)];
    }
    else
        [_screenSwitch setFrame:CGRectMake(_screenSwitch.frame.origin.x, 19, _screenSwitch.frame.size.width, _screenSwitch.frame.size.height)];
    
    NSString *idleTimer = [NSString stringWithFormat:@"%@", [[NSUserDefaults standardUserDefaults] objectForKeyGC:@"IdleTimerDisabled"]];
    
    if([idleTimer isEqualToString:@"YES"])
    {
        [_screenSwitch setOn:YES];
    }
    else {
        [_screenSwitch setOn:NO];
    }
    
    
    [_screenSwitch addTarget:self action:@selector(switcherValue:) forControlEvents:UIControlEventValueChanged];
    [settingView addSubview:_screenSwitch];
    
    if ([OllehMapStatus sharedOllehMapStatus].isRetinaDisplay == NO)
    {
        //lblY += 1;
    }
    else
    {
        UIImageView *underLine = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
        [underLine setImage:[UIImage imageNamed:@"setting_box_line.png"]];
        [settingView addSubview:underLine];
        
        lblY += 1;
        
        //
        // 해상도박스
        UIImageView *resolution = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
        [resolution setImage:[UIImage imageNamed:@"setting_box_bottom.png"]];
        [settingView addSubview:resolution];
        UIView *resolutionView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
        //[favoriteView setBackgroundColor:[UIColor redColor]];
        [settingView addSubview:resolutionView];
        
        lblY += boxHeight;
        
        // 해상도버튼
        UIButton *resolutionBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        // 이미지필요(setting_box_bottom)
        [resolutionBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_bottom_pressed.png"] forState:UIControlStateHighlighted];
        [resolutionBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
        [resolutionBtn addTarget:self action:@selector(resolution:) forControlEvents:UIControlEventTouchUpInside];
        [resolutionView addSubview:resolutionBtn];
        
        
        // 해상도라벨
        UILabel *resolutionLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
        [resolutionLabel setText:@"지도 해상도"];
        [resolutionLabel setBackgroundColor:[UIColor clearColor]];
        [resolutionLabel setFont:boxFont];
        [resolutionView addSubview:resolutionLabel];
        
        UILabel *resolutionLbl = [[UILabel alloc] init];
        
        int resolutionState = [[OllehMapStatus sharedOllehMapStatus] getDisplayMapResolution];
        
        //NSLog(@"지도상태 : %d", resolutionState);
        
        if(resolutionState == KMapDisplayNormalSmallText)
        {
            [resolutionLbl setText:@"일반 모드(작은글씨)"];
        }
        else if (resolutionState == KMapDisplayHD)
        {
            [resolutionLbl setText:@"고해상도 모드(HD)"];
        }
        else if (resolutionState == KMapDisplayNormalBigText)
        {
            [resolutionLbl setText:@"일반 모드(큰글씨)"];
        }
        
        
        [resolutionLbl setFont:[UIFont systemFontOfSize:14]];
        [resolutionLbl setBackgroundColor:[UIColor clearColor]];
        [resolutionLbl setFrame:CGRectMake(0, box_lbl, 283-10, 13)];
        [resolutionLbl setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1)];
        [resolutionLbl setTextAlignment:NSTextAlignmentRight];
        [resolutionView addSubview:resolutionLbl];
        
        // 애로우버튼
        UIImageView *resolutionArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
        [resolutionArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
        [resolutionView addSubview:resolutionArrow];
        
    }
    
    
    
    //
    
    
    //(시작은 30픽셀부터)
    [settingView setFrame:CGRectMake(0, _viewStartY, 320, lblY)];
    [_scrollView addSubview:settingView];
    
    _viewStartY += lblY;
    
    //NSLog(@"_viewStartY : %d", _viewStartY);
    
    [self drawMyPage];
    
}

// 마이페이지
- (void) drawMyPage
{
    UIView *myPageView = [[UIView alloc] init];
    [myPageView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    //
    UIColor *titleColor = [UIColor colorWithRed:25.0/255.0 green:168.0/255.0 blue:199.0/255.0 alpha:1];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17];
    int lblX = 21;
    int lblY = 14;
    // 라벨과 박스거리
    int lbl_box = 9;
    int boxX = 10;
    int boxHeight = 45;
    // 박스라벨
    int box_lbl = 16;
    UIFont *boxFont = [UIFont boldSystemFontOfSize:14];
    
    // 마이페이지
    UILabel *myPageLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 200, 17)];
    [myPageLabel setText:@"마이페이지"];
    [myPageLabel setTextColor:titleColor];
    [myPageLabel setFont:titleFont];
    [myPageLabel setBackgroundColor:[UIColor clearColor]];
    
    lblY += lbl_box;
    
    // 최근검색박스
    UIImageView *recentSearch = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [recentSearch setImage:[UIImage imageNamed:@"setting_box_top.png"]];
    [myPageView addSubview:recentSearch];
    // 최근검색뷰(버튼붙이기위해...)
    UIView *recentSearchView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [myPageView addSubview:recentSearchView];
    
    lblY += boxHeight;
    
    // 최근검색버튼
    UIButton *recentBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [recentBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_top)
    [recentBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_top_pressed.png"] forState:UIControlStateHighlighted];
    [recentBtn addTarget:self action:@selector(recent:) forControlEvents:UIControlEventTouchUpInside];
    [recentSearchView addSubview:recentBtn];
    
    // 최근검색라벨
    UILabel *recentSearchLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [recentSearchLabel setText:@"최근검색"];
    [recentSearchLabel setFont:boxFont];
    [recentSearchLabel setBackgroundColor:[UIColor clearColor]];
    [recentSearchView addSubview:recentSearchLabel];
    
    // 애로우버튼
    UIImageView *recentArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [recentArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [recentSearchView addSubview:recentArrow];
    
    
    // 밑줄
    UIImageView *underLine = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
    [underLine setImage:[UIImage imageNamed:@"setting_box_line.png"]];
    [myPageView addSubview:underLine];
    
    lblY += 1;
    //
    
    
    //
    // 즐겨찾기박스
    UIImageView *favorite = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [favorite setImage:[UIImage imageNamed:@"setting_box_center.png"]];
    [myPageView addSubview:favorite];
    UIView *favoriteView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    //[favoriteView setBackgroundColor:[UIColor redColor]];
    [myPageView addSubview:favoriteView];
    
    lblY += boxHeight;
    
    // 즐겨찾기버튼
    UIButton *favoriteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [favoriteBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_bottom)
    [favoriteBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_center_pressed.png"] forState:UIControlStateHighlighted];
    [favoriteBtn addTarget:self action:@selector(favorite:) forControlEvents:UIControlEventTouchUpInside];
    [favoriteView addSubview:favoriteBtn];
    
    // 즐겨찾기라벨
    UILabel *favoriteLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [favoriteLabel setText:@"즐겨찾기"];
    [favoriteLabel setFont:boxFont];
    [favoriteLabel setBackgroundColor:[UIColor clearColor]];
    [favoriteView addSubview:favoriteLabel];
    
    
    // 애로우버튼
    UIImageView *favoriteArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [favoriteArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [favoriteView addSubview:favoriteArrow];
    
    
    // 밑줄
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
    [underLine2 setImage:[UIImage imageNamed:@"setting_box_line.png"]];
    [myPageView addSubview:underLine2];
    
    
    lblY += 1;
    //
    
    // 계정설정박스
    UIImageView *accountSetting = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *accountSettingView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [accountSetting setImage:[UIImage imageNamed:@"setting_box_bottom.png"]];
    [myPageView addSubview:accountSetting];
    [myPageView addSubview:accountSettingView];
    
    lblY += boxHeight;
    
    // 계정설정버튼
    UIButton *accountSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [accountSettingBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_center)
    [accountSettingBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_bottom_pressed.png"] forState:UIControlStateHighlighted];
    [accountSettingBtn addTarget:self action:@selector(accountSetting:) forControlEvents:UIControlEventTouchUpInside];
    [accountSettingView addSubview:accountSettingBtn];
    
    // 계정설정라벨
    UILabel *accountSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [accountSettingLabel setText:@"계정설정"];
    [accountSettingLabel setBackgroundColor:[UIColor clearColor]];
    [accountSettingLabel setFont:boxFont];
    [accountSettingView addSubview:accountSettingLabel];
    
    
    // 애로우버튼
    UIImageView *accountSettingArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [accountSettingArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [accountSettingView addSubview:accountSettingArrow];
    //
    
    
    [myPageView setFrame:CGRectMake(0, _viewStartY, 320, lblY)];
    [_scrollView addSubview:myPageView];
    
    
    _viewStartY += lblY;
    
    //
    [self drawMyPicture];
    
}
- (void) drawMyPicture
{
    UIView *myPicture = [[UIView alloc] init];
    [myPicture setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    //
    int lblY = 14;
    // 라벨과 박스거리
    int lbl_box = 9;
    int boxX = 10;
    int boxHeight = 45;
    // 박스라벨
    int box_lbl = 16;
    UIFont *boxFont = [UIFont boldSystemFontOfSize:14];
    
    lblY += lbl_box;
    
    // 지도위 사진
    UIImageView *myImg = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [myImg setImage:[UIImage imageNamed:@"setting_box_top.png"]];
    [myPicture addSubview:myImg];
    
    
    UIView *myPictureView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [myPicture addSubview:myPictureView];
    
    lblY += boxHeight;
    
    // 지도위내사진라벨
    UILabel *mapUpMyPictureLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [mapUpMyPictureLabel setText:@"지도 위 내 사진"];
    [mapUpMyPictureLabel setFont:boxFont];
    [mapUpMyPictureLabel setBackgroundColor:[UIColor clearColor]];
    [myPictureView addSubview:mapUpMyPictureLabel];
    
    float Version = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if ( Version >= 7.0f )
    {
        [_myImgSwitch setFrame:CGRectMake(222 - 10 + 28, 7, _myImgSwitch.frame.size.width, _myImgSwitch.frame.size.height)];
    }
    else
        [_myImgSwitch setFrame:CGRectMake(_myImgSwitch.frame.origin.x - 10, 9, _myImgSwitch.frame.size.width, _myImgSwitch.frame.size.height)];
    
    NSUserDefaults *myPictureDefault = [NSUserDefaults standardUserDefaults];
    
    if([myPictureDefault boolForKey:@"UseMyImage"])
    {
        [_myImgSwitch setOn:YES];
    }
    
    
    [_myImgSwitch addTarget:self action:@selector(picSwitch:) forControlEvents:UIControlEventValueChanged];
    [myPictureView addSubview:_myImgSwitch];
    
    
    // 밑줄
    UIImageView *underLine = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
    [underLine setImage:[UIImage imageNamed:@"setting_box_line.png"]];
    [myPicture addSubview:underLine];
    
    lblY += 1;
    
    // 내사진설정
    UIImageView *myImageSetting = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *myImageSettingView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [myImageSetting setImage:[UIImage imageNamed:@"setting_box_bottom.png"]];
    [myPicture addSubview:myImageSetting];
    [myPicture addSubview:myImageSettingView];
    
    lblY += boxHeight;
    
    // 내 이미지 활성화상태값
    NSUserDefaults *pic = [NSUserDefaults standardUserDefaults];
    BOOL valid = [pic boolForKey:@"UseMyImage"];
    
    _myImageSettingBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_myImageSettingBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_center)
    [_myImageSettingBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_bottom_pressed.png"] forState:UIControlStateHighlighted];
    [_myImageSettingBtn addTarget:self action:@selector(imgSetting:) forControlEvents:UIControlEventTouchUpInside];
    [myImageSettingView addSubview:_myImageSettingBtn];
    
    if(valid)
    {
        _myImgSwitch.on = YES;
        
        
        // 내사진설정버튼
        
        
    }
    else
    {
        [_myImageSettingBtn setHidden:YES];
        _myImgSwitch.on = NO;
    }
    // 내사진설정라벨
    _imgSettingLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [_imgSettingLabel setText:@"내 사진 설정"];
    [_imgSettingLabel setFont:boxFont];
    [_imgSettingLabel setBackgroundColor:[UIColor clearColor]];
    if([pic boolForKey:@"UseMyImage"] == YES)
    {
        [_imgSettingLabel setTextColor:[UIColor blackColor]];
    }
    else
    {
        [_imgSettingLabel setTextColor:convertHexToDecimalRGBA(@"a6", @"a6", @"a6", 1)];
    }
    
    [myImageSettingView addSubview:_imgSettingLabel];
    
    
    // 애로우버튼
    _imgSettingArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [_imgSettingArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    
    if([pic boolForKey:@"UseMyImage"] == YES)
    {
        [_imgSettingArrow setAlpha:1.0];
    }
    else
    {
        [_imgSettingArrow setAlpha:0.35];
    }
    
    
    [myImageSettingView addSubview:_imgSettingArrow];
    
    
    [myPicture setFrame:CGRectMake(0, _viewStartY, 320, lblY)];
    [_scrollView addSubview:myPicture];
    
    _viewStartY += lblY;
    
    
    
    [self drawCustomerHelp];
}
-(void) drawCustomerHelp
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    UIView *customerHelpView = [[UIView alloc] init];
    [customerHelpView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    //
    UIColor *titleColor = [UIColor colorWithRed:25.0/255.0 green:168.0/255.0 blue:199.0/255.0 alpha:1];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17];
    int lblX = 21;
    int lblY = 14;
    // 라벨과 박스거리
    int lbl_box = 9;
    int boxX = 10;
    int boxHeight = 45;
    // 박스라벨
    int box_lbl = 16;
    UIFont *boxFont = [UIFont boldSystemFontOfSize:14];
    
    // 고객 도움말
    UILabel *customerHelpLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 200, 17)];
    //[customerHelpLabel setText:@"고객 도움말"];
    [customerHelpLabel setTextColor:titleColor];
    [customerHelpLabel setFont:titleFont];
    [customerHelpLabel setBackgroundColor:[UIColor clearColor]];
    [customerHelpView addSubview:customerHelpLabel];
    
    lblY += lbl_box;
    
    // 공지사항박스
    UIImageView *notice = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *noticeView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [notice setImage:[UIImage imageNamed:@"setting_box_top.png"]];
    [customerHelpView addSubview:notice];
    [customerHelpView addSubview:noticeView];
    
    lblY += boxHeight;
    
    // 공지버튼
    UIButton *noticeBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [noticeBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_top)
    [noticeBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_top_pressed.png"] forState:UIControlStateHighlighted];
    [noticeBtn addTarget:self action:@selector(notice:) forControlEvents:UIControlEventTouchUpInside];
    [noticeView addSubview:noticeBtn];
    
    // 공지사항라벨
    UILabel *noticeLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [noticeLabel setText:@"공지사항"];
    [noticeLabel setBackgroundColor:[UIColor clearColor]];
    [noticeLabel setFont:boxFont];
    [noticeView addSubview:noticeLabel];
    
    // 공지사항 뱃지껍질
    
    
    
    // 공지사항 뱃지텍스트
    NSMutableArray *lister = [oms.noticeListDictionary objectForKeyGC:@"NOTICELIST"];
    
    NSLog(@"returnCount : %d, omsCount : %d", (int)lister.count, [oms getNoticeCheckCount]);
    
    int notReadCount = (int)lister.count - [oms getNoticeCheckCount];
    
    
    if(notReadCount < 1)
    {
        [_notiImg setHidden:YES];
        [_notiLabel setHidden:YES];
    }
    else if(notReadCount < 10)
    {
        [_notiImg setFrame:CGRectMake(69, 14, 17, 18)];
        [_notiImg setImage:[UIImage imageNamed:@"setting_box_icon_01.png"]];
        [_notiLabel setFrame:CGRectMake(69 + 4, 14 + 3, 9, 12)];
        [_notiLabel setText:[NSString stringWithFormat:@"%d", notReadCount]];
    }
    else
    {
        [_notiImg setFrame:CGRectMake(69, 14, 23, 18)];
        [_notiImg setImage:[UIImage imageNamed:@"setting_box_icon_02.png"]];
        [_notiLabel setFrame:CGRectMake(69 + 4, 14 + 3, 15, 12)];
        [_notiLabel setText:[NSString stringWithFormat:@"%d", notReadCount]];
    }
    [_notiLabel setTextAlignment:NSTextAlignmentCenter];
    [_notiLabel setFont:[UIFont systemFontOfSize:12]];
    [_notiLabel setBackgroundColor:[UIColor clearColor]];
    [_notiLabel setTextColor:[UIColor whiteColor]];
    
    [noticeView addSubview:_notiImg];
    //[notiImg release];
    [noticeView addSubview:_notiLabel];
    //[notiLabel release];
    
    
    
    // 애로우버튼
    UIImageView *noticeArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [noticeArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [noticeView addSubview:noticeArrow];
    
    // 밑줄
    UIImageView *underLine = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
    [underLine setImage:[UIImage imageNamed:@"setting_box_line.png"]];
    [customerHelpView addSubview:underLine];
    
    lblY += 1;
    //
    
    
    // 고객센터박스
    UIImageView *customerCenter = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *customerCenterView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [customerCenter setImage:[UIImage imageNamed:@"setting_box_center.png"]];
    [customerHelpView addSubview:customerCenter];
    [customerHelpView addSubview:customerCenterView];
    
    lblY += boxHeight;
    
    // 고객문의개선제안버튼
    UIButton *customerCenterBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [customerCenterBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_center)
    [customerCenterBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_center_pressed.png"] forState:UIControlStateHighlighted];
    [customerCenterBtn addTarget:self action:@selector(customerCenter:) forControlEvents:UIControlEventTouchUpInside];
    [customerCenterView addSubview:customerCenterBtn];
    
    // 고객문의개선제안라벨
    UILabel *customerCenterLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [customerCenterLabel setText:@"고객문의/개선제안"];
    [customerCenterLabel setBackgroundColor:[UIColor clearColor]];
    [customerCenterLabel setFont:boxFont];
    [customerCenterView addSubview:customerCenterLabel];
    
    
    // 애로우버튼
    UIImageView *customerCenterArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [customerCenterArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [customerCenterView addSubview:customerCenterArrow];
    
    //
    // 밑줄
    UIImageView *underLine2 = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, 1)];
    [underLine2 setImage:[UIImage imageNamed:@"setting_box_line.png"]];
    [customerHelpView addSubview:underLine2];
    
    lblY += 1;
    
    // --
    
    // 도움말박스
    UIImageView *helper = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *helperView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [helper setImage:[UIImage imageNamed:@"setting_box_bottom.png"]];
    [customerHelpView addSubview:helper];
    [customerHelpView addSubview:helperView];
    
    lblY += boxHeight;
    
    // 도움말버튼
    UIButton *helperBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [helperBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    
    // 이미지필요(setting_box_bottom)
    [helperBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_bottom_pressed.png"] forState:UIControlStateHighlighted];
    [helperBtn addTarget:self action:@selector(helper:) forControlEvents:UIControlEventTouchUpInside];
    [helperView addSubview:helperBtn];
    
    // 도움말라벨
    UILabel *helperLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [helperLabel setText:@"도움말"];
    [helperLabel setBackgroundColor:[UIColor clearColor]];
    [helperLabel setFont:boxFont];
    [helperView addSubview:helperLabel];
    
    // 애로우버튼
    UIImageView *helperArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [helperArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [helperView addSubview:helperArrow];
    
    //
    
    [customerHelpView setFrame:CGRectMake(0, _viewStartY, 320, lblY)];
    [_scrollView addSubview:customerHelpView];
    
    _viewStartY += lblY;
    
    [self drawInfo];
}

- (void) drawInfo
{
    UIColor *titleColor = [UIColor colorWithRed:25.0/255.0 green:168.0/255.0 blue:199.0/255.0 alpha:1];
    UIFont *titleFont = [UIFont boldSystemFontOfSize:17];
    int lblX = 21;
    int lblY = 14;
    // 라벨과 박스거리
    int lbl_box = 9;
    int boxX = 10;
    int boxHeight = 45;
    // 박스라벨
    int box_lbl = 16;
    UIFont *boxFont = [UIFont boldSystemFontOfSize:14];
    
    UIView *infoView = [[UIView alloc] init];
    [infoView setBackgroundColor:[UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1]];
    
    // 정보
    UILabel *infoLabel = [[UILabel alloc] initWithFrame:CGRectMake(lblX, lblY, 200, 17)];
    [infoLabel setText:@"정보"];
    [infoLabel setTextColor:titleColor];
    [infoLabel setFont:titleFont];
    [infoLabel setBackgroundColor:[UIColor clearColor]];
    
    lblY += lbl_box;
    // 정보 박쓰
    UIImageView *programInfoBg = [[UIImageView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    UIView *programInfoView = [[UIView alloc] initWithFrame:CGRectMake(boxX, lblY, 300, boxHeight)];
    [programInfoBg setImage:[UIImage imageNamed:@"setting_box_01.png"]];
    [infoView addSubview:programInfoBg];
    [infoView addSubview:programInfoView];
    
    lblY += boxHeight;
    
    // 프로그램정보버튼
    UIButton *programInfoBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [programInfoBtn setFrame:CGRectMake(0, 0, 300, boxHeight)];
    // 이미지필요(setting_box_01)
    [programInfoBtn setBackgroundImage:[UIImage imageNamed:@"setting_box_01_pressed.png"] forState:UIControlStateHighlighted];
    [programInfoBtn addTarget:self action:@selector(programInfo:) forControlEvents:UIControlEventTouchUpInside];
    [programInfoView addSubview:programInfoBtn];
    
    // 박스라벨
    UILabel *programInfoLabel = [[UILabel alloc] initWithFrame:CGRectMake(11, box_lbl, 200, 14)];
    [programInfoLabel setText:@"프로그램 정보"];
    [programInfoLabel setFont:boxFont];
    [programInfoLabel setBackgroundColor:[UIColor clearColor]];
    [programInfoView addSubview:programInfoLabel];
    
    
    // 애로우버튼
    UIImageView *infoArrow = [[UIImageView alloc] initWithFrame:CGRectMake(280, 16, 9, 12)];
    [infoArrow setImage:[UIImage imageNamed:@"setting_arrow_btn.png"]];
    [programInfoView addSubview:infoArrow];
    
    // 마지막은 32픽셀 추가
    [infoView setFrame:CGRectMake(0, _viewStartY, 320, lblY + 16)];
    [_scrollView addSubview:infoView];
    
    _viewStartY += lblY + 16;
    
    [self drawScrollView];
}

- (void) drawScrollView
{
    [_scrollView setFrame:CGRectMake(0, _scrollView.frame.origin.y, 320, self.view.frame.size.height - _scrollView.frame.origin.y)];
    
    [_scrollView setContentSize:CGSizeMake(320, _viewStartY)];
    
    NSLog(@"scrollViewSize : %@", NSStringFromCGRect(_scrollView.frame));
    
}

// 지도해상도
- (void)resolution:(id)sender
{
    ResolutionViewController *revc = [self.storyboard instantiateViewControllerWithIdentifier:@"ResolutionView"];
    [[OMNavigationController sharedNavigationController] pushViewController:revc animated:NO];
    //
    //    [revc release];
}
// 최근검색
- (void)recent:(id)sender
{
    RecentSearchViewController *rsvc = [self.storyboard instantiateViewControllerWithIdentifier:@"RecentSearchView"];
    [[OMNavigationController sharedNavigationController] pushViewController:rsvc animated:NO];
    //    [rsvc release];
}
// 즐겨찾기
-(void)favorite:(id)sender
{
    FavoriteViewController *fvc = [self.storyboard instantiateViewControllerWithIdentifier:@"FavoriteView"];
    [[OMNavigationController sharedNavigationController] pushViewController:fvc animated:YES];
}
// 계정설정
-(void)accountSetting:(id)sender
{
    AccountSettingViewController *asvc = [self.storyboard instantiateViewControllerWithIdentifier:@"AccountSettingView"];
    [[OMNavigationController sharedNavigationController] pushViewController:asvc animated:NO];
    
}
// 내 사진 설정
-(void)imgSetting:(id)sender
{
    MyImageViewController *mivc = [self.storyboard instantiateViewControllerWithIdentifier:@"MyImageView"];
    [[OMNavigationController sharedNavigationController] pushViewController:mivc animated:NO];
    //    [mivc release];
    
}
// 공지사항
- (void)notice:(id)sender
{
    /**
     @MethodDescription
     공지사항 리스트
     @MethodParams
     
     @MethodMehotdReturn
     finishNoticeListUICallBack
     */
    
    // 기존(카운트가 0 조건으로 하면 다시 네트워크가 연결되어도 공지에 들어갈 수 없다
    //    if([[OllehMapStatus sharedOllehMapStatus].noticeListDictionary count] == 0)
    //
    //    {
    //        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    //    }
    //    else
    //    {
    //        NoticeListViewController *nlvc = [[NoticeListViewController alloc] initWithNibName:@"NoticeListViewController" bundle:nil];
    //
    //        [[OMNavigationController sharedNavigationController] pushViewController:nlvc animated:NO];
    //        [nlvc release];
    //    }
    
    // 변경 : 갯수를 세지말고 api한번더 호출!! 수정
    [[ServerConnector sharedServerConnection] requestNoticeList:self action:@selector(finishNoticeListUICallBackSetting:)];
    
}
- (void)finishNoticeListUICallBackSetting:(id)request
{
    if ([request finishCode] == OMSRFinishCode_Completed)
	{
        NoticeListViewController *nlvc = [self.storyboard instantiateViewControllerWithIdentifier:@"NoticeListView"];
        [[OMNavigationController sharedNavigationController] pushViewController:nlvc animated:YES];
        
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
// 고객문의/개선제안
- (void)customerCenter:(id)sender
{
    VOAViewController *voavc = [self.storyboard instantiateViewControllerWithIdentifier:@"VOAView"];
    [[OMNavigationController sharedNavigationController] pushViewController:voavc animated:YES];
}
// 도움말
- (void)helper:(id)sender
{
    
    if ([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected )
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
    else
    {
        HelperViewController *hvc = [self.storyboard instantiateViewControllerWithIdentifier:@"HelperView"];
        
        [[OMNavigationController sharedNavigationController] pushViewController:hvc animated:YES];
        
    }
}
// 프로그램 정보
- (void)programInfo:(id)sender
{
    VersionInfoViewController *vivc = [self.storyboard instantiateViewControllerWithIdentifier:@"VersionInfoView"];
    [[OMNavigationController sharedNavigationController] pushViewController:vivc animated:YES];
    
    
}
- (void)picSwitch:(UISwitch *)tempSwitcher
{
    NSUserDefaults *myPicture = [NSUserDefaults standardUserDefaults];
    
    if(tempSwitcher.on)
    {
        [myPicture setBool:YES forKey:@"UseMyImage"];
        [myPicture synchronize];
        
        [_imgSettingLabel setTextColor:[UIColor blackColor]];
        [_imgSettingArrow setAlpha:1.0];
        [_myImageSettingBtn setHidden:NO];
    }
    else
    {
        [myPicture setBool:NO forKey:@"UseMyImage"];
        [myPicture synchronize];
        
        [_imgSettingLabel setTextColor:convertHexToDecimalRGBA(@"a6", @"a6", @"a6", 1)];
        [_imgSettingArrow setAlpha:0.35];
        [_myImageSettingBtn setHidden:YES];
    }
    
    // 지도내 내이미지 바로 변경 // 알아서 제값 찾아서 변경해준다...~
    [MapContainer refreshMapLocationImage];
    
    //NSLog(@"picState : %@",[myPicture dictionaryRepresentation]);
    
}
- (void)switcherValue:(UISwitch *)tempSwitch
{
    if(tempSwitch.on)
    {
        [[UIApplication sharedApplication] setIdleTimerDisabled:YES];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"IdleTimerDisabled"];
    }
    
    else {
        
        [[UIApplication sharedApplication] setIdleTimerDisabled:NO];
        
        [[NSUserDefaults standardUserDefaults] setObject:@"NO" forKey:@"IdleTimerDisabled"];
    }
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _notiImg = [[UIImageView alloc] init];
    _notiLabel = [[UILabel alloc] init];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)DoneBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}
@end
