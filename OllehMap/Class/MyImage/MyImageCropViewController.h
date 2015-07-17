//
//  MyImageCropViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OMParentViewController.h"
@interface MyImageCropViewController : OMParentViewController
{
    UIImageView *_cropImageView;
}
- (void) drawImageWithCameraRoll :(NSDictionary*)info;
@end
