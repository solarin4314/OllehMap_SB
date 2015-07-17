//
//  SnsSendViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "SnsSendViewController.h"

@interface SnsSendViewController ()

@end

@implementation SnsSendViewController
- (id) initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if(self)
    {
        
    }
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    [self reDrawView];
    
}
- (void) renderNavigation
{
    if (self.shareType == 2)
    {
        [_naviTitleLbl setText:@"twitter 공유하기"];
        
    }
    else
    {
        [_naviTitleLbl setText:@"facebook 공유하기"];
    }
}

- (void) backgroundClick:(id)sender
{
    [_textBox resignFirstResponder];
}
- (void) reDrawView
{
    if([OllehMapStatus sharedOllehMapStatus].isPhotosCheck)
    {
        [_photoimage setImage:_addImage];
        [_deleteBtn setHidden:NO];
    }
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self renderNavigation];
    [self drawTopView];
    [self drawBottomView];
    
    [[FHSTwitterEngine sharedEngine]permanentlySetConsumerKey:@"uhxY4WBgfVn3Hk2rhSiOMQ" andSecret:@"wn45DWVYU9B01qPu1xOvjmFwtOnehvJ0tssHkCypnQ"];
    [[FHSTwitterEngine sharedEngine]setDelegate:self];
    [[FHSTwitterEngine sharedEngine]loadAccessToken];
    
    _addImage = [[UIImage alloc] init];
    
}
- (void)storeAccessToken:(NSString *)accessToken {
    [[NSUserDefaults standardUserDefaults]setObject:accessToken forKey:@"SavedAccessHTTPBody"];
}

