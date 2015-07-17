//
//  ResolutionViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OllehMapStatus.h"
#import "KMapTypes.h"
#import "OMNavigationController.h"
#import "OMParentViewController.h"
@interface ResolutionViewController : OMParentViewController
{
    int _viewStartY;
    
    int _case;
    
    UIImageView *_hdImg;
    UIImageView *_smallImg;
    UIImageView *_bigImg;
    
    UIButton *_hdBtn;
    UIButton *_smallBtn;
    UIButton *_bigBtn;

}

- (IBAction)popBtnClick:(id)sender;


@property (nonatomic, strong) UIButton *hdBtn;
@property (nonatomic, strong) UIButton *smallBtn;
@property (nonatomic, strong) UIButton *bigBtn;

@end
