//
//  UIView+CustomToast.h
//  OllehMap
//
//  Created by 이제민 on 14. 3. 20..
//  Copyright (c) 2014년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (CustomToast)
- (void)customToast:(NSString *)message toastYValue:(int)yValue;
- (void)custom2Toast:(NSString *)message toastYValue:(int)yValue;
@end