- (NSString *)loadAccessToken {
    return [[NSUserDefaults standardUserDefaults]objectForKey:@"SavedAccessHTTPBody"];
}
- (void) drawTopView
{
    int uiMarginTop = (IS_4_INCH) ? 88 : 0;
    
    // 쉐어뷰
    UIControl *shareView = [[UIControl alloc] init];
    [shareView setFrame:CGRectMake(0, 0, 320, 207 + uiMarginTop)];
    [shareView addTarget:self action:@selector(backgroundClick:) forControlEvents:UIControlEventTouchUpInside];
    [_scrollView addSubview:shareView];
    
    // 타이틀
    UILabel *nameLabel = [[UILabel alloc] init];
    [nameLabel setFrame:CGRectMake(41, 14, 259, 15)];
    [nameLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [nameLabel setText:stringValueOfDictionary(self.shareDict, @"SHARENAME")];
    [shareView addSubview:nameLabel];
    
    // 상단 단축 url 라벨
    UILabel *urlLabel = [[UILabel alloc] init];
    [urlLabel setFrame:CGRectMake(41, 30, 259, 19)];
    [urlLabel setFont:[UIFont systemFontOfSize:15]];
    [urlLabel setTextColor:convertHexToDecimalRGBA(@"8b", @"8b", @"8b", 1)];
    [urlLabel setText:stringValueOfDictionary(self.shareDict, @"SHAREURL")];
    [shareView addSubview:urlLabel];
    
    // 텍스트 라벨 설정
    _textBox = [[UITextView alloc] init];
    [_textBox setDelegate:self];
    [_textBox setFrame:CGRectMake(20, 66, 290, 90 + uiMarginTop)];
    [_textBox setFont:[UIFont systemFontOfSize:13]];
    [_textBox setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [_textBox setKeyboardType:UIKeyboardTypeDefault];
    [_textBox setBackgroundColor:[UIColor clearColor]];
    [_textBox setScrollEnabled:YES];
    //_textBox.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"share_textfield.png"]];
    
    // 텍필 배경
    UIImageView *tBoxBg = [[UIImageView alloc] init];
    
    if (IS_4_INCH)
    {
        [tBoxBg setFrame:CGRectMake(10, 60, 300, 184)];
        [tBoxBg setImage:[UIImage imageNamed:@"share_textfield-568h.png"]];
    }
    else
    {
        [tBoxBg setFrame:CGRectMake(10, 60, 300, 96)];
        [tBoxBg setImage:[UIImage imageNamed:@"share_textfield.png"]];
    }
    
    [shareView addSubview:tBoxBg];
    
    [_textBox setEnablesReturnKeyAutomatically:NO];
    [shareView addSubview:_textBox];
    
    [_textBox setText:[NSString stringWithFormat:@"%@\n%@\n", stringValueOfDictionary(self.shareDict, @"SHAREADDR"), stringValueOfDictionary(self.shareDict, @"SHARETEL")]];
    
    // 키보드 활성화
    [_textBox becomeFirstResponder];
    
    
    // sns 별 이미지 넣기
    UIImage *faceimg = [UIImage imageNamed:@"copy_icon_facebook.png"];
    UIImage *twitterimg = [UIImage imageNamed:@"copy_icon_twitter.png"];
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 23, 23)];
    
    // 이미지 설정
    if (self.shareType == 2)
        [imgView setImage:twitterimg];
    else
        [imgView setImage:faceimg];
    
    
    [shareView addSubview:imgView];
    
    
    // 카메라 버튼
    UIButton *cameraBtn = [UIButton buttonWithType:UIButtonTypeCustom];
	[cameraBtn addTarget:self action:@selector(cameraBtnClick:) forControlEvents:UIControlEventTouchUpInside];
	[cameraBtn setFrame:CGRectMake(10, 332/2 + uiMarginTop, 147, 31)];
    [cameraBtn setImage:[UIImage imageNamed:@"share_btn_camera.png"] forState:UIControlStateNormal];
    [shareView addSubview:cameraBtn];
    
    // 앨범버튼
    UIButton *albumBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [albumBtn setFrame:CGRectMake(163, 332/2 + uiMarginTop, 147, 31)];
    [albumBtn setImage:[UIImage imageNamed:@"share_btn_album.png"] forState:UIControlStateNormal];
    [albumBtn addTarget:self action:@selector(albumBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [shareView addSubview:albumBtn];
    
    // 밑줄
    UIImageView *underLine = [[UIImageView alloc] init];
    [underLine setFrame:CGRectMake(0, 332/2 + 31 + 10 + uiMarginTop, 320, 1)];
    [underLine setBackgroundColor:convertHexToDecimalRGBA(@"c2", @"c2", @"c2", 1)];
    [shareView addSubview:underLine];
    
}
- (void) drawBottomView
{
    int uiMarginTop = (IS_4_INCH) ? 88 : 0;
    
    UIView *bottomView = [[UIView alloc] init];
    [bottomView setFrame:CGRectMake(0, uiMarginTop + 209, 320, 215)];
    [bottomView setBackgroundColor:convertHexToDecimalRGBA(@"f2", @"f2", @"f2", 1)];
    [_scrollView addSubview:bottomView];
    
    //.. 포토 뷰어 입니다.
    _photoview           =   [[UIView alloc] init];
    [_photoview setFrame:CGRectMake(75, 23, 170, 170)];
    [_photoview setBackgroundColor:[UIColor clearColor]];
    [bottomView addSubview:_photoview];
    
    //.. 사진첨부 이미지 뷰어
    _photoimage          =   [[UIImageView alloc] init];
    [_photoimage setFrame:CGRectMake(1, 1, 168, 168)];
    [_photoimage setImage:[UIImage imageNamed:@"share_no_image.png"]];
    //[_photoimage setContentMode:UIViewContentModeScaleAspectFit];
    [_photoimage setBackgroundColor:[UIColor clearColor]];
    [_photoview addSubview:_photoimage];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setFrame:CGRectMake(1, 140, 168, 29)];
    [_deleteBtn setImage:[UIImage imageNamed:@"share_btn_delete.png"] forState:UIControlStateNormal];
    [_deleteBtn addTarget:self action:@selector(onPhotoEnable:) forControlEvents:UIControlEventTouchUpInside];
    [_deleteBtn setHidden:YES];
    [_photoview addSubview:_deleteBtn];
}



/**
 @brief 첨부한 사진데이터 삭제
 */

-(void)onPhotoEnable:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    // 사진 데이터 삭제 및 플러그 변경
    if(oms.photoimg != nil){
        oms.photoimg = nil;
    }
    oms.isPhotosCheck = FALSE;
    
    // 뷰 이미지 삭제
    [_photoimage setImage:[UIImage imageNamed:@"share_no_image.png"]];
 
}

