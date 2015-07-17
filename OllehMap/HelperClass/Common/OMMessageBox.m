//
//  OMMessageBox.m
//  OllehMap
//
//  Created by Changgeun Jeon on 12. 4. 19..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "OMMessageBox.h"

@implementation TelAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end

@implementation HomeAlertView
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
@end

@implementation FavoAlertView

//@synthesize textField = _textField;
@synthesize place = _place;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}
- (void)initWriteFrame
{
    self.alertViewStyle = UIAlertViewStylePlainTextInput;
    UITextField *textField = [self textFieldAtIndex:0];
    [textField setFont:[UIFont systemFontOfSize:16]];
    [textField setText:_place];
    
    
}
- (void) show
{
    [self initWriteFrame];
    [super show];
}

@end

@implementation OMMessageBox

+(void) showAlertMessage :(NSString *)title :(NSString *)message;
{
    
    UIAlertView * alertView = [[UIAlertView alloc]
                               initWithTitle: title
                               message: message
                               delegate: nil
                               cancelButtonTitle: @"확인"
                               otherButtonTitles: nil];
    [alertView show];
    
}

+(void) showAlertMessageWithInteger :(int)Integer Double:(double)Double;
{
    [OMMessageBox showAlertMessage:@"" :[NSString stringWithFormat:@"Integer : %d / Double : %f", Integer, Double]];
}

+ (void) showAlertMessageTwoButtonsWithTitle:(NSString *)title message:(NSString *)message target:(id)target firstAction:(SEL)firstAction secondAction:(SEL)secondAction firstButtonLabel:(NSString *)firstButtonLabel secondButtonLabel:(NSString *)secondButtonLabel
{
    OMMessageBox *alertView = [[OMMessageBox alloc] initWithTitle:title message:message delegate:nil cancelButtonTitle:firstButtonLabel otherButtonTitles:secondButtonLabel, nil];
    
    [alertView setDelegate:alertView];
    [alertView setAlertViewTargetAction:target :firstAction :secondAction];
    
    [alertView show];

}

+(void) writeConsoleLog :(NSString *)message
{
    NSLog(@"[LogMessage]\n%@", message);

    message = nil;
}


- (void) setAlertViewTargetAction :(id)target :(SEL)firstAction :(SEL)secondAction
{
    _target = target;
    _firstAction = firstAction;
    _secondAction =  secondAction;
}
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    
//#ifdef DEBUG
//    if ([_target retainCount] == 1) [OMMessageBox showAlertMessage:@"그화면 이미 죽어있다." :@"버튼포함 메세지 박스에서 버튼동작했을때, 이미 호출한 객체가 릴리즈당해서 앱이  죽었을 상황.."];
//#endif
//    
//    if (buttonIndex == 0)
//    {
//        if ([_target respondsToSelector:_firstAction])
//            [_target performSelector:_firstAction withObject:self];
//    }
//    else if (buttonIndex == 1)
//    {
//        if ([_target respondsToSelector:_secondAction])
//            [_target performSelector:_secondAction withObject:self];
//    }
//    else
//    {
//    }
}


@end
