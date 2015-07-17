//
//  MyImageModifyViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "MyImageModifyViewController.h"

#import "MyImage.h"
#import "OMNavigationController.h"
#import "OllehMapStatus.h"
#import "OMCustomView.h"
#import "OMMessageBox.h"
#import "MapContainer.h"
#import "OMIndicator.h"

@interface MyImageModifyViewController ()
{
    NSInteger _selectedImageIndex;
}
@end

@implementation MyImageModifyViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        _selectedImageIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"MyImageIndex"];
    }
    return self;
}
- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self redrawAllObjects];
}



- (void) redrawAllObjects
{
    for (UIView *subview in self.view.subviews)
    {
        if(![subview isKindOfClass:[OMBlackStatusBar class]])
        {
            [subview removeFromSuperview];
        }
    }
    
    [self renderNavigation];
    [self renderBasicDecoration];
}

- (void) renderNavigation
{
    // 네비게이션 뷰 생성
    UIView *vwNavigation = [[UIView alloc] initWithFrame:CGRectMake(0, 0 + OM_STARTY, 320, 37)];
    
    // 배경 이미지
    UIImageView *imgvwBack = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"title_bg.png"]];
    [vwNavigation addSubview:imgvwBack];
    
    
    // 취소버튼
    UIButton *btnPrev = [[UIButton alloc] initWithFrame:CGRectMake(7, 4, 47, 28)];
    [btnPrev setImage:[UIImage imageNamed:@"title_bt_cancel.png"] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [vwNavigation addSubview:btnPrev];
    
    
    // 완료버튼
    UIButton *btnApply = [[UIButton alloc] initWithFrame:CGRectMake(271, 4, 47, 28)];
    [btnApply setImage:[UIImage imageNamed:@"title_btn_finish.png"] forState:UIControlStateNormal];
    [btnApply addTarget:self action:@selector(onApply:) forControlEvents:UIControlEventTouchUpInside];
    [vwNavigation addSubview:btnApply];
    
    // 타이틀
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(61, (37-20)/2, 198, 20)];
    [lblTitle setFont:[UIFont systemFontOfSize:20]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:@"기본 이미지 설정"];
    [vwNavigation addSubview:lblTitle];
    
    
    // 네비게이션 뷰 삽입
    [self.view addSubview:vwNavigation];
    
}

- (void) renderBasicDecoration
{
    // ==============
    // Description Area
    // ==============
    
    UIView *descriptionAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, 37 + OM_STARTY, 320, 90)];
    [descriptionAreaView setBackgroundColor:[UIColor whiteColor]];
    
    // 섬네일뷰 버튼
    for (int i=0, maxi=3; i<=maxi; i++)
    {
        if ( _selectedImageIndex == i )
        {
            UIImage *myImageThumnailSelected = [UIImage imageNamed:@"my_img_pressed.png"];
            UIImageView *myImageThumnailBackgroundImageView = [[UIImageView alloc] initWithImage:myImageThumnailSelected];
            [myImageThumnailBackgroundImageView setFrame:CGRectMake(4 + 78*i, 6, 77, 78)];
            [descriptionAreaView addSubview:myImageThumnailBackgroundImageView];
            
        }
        UIButton *myImageThumnailButton = [[UIButton alloc] initWithFrame:CGRectMake( 10 + 78*i , 13, 130/2, 130/2)];
        UIImage *myImageThumnail = [UIImage imageNamed:[NSString stringWithFormat:@"my_img_default_0%d.png", i+1]];
        [myImageThumnailButton setImage:myImageThumnail forState:UIControlStateNormal];
        [myImageThumnailButton setTag:i];
        [myImageThumnailButton addTarget:self action:@selector(onMyDefaultImage:) forControlEvents:UIControlEventTouchUpInside];
        [descriptionAreaView addSubview:myImageThumnailButton];
    }
    
    [self.view addSubview:descriptionAreaView];
    
    
    
    // ================
    // 미리보기 영역
    // ================
    
    UIView *previewAreaView = [[UIView alloc]
                               initWithFrame:CGRectMake(0, 37+90 + OM_STARTY,
                                                        320,
                                                        self.view.frame.size.height - (127 + OM_STARTY))];
    // 지도
    NSString *previewMapImageName;
    UIImageView *previewMapImageView;
    
    if (IS_4_INCH)  previewMapImageName = @"preview_map-568h.png";
    else            previewMapImageName = @"preview_map.png";
    
    previewMapImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:previewMapImageName]];
    
    [previewAreaView addSubview:previewMapImageView];
    
    
    // 미리보기 타이틀 이미지
    UIImageView *previewMapTitleImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"preview_img.png"]];
    [previewMapTitleImageView setFrame:CGRectMake(0, 0, 320, 35)];
    [previewAreaView addSubview:previewMapTitleImageView];
    
    
    // 내이미지 아이콘
    UIImage *myImageIconImage = [MyImage merge: [UIImage imageNamed:[NSString stringWithFormat:@"map_location_default_0%d.png", (int)_selectedImageIndex+1]] ];
    UIImageView *myImageIconImageView = [[UIImageView alloc]  initWithImage:myImageIconImage];
    [myImageIconImageView setFrame:CGRectMakeInteger(258/2, 216/2, myImageIconImage.size.width, myImageIconImage.size.height)];
    //[myImageIconImageView setFrame:CGRectMake(129, 108, myImageIconImage.size.width, myImageIconImage.size.height)];
    [previewAreaView addSubview:myImageIconImageView];
    
    
    [self.view addSubview:previewAreaView];
    
    
}

- (void) onClose :(id)sender
{
    // 창닫기
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}

- (void) onApply :(id)sender
{
    // 창닫기 전에 변경된 이미지 처리
    if ( _selectedImageIndex != [[NSUserDefaults standardUserDefaults] integerForKey:@"MyImageIndex"] )
    {
        [[NSUserDefaults standardUserDefaults] setInteger:_selectedImageIndex forKey:@"MyImageIndex"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        [[OMIndicator sharedIndicator] startAnimating];
        [MapContainer refreshMapLocationImage];
        [[OMIndicator sharedIndicator] forceStopAnimation];
    }
    // 창닫기
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
}

- (void) onMyDefaultImage :(id)sender
{
    UIButton *imageButton  = (UIButton*)sender;
    
    //[[NSUserDefaults standardUserDefaults] setInteger:imageButton.tag forKey:@"MyImageIndex"];
    //[[NSUserDefaults standardUserDefaults] synchronize];
    _selectedImageIndex = imageButton.tag;
    
    [self redrawAllObjects];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