- (void) cameraBtnClick:(id)sender
{
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera] )
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
        imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModePhoto;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
        
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :@"카메라를 사용할 수 없습니다."];
    }
    
}
- (void) albumBtnClick:(id)sender
{
    
    if ( [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary] )
    {
        UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
        
        imagePicker.delegate = self;
        imagePicker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePicker.allowsEditing = YES;
        
        [self presentModalViewController:imagePicker animated:YES];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :@"사진 보관함을 사용할 수 없습니다."];
    }
    
}
- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    if(oms.photoimg != nil)
    {
        oms.photoimg = nil;
    }
    
    UIImage *img1 = [info objectForKey:UIImagePickerControllerEditedImage];
    
    _addImage = img1;
    
    oms.photoimg = img1;
    
    oms.isPhotosCheck = TRUE;
    [_textBox resignFirstResponder];
    [_textBox.inputAccessoryView setHidden:YES];
    
    
    [picker dismissModalViewControllerAnimated:YES];
}


#pragma mark -
#pragma mark - UITextViewDelegate 글자수제한

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    
    NSString *candidateString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    int maxLength;
    
    if(self.shareType == 2)
    {
        maxLength = 140;
    }
    else
    {
        maxLength = 200;
    }
    
    
    //길이 초과 점검
    if(text && [text length] && ([candidateString length] >= maxLength)) {
        return NO;
    }
    
    // For any other character return TRUE so that the text gets added to the view
    return TRUE;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelBtnClick:(id)sender
{
    [OllehMapStatus sharedOllehMapStatus].isPhotosCheck = false;
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}

