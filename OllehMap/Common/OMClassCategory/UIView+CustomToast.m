//
//  UIView+CustomToast.m
//  OllehMap
//
//  Created by 이제민 on 14. 3. 20..
//  Copyright (c) 2014년 이제민. All rights reserved.
//

#import "UIView+CustomToast.h"
#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

static const NSString * CSToastTimerKey         = @"CSToastTimerKey";
static const NSString * CSToastActivityViewKey  = @"CSToastActivityViewKey";

@interface UIView (PrivateToast)

- (void)hideToast:(UIView *)toast;

@end

@implementation UIView (CustomToast)
- (void)hideToast:(UIView *)toast {
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseIn | UIViewAnimationOptionBeginFromCurrentState)
                     animations:^{
                         toast.alpha = 0.0;
                     } completion:^(BOOL finished) {
                         [toast removeFromSuperview];
                     }];
}
- (void)customToast:(NSString *)message toastYValue:(int)yValue
{
    
    [self showCustomToast:message yvalue:yValue];
}
- (void)showCustomToast:(NSString *)message yvalue:(int)value {
    
    //UIView *toast = [self viewForMessage:message title:nil image:nil];
    
    UIView *toast = [self viewForMessages:message];
    [toast setTag:1129];
    [toast setFrame:CGRectMake(28, value, 264, 36)];
    
    //toast.center = [self centerPointForPosition:point withToast:toast];
    toast.alpha = 0.0;
    
    if (1) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}

- (void)custom2Toast:(NSString *)message toastYValue:(int)yValue
{
    [self showCustom2Toast:message yvalue:yValue];
}
- (void)showCustom2Toast:(NSString *)message yvalue:(int)value
{
    
    UIView *toast = [self viewForMessages:message];
    [toast setTag:1130];
    [toast setFrame:CGRectMake(28, value, 264, 36)];
    
    toast.alpha = 0.0;
    
    if (1) {
        UITapGestureRecognizer *recognizer = [[UITapGestureRecognizer alloc] initWithTarget:toast action:@selector(handleToastTapped:)];
        [toast addGestureRecognizer:recognizer];
        toast.userInteractionEnabled = YES;
        toast.exclusiveTouch = YES;
    }
    
    [self addSubview:toast];
    
    [UIView animateWithDuration:0.2
                          delay:0.0
                        options:(UIViewAnimationOptionCurveEaseOut | UIViewAnimationOptionAllowUserInteraction)
                     animations:^{
                         toast.alpha = 1.0;
                     } completion:^(BOOL finished) {
                         NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:3.0f target:self selector:@selector(toastTimerDidFinish:) userInfo:toast repeats:NO];
                         // associate the timer with the toast view
                         objc_setAssociatedObject (toast, &CSToastTimerKey, timer, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                     }];
    
}
- (void)toastTimerDidFinish:(NSTimer *)timer {
    [self hideToast:(UIView *)timer.userInfo];
}

- (void)handleToastTapped:(UITapGestureRecognizer *)recognizer {
    NSTimer *timer = (NSTimer *)objc_getAssociatedObject(self, &CSToastTimerKey);
    [timer invalidate];
    
    [self hideToast:recognizer.view];
}
- (UIView *)viewForMessages:(NSString *)message
{
    UIView *toastContainer = [[UIView alloc] init];
    [toastContainer setBackgroundColor:[UIColor clearColor]];
    [toastContainer setUserInteractionEnabled:NO];
    
    // 토스트 배경 이미지뷰 생성
    UIImageView *toastBackgroundImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"toast_popup.png"]];
    [toastBackgroundImageView setFrame:CGRectMake(0, 0, 264, 36)];
    
    // 토스트 메세지 라벨 생성
    CGRect toastMessageLabelFrame = CGRectMake(0, 11, 264, 13);
    UILabel *toastMessageLabel = [[UILabel alloc] initWithFrame:toastMessageLabelFrame];
    [toastMessageLabel setFont:[UIFont boldSystemFontOfSize:13]];
    [toastMessageLabel setLineBreakMode:NSLineBreakByClipping];
    [toastMessageLabel setNumberOfLines:NSIntegerMax];
    [toastMessageLabel setBackgroundColor:[UIColor clearColor]];
    [toastMessageLabel setTextColor:[UIColor whiteColor]];
    [toastMessageLabel setTextAlignment:NSTextAlignmentCenter];
    [toastMessageLabel setText:message];
    
    // 토스트 배경 이미지뷰 삽입
    [toastContainer addSubview:toastBackgroundImageView];
    // 토스트 메세지 라벨 삽입
    [toastContainer addSubview:toastMessageLabel];
    
    return toastContainer;
}

@end
