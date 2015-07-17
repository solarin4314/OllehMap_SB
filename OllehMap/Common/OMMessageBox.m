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
    
    if (buttonIndex == 0)
    {
        if ([_target respondsToSelector:_firstAction])
            //[_target performSelector:_firstAction withObject:self];
        objc_msgSend(_target, _firstAction, self);
    }
    else if (buttonIndex == 1)
    {
        if ([_target respondsToSelector:_secondAction])
            //[_target performSelector:_secondAction withObject:self];
        objc_msgSend(_target, _secondAction, self);
    }
    else
    {
    }
}


@end