- (IBAction)sendBtnClick:(id)sender
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    NSString *postStr = [NSString stringWithFormat:@"[올레맵] %@\n%@\n%@\n", stringValueOfDictionary(self.shareDict, @"SHARENAME"), stringValueOfDictionary(self.shareDict, @"SHAREURL"), _textBox.text];
    
    [self.sendBtn setEnabled:NO];
    
    if(self.shareType == 0)
    {
        NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
        NSString *graphPaths = @"";
        
        if(oms.isPhotosCheck)
        {
        [params setObject:postStr forKey:@"message"];
        [params setObject:_addImage forKey:@"picture"];
        graphPaths = @"me/photos";
        }
        else
        {
            [params setObject:postStr forKey:@"message"];
            graphPaths = @"me/feed";
        }
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        [FBRequestConnection startWithGraphPath:graphPaths
                                     parameters:params
                                     HTTPMethod:@"POST"
                              completionHandler:^(FBRequestConnection *connection,
                                                  id result,
                                                  NSError *error)
         {
             
             [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
             
             if (error)
             {
                 [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Share_FaceBookFail", @"")];
                 [self.sendBtn setEnabled:YES];
                 return;
             }
             else
             {
                 NSLog(@"facebook success out side App");
                 [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Share_FaceBookOk", @"")];
                 oms.isPhotosCheck = false;
                 [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
                 
//                 dispatch_sync(dispatch_get_main_queue(), ^{
//                     @autoreleasepool {
//                         
//                     }
//                 });
                 
                 
             }
         }];
        
        
    }
    else if (self.shareType == 1)
    {
        
        ACAccountStore *accountStore = [[ACAccountStore alloc] init];
        ACAccountType *facebookAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierFacebook];
        __block ACAccount *facebookAccount = nil;
        // Now that you have publish permissions execute the request
        NSDictionary *options2 = @{
                                   ACFacebookAppIdKey:facebooksId,
                                   ACFacebookPermissionsKey: @[@"publish_stream", @"publish_actions"],
                                   ACFacebookAudienceKey: ACFacebookAudienceFriends
                                   };
        
        [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;

        [accountStore requestAccessToAccountsWithType:facebookAccountType options:options2 completion:^(BOOL granted, NSError *error) {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            if (granted) {
                NSArray *accounts = [accountStore accountsWithAccountType:facebookAccountType];
                
                facebookAccount = [accounts lastObject];
                
                NSMutableDictionary *params = [[NSMutableDictionary alloc] init];
                NSString *graphPaths = @"";
                
                if(oms.isPhotosCheck)
                {
                    [params setObject:postStr forKey:@"message"];
                    graphPaths = @"photos";
                    
                }
                else
                {
                    [params setObject:postStr forKey:@"message"];
                    graphPaths = @"feed";
                }

                NSString *urlStr = [NSString stringWithFormat:@"https://graph.facebook.com/me/%@", graphPaths];
                
                NSURL *feedURL = [NSURL URLWithString:urlStr];
                
                SLRequest *feedRequest = [SLRequest
                                          requestForServiceType:SLServiceTypeFacebook
                                          requestMethod:SLRequestMethodPOST
                                          URL:feedURL
                                          parameters:params];
                NSLog(@"AnythingHere?");
                
                if(oms.isPhotosCheck)
                    [feedRequest addMultipartData:UIImagePNGRepresentation(_addImage)
                                             withName:@"source"
                                                 type:@"multipart/form-data"
                                             filename:@"TestImage"];
                
                [feedRequest setAccount:facebookAccount];
                
                [feedRequest performRequestWithHandler:^(NSData *responseData,
                                                         NSHTTPURLResponse *urlResponse, NSError *error)
                 {
                     if(error)
                     {
                        NSLog(@"%@%@", error,urlResponse);
                         [self.sendBtn setEnabled:YES];
                         [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Share_FaceBookFail", @"")];
                         return;
                     }
                     NSLog(@"facebook success setting");
                     [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_Share_FaceBookOk", @"")];
                     oms.isPhotosCheck = false;
                     [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
//                     dispatch_sync(dispatch_get_main_queue(), ^{
//                         @autoreleasepool {
//                             
//                         }
//                     });
                     
                     //NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:kNilOptions error:nil];
                     
                     //NSLog(@"Facebook Response : %@",response);
                     
                 }];
            }
            else{
                //[OMMessageBox showAlertMessage:facebooksId :error.localizedDescription];
                NSLog(@"%@", error.localizedDescription);
            }
        }];
    }
    else
    {
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        @autoreleasepool {

            id returned = nil;
            
            if(oms.isPhotosCheck)
            {
                returned = [[FHSTwitterEngine sharedEngine] postTweet:postStr withImageData:UIImagePNGRepresentation(_addImage)];
            
            }
            else
            {
                returned = [[FHSTwitterEngine sharedEngine] postTweet:postStr];
            }
            [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            
            //NSString *title = nil;
            //NSString *message = nil;
            
            if ([returned isKindOfClass:[NSError class]]) {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                //NSError *error = (NSError *)returned;
                //NSString *title = [NSString stringWithFormat:@"Error %d",(int)error.code];
                //NSString *message = error.localizedDescription;
                [self.sendBtn setEnabled:YES];
                [OMMessageBox showAlertMessage:@"":NSLocalizedString(@"Msg_Share_TwitterFail", @"")];
                    
                    }
                });
            } else {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    @autoreleasepool {
                        NSLog(@"twitter success out side App");
                        [OMMessageBox showAlertMessage:@"":NSLocalizedString(@"Msg_Share_TwitterOk", @"")];
                        oms.isPhotosCheck = false;
                        [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
                    }
                });
            }
            
        }
    });
    }
    
}

@end
