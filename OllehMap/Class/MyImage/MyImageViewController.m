//
//  MyImageViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "MyImageViewController.h"


#import "MyImageModifyViewController.h"
#import "MyImage.h"

#import "OMNavigationController.h"
#import "OllehMapStatus.h"
#import "OMCustomView.h"
#import "OMMessageBox.h"
#import "MapContainer.h"
#import "MyImageCropViewController.h"

@interface MyImageViewController ()

@end

@implementation MyImageViewController

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
    
    [self redrawAllObjects];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [[UIApplication sharedApplication] setIdleTimerDisabled:[[[NSUserDefaults standardUserDefaults] stringForKey:@"IdleTimerDisabled"] isEqualToString:@"YES"]];
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
    
    
    // 버튼
    UIButton *btnPrev = [[UIButton alloc] initWithFrame:CGRectMake(7, 4, 47, 28)];
    [btnPrev setImage:[UIImage imageNamed:@"title_bt_before.png"] forState:UIControlStateNormal];
    [btnPrev addTarget:self action:@selector(onClose:) forControlEvents:UIControlEventTouchUpInside];
    [vwNavigation addSubview:btnPrev];

    // 타이틀
    UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(61, (37-20)/2, 198, 20)];
    [lblTitle setFont:[UIFont systemFontOfSize:20]];
    [lblTitle setBackgroundColor:[UIColor clearColor]];
    [lblTitle setTextAlignment:NSTextAlignmentCenter];
    [lblTitle setText:@"내 사진 설정"];
    [vwNavigation addSubview:lblTitle];
    
    // 네비게이션 뷰 삽입
    [self.view addSubview:vwNavigation];
    
}

- (void) renderBasicDecoration
{
    // ==============
    // Description Area
    // ==============
    
    UIView *descriptionAreaView = [[UIView alloc] initWithFrame:CGRectMake(0, OM_STARTY + 37, 320, 90)];
    [descriptionAreaView setBackgroundColor:[UIColor whiteColor]];
    
    // 섬네일뷰 버튼
    NSInteger selectedImageIndex = [[NSUserDefaults standardUserDefaults] integerForKey:@"MyImageIndex"];
    UIButton *myImageThumnailButton = [[UIButton alloc] initWithFrame:CGRectMake(10, 13, 130/2, 130/2)];
    
    UIImage *myImageThumnail = nil;
    if (selectedImageIndex == 4)
    {
        // Documents 경로생성
        NSArray *documentsDirecotryPathArray = NSSearchPathForDirectoriesInDomains(
                                                                                   NSDocumentDirectory,
                                                                                   NSUserDomainMask,
                                                                                   YES);
        NSString *documentThumnailFilePath = [NSString stringWithFormat:@"%@/MyImageThumnail.PNG", [documentsDirecotryPathArray objectAtIndexGC:0]];
        myImageThumnail = [UIImage imageWithContentsOfFile:documentThumnailFilePath];
    }
    else
        myImageThumnail = [UIImage imageNamed:[NSString  stringWithFormat:@"my_img_default_0%d.png", (int)selectedImageIndex+1]];
    [myImageThumnailButton setImage:myImageThumnail forState:UIControlStateNormal];
    [myImageThumnailButton addTarget:self action:@selector(onModifyMyImage:) forControlEvents:UIControlEventTouchUpInside];
    [descriptionAreaView addSubview:myImageThumnailButton];
    
    
    // 편집
    UIImageView *myImageModifyImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"my_img_btn_edit.png"]];
    [myImageModifyImageView setFrame:CGRectMake(10, 13, 130/2, 130/2)];
    [descriptionAreaView addSubview:myImageModifyImageView];
    
    
    // 설명 타이틀
    UILabel *descriptionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 19, 222, 15)];
    [descriptionTitleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [descriptionTitleLabel setTextColor:convertHexToDecimalRGBA(@"19", @"A8", @"C7", 1.0f)];
    [descriptionTitleLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionTitleLabel setText:@"내 사진 등록"];
    [descriptionAreaView addSubview:descriptionTitleLabel];
    
    
    // 설명 내용
    UILabel *descriptionTextLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 41, 222, 36)];
    [descriptionTextLabel setFont:[UIFont systemFontOfSize:13]];
    [descriptionTextLabel setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
    [descriptionTextLabel setBackgroundColor:[UIColor clearColor]];
    [descriptionTextLabel setNumberOfLines:0];
    [descriptionTextLabel setText:@"지도상에서 내위치를 쉽게 찾을 수\n있도록 내 사진을 등록해보세요."];
    [descriptionAreaView addSubview:descriptionTextLabel];
    
    
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
    UIImage *myImageIconImage = [MyImage getCurrentMyImage];
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

- (void) onModifyMyImage :(id)sender
{
    UIActionSheet *actionSheet = nil;
    if ( [[NSUserDefaults standardUserDefaults] integerForKey:@"MyImageIndex"] == 4)
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"이미지 등록하기" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"기본 이미지 설정", @"사진 촬영", @"사진 보관함에서 선택", @"삭제", nil];
    else
        actionSheet = [[UIActionSheet alloc]
                       initWithTitle:@"이미지 등록하기" delegate:self cancelButtonTitle:@"취소" destructiveButtonTitle:nil otherButtonTitles:@"기본 이미지 설정", @"사진 촬영", @"사진 보관함에서 선택", nil];
    
    [actionSheet showInView:[self view]];
    
}
- (void) actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    switch (buttonIndex)
    {
        case 0: // 기본 이미지 설정
        {
            
            MyImageModifyViewController *mimVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyImageModifyView"];
            [[OMNavigationController sharedNavigationController] pushViewController:mimVC animated:NO];
        }
            break;
        case 1: // 사진 촬영
        {
            // 카메라 사용여부 판단.
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
                imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
                imagePicker.allowsEditing = NO;
                
                [self presentModalViewController:imagePicker animated:YES];
            }
            else
            {
                [OMMessageBox showAlertMessage:@"" :@"카메라를 사용할 수 없습니다."];
            }
        }
            break;
        case 2: // 사진 보관함에서 선택
        {
            // 포토라이브러리 사용여부 판단.
            if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] )
            {
                UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
                
                imagePicker.delegate = self;
                imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                imagePicker.allowsEditing = NO;
                
                [self presentModalViewController:imagePicker animated:YES];
            }
            else
            {
                [OMMessageBox showAlertMessage:@"" :@"사진 보관함을 사용할 수 없습니다."];
            }
        }
            break;
        case 3: // 삭제
        {
            [[NSUserDefaults standardUserDefaults] setInteger:0 forKey:@"MyImageIndex"];
            [MapContainer refreshMapLocationImage];
            [self redrawAllObjects];
        }
            break;
        default:
            break;
    }
}

- (void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    MyImageCropViewController *micVC = [self.storyboard instantiateViewControllerWithIdentifier:@"MyImageCropView"];
    [[OMNavigationController sharedNavigationController] pushViewController:micVC animated:NO];
    [micVC drawImageWithCameraRoll:info];
    
    [picker dismissModalViewControllerAnimated:YES];
}
- (void) imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissModalViewControllerAnimated:YES];
}

- (void) saveImage
{
    UIImage *image = nil;
    
    NSData *imageData = [NSData dataWithData:UIImagePNGRepresentation(image)];
    [imageData writeToFile:@"path.png" atomically:YES];
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
