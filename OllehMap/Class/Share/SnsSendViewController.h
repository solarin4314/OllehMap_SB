//
//  SnsSendViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 14..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>
#import "OllehMapStatus.h"
#import "OMMessageBox.h"
#import "OMIndicator.h"
#import "OMCustomView.h"
#import "OMNavigationController.h"
#import "OMParentViewController.h"
#import "FHSTwitterEngine.h"

#import <Social/Social.h>
#import <Accounts/Accounts.h>
@interface SnsSendViewController : OMParentViewController<UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate,FHSTwitterEngineAccessTokenDelegate>
{

    // 진짜
    IBOutlet UIScrollView *_scrollView;
    
    
    IBOutlet UILabel *_naviTitleLbl;
    
    UIImage *_addImage;
    
    
    UITextView *_textBox;
    
    UIView *_photoview;
    UIImageView *_photoimage;
    UIButton *_deleteBtn;

}
@property (nonatomic, strong) NSDictionary *shareDict;
@property (nonatomic, assign) int shareType;

@property (nonatomic, strong) IBOutlet UIButton *sendBtn;

- (IBAction)cancelBtnClick:(id)sender;

- (IBAction)sendBtnClick:(id)sender;


@end

