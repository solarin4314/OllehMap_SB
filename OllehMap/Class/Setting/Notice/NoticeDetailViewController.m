//
//  NoticeDetailViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 9. 30..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "NoticeDetailViewController.h"

@interface NoticeDetailViewController ()

@end

@implementation NoticeDetailViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _viewStartY = 0;
    
    [self drawTitle];
}
- (void) drawTitle
{
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int viewY = 0;
    // 각 뷰
    UIView *listView = [[UIView alloc] init];
    [listView setFrame:CGRectMake(0, viewY, 320, 63)];
    
    // 뷰 배경
    UIImageView *listBg = [[UIImageView alloc] init];
    [listBg setImage:[UIImage imageNamed:@"notice_list_bg.png"]];
    //[listBg setBackgroundColor:[UIColor redColor]];
    [listBg setFrame:CGRectMake(0, 0, 320, 63)];
    
    // new check
    UIImageView *newImg = [[UIImageView alloc] init];
    [newImg setImage:[UIImage imageNamed:@"notice_new.png"]];
    [newImg setFrame:CGRectMake(0, 0, 29, 29)];
    
    // 번호
    UILabel *seqNo = [[UILabel alloc] init];
    [seqNo setText:[NSString stringWithFormat:@"%@", [oms.noticeDetailDictionary objectForKeyGC:@"SEQNUMBER"]]];
    [seqNo setBackgroundColor:[UIColor clearColor]];
    [seqNo setTextAlignment:NSTextAlignmentCenter];
    [seqNo setFont:[UIFont boldSystemFontOfSize:22]];
    [seqNo setFrame:CGRectMake(0, 0, 58, 63)];
    
    // 날짜
    UILabel *date = [[UILabel alloc] init];
    [date setText:[NSString stringWithFormat:@"%@", [[oms.noticeDetailDictionary objectForKeyGC:@"NOTICEDETAIL"] objectForKeyGC:@"startDate"]]];
    [date setTextColor:[UIColor colorWithRed:25.0/255.0 green:168.0/255.0 blue:199.0/255.0 alpha:1]];
    [date setFont:[UIFont systemFontOfSize:13]];
    [date setFrame:CGRectMake(68, 35, 242, 13)];
    
    // 제목
    UILabel *title = [[UILabel alloc] init];
    [title setText:[NSString stringWithFormat:@"%@", [[oms.noticeDetailDictionary objectForKeyGC:@"NOTICEDETAIL"] objectForKeyGC:@"title"]]];
    [title setFont:[UIFont systemFontOfSize:14]];
    [title setNumberOfLines:2];
    [title setFrame:CGRectMake(68, 15, 242, 14)];
    
    CGSize titleSize = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(FLT_MAX, FLT_MAX)];
    
    if(titleSize.width > 242)
    {
        NSLog(@"오바");
        
        titleSize = [title.text sizeWithFont:title.font constrainedToSize:CGSizeMake(242, FLT_MAX)];
        
        [listView setFrame:CGRectMake(0, viewY, 320, 81)];
        [listBg setFrame:CGRectMake(0, 0, 320, 81)];
        [seqNo setFrame:CGRectMake(0, 0, 58, 81)];
        [date setFrame:CGRectMake(68, 53, 242, 13)];
        [title setFrame:CGRectMake(68, 15, 242, titleSize.height)];
        
        viewY += 81;
    }
    else
    {
        viewY += 63;
    }
    
    [listView addSubview:listBg];
    // 공지상세 들어오면 뱃지 필요없음
    //[listView addSubview:newImg];
    [listView addSubview:seqNo];
    [listView addSubview:title];
    [listView addSubview:date];
    [_noticeDetailScrollView addSubview:listView];
    
    UIImageView *underLine = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"list_line.png"]];
    [underLine setFrame:CGRectMake(0, viewY, 320, 1)];
    
    [_noticeDetailScrollView addSubview:underLine];
    
    viewY += 1;
    
    _viewStartY += viewY;
    
    [self drawContent];
}

- (void) drawContent
{
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    OMWhiteView *contentView = [[OMWhiteView alloc] init];
    
    UILabel *content = [[UILabel alloc] init];
    [content setNumberOfLines:0];
    [content setText:[NSString stringWithFormat:@"%@", [[oms.noticeDetailDictionary objectForKeyGC:@"NOTICEDETAIL"] objectForKeyGC:@"contents"]]];
    [content setFont:[UIFont systemFontOfSize:14]];
    [content setTextColor:[UIColor colorWithRed:139.0/255.0 green:139.0/255.0 blue:139.0/255.0 alpha:1]];
    
    CGSize contentSize = [content.text sizeWithFont:content.font constrainedToSize:CGSizeMake(290, FLT_MAX)];
    
    int contentViewHeight = 15 + contentSize.height + 15;
    
    [content setFrame:CGRectMake(15, 15, 290, contentSize.height)];
    
    [contentView addSubview:content];
    
    [contentView setFrame:CGRectMake(0, _viewStartY, 320, contentViewHeight)];
    
    [_noticeDetailScrollView addSubview:contentView];
    
    _viewStartY += contentViewHeight;
    
    [self drawScrollView];
    
}

- (void) drawScrollView
{
    [_noticeDetailScrollView setFrame:CGRectMake(0, _noticeDetailScrollView.frame.origin.y, 320, self.view.frame.size.height - _noticeDetailScrollView.frame.origin.y)];
    _noticeDetailScrollView.contentSize = CGSizeMake(320, _viewStartY);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)popBtnClick:(id)sender
{
    [[OMNavigationController sharedNavigationController] popViewControllerAnimated:YES];
}
@end
