//
//  OMCustomView.m
//  OllehMap
//
//  Created by Changgeun Jeon on 12. 6. 29..
//  Copyright (c) 2012년 __MyCompanyName__. All rights reserved.
//

#import "OMCustomView.h"
#import "OMMessageBox.h"

// 텍스트 라벨 사이즈 조절
LabelResizeInfo getLabelResizeInfo (UILabel *label, CGFloat maxWidth)
{
    LabelResizeInfo info;
    // 위치
    info.origin = label.frame.origin;
    // 이전 최적사이즈
    [label  sizeToFit];
    info.preSize = label.frame.size;
    // 신규 최적사이즈
    info.newSize = [label.text sizeWithFont:label.font constrainedToSize:CGSizeMake(maxWidth, FLT_MAX) lineBreakMode:label.lineBreakMode];
    
    
    CGSize sizeLabelName = [label.text sizeWithFont:label.font];
    
    if(sizeLabelName.width > maxWidth)
        info.numberOfLines = 2;
    
    // 라인수
    //info.numberOfLines = info.newSize.height / info.preSize.height;
    
    return info;
}
void setLabelResizeWithLabelResizeInfo (UILabel *label, LabelResizeInfo info)
{
    // 프레임 설정
    [label setFrame:CGRectMake(info.origin.x, info.origin.y, info.newSize.width, info.newSize.height)];
    // 라인 설정
    [label setNumberOfLines:info.numberOfLines];
    
}
// 배경 흰색뷰
@implementation OMWhiteView : UIView

-(id) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
// 스테이터스바 배경 블랙
@implementation OMBlackStatusBar : UIView

-(id) init
{
    self = [super init];
    
    if(self)
    {
        //self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        
    }
    return self;
}
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        self.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.9];
    }
    return self;
}

@end
// 배경흰색 스크롤뷰
@implementation OMWhiteScrollView : UIScrollView

- (id) init
{
    self = [super init];
    if(self)
    {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

@end
// 스크롤뷰 커스터마이징
@implementation OMScrollView : UIScrollView
@synthesize scrollType = _scrollType;
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        _scrollType = 0;
    }
    return self;
}
@end
// 상세 오토리사이징 되있는 스크롤뷰
@implementation DetailScrollView : UIScrollView
-(id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self)
    {
        
    }
    return self;
}
- (id) init
{
    self = [super init];
    if(self)
    {
        self.AutoresizingMask = UIViewAutoresizingFlexibleHeight;
    }
    return self;
}
@end

// 추가정보를 담을 수 있는 커스텀 버튼 클래스를 정의한다.
@implementation OMButton

@synthesize additionalInfo = _additionalInfo;

- (id) init
{
    self = [super init];
    [self initComponentMain];
    return self;
}

- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initComponentMain];
    return self;
    
}
- (void) initComponentMain
{
    _additionalInfo = [[NSMutableDictionary alloc] init];
}

@end


// 추가정보를 담을 수 있는 커스텀 컨트롤 클래스를 정의한다.
@implementation OMControl

@synthesize additionalInfo = _additionalInfo;

- (id) init
{
    self = [super init];
    [self initComponentMain];
    return self;
}
- (id) initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    [self initComponentMain];
    return self;
}

- (void) initComponentMain
{
    _additionalInfo = [[NSMutableDictionary alloc] init];
}


@end