//
//  RecentSearchViewController.m
//  OllehMap
//
//  Created by 이제민 on 13. 10. 10..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "RecentSearchViewController.h"
#import "MapContainer.h"
#import "MainViewController.h"

@interface RecentCells : UITableViewCell
{
    id _refreshDeleteButtonTarget;
    SEL _refreshDeleteButtonAction;
    
    UIControl *_vwCustomCell;
    UIView *_vwCustomCellBackground;
    UIButton *_btnCheck;
    
    NSMutableDictionary *_currentFavoriteDictionary;
}

- (BOOL) setFavoriteDictionary :(NSMutableDictionary*)favoriteDic;
- (NSMutableDictionary*) getFavoriteDictionary;
- (void) addTargetActionRefreshDeleteButton :(id)target :(SEL)action;
- (void) onCheck :(id)sender;
- (void) onCheckCell :(id)sender;
- (void) renderInCell :(BOOL)isEdting;

@end

@implementation RecentCells

- (id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        RecentCells *cell = self;
        
        _vwCustomCellBackground = [[UIView alloc] initWithFrame:cell.frame];
        [cell setBackgroundView:_vwCustomCellBackground];
        
        // 커스텀 셀 생성
        _vwCustomCell = [[UIControl alloc] initWithFrame:CGRectMake(0, 0, 320, 58)];
        [_vwCustomCell setBackgroundColor:[UIColor clearColor]];
        [_vwCustomCell setUserInteractionEnabled:NO];
        [_vwCustomCell addTarget:self action:@selector(onCheckCell:) forControlEvents:UIControlEventTouchUpInside];
        
        // 커스텀 셀 덧씌우기
        [cell addSubview:_vwCustomCell];
        
        // 체크버튼
        _btnCheck = [[UIButton alloc] initWithFrame:CGRectMake(10, 17, 25, 25)];
        [_btnCheck setImage:[UIImage imageNamed:@"search_favorite_icon_default.png"] forState:UIControlStateNormal];
        [_btnCheck setImage:[UIImage imageNamed:@"search_favorite_icon_pressed.png"] forState:UIControlStateSelected];
        [_btnCheck setHidden:YES];
        
        if ( [reuseIdentifier isEqualToString:@"DeleteCell"] )
            [_btnCheck setSelected:YES];
        else
            [_btnCheck setSelected:NO];
        [_btnCheck addTarget:self action:@selector(onCheck:) forControlEvents:UIControlEventTouchUpInside];
        [cell addSubview:_btnCheck];
    }
    
    return self;
}


- (BOOL) setFavoriteDictionary:(NSMutableDictionary *)favoriteDic
{
    _currentFavoriteDictionary = favoriteDic;
    
    [self renderInCell:!_btnCheck.isHidden];
    
    return YES;
}

- (NSMutableDictionary*) getFavoriteDictionary
{
    return _currentFavoriteDictionary;
}


- (void) addTargetActionRefreshDeleteButton :(id)target :(SEL)action;
{
    _refreshDeleteButtonTarget = target;
    _refreshDeleteButtonAction = action;
}

- (void) willTransitionToState:(UITableViewCellStateMask)state
{
    [super willTransitionToState:state];
    
    if (state & UITableViewCellStateShowingEditControlMask)
    {
        // 체크버튼 보이기
        [_btnCheck setHidden:NO];
        // 셀 유저인터렉션 활성화
        [_vwCustomCell setUserInteractionEnabled:YES];
        
        // 체크되어 있는 경우 배경 설정
        if (_btnCheck.selected)
            [_vwCustomCellBackground setBackgroundColor:convertHexToDecimalRGBA(@"D9", @"F4", @"FF", 1.0f)];
        else
            [_vwCustomCellBackground setBackgroundColor:[UIColor whiteColor]];
    }
    else
    {
        // 체크버트 숨기기
        [_btnCheck setHidden:YES];
        // 셀 유저인터렉션 비활성화
        [_vwCustomCell setUserInteractionEnabled:NO];
    }
    
    
    [self renderInCell:(state & UITableViewCellStateShowingEditControlMask)];
}

- (void) onCheck :(id)sender
{
    UIButton *btn = (UIButton*)sender;
    [btn setSelected:!btn.selected];
    
    if (btn.selected) [_vwCustomCellBackground setBackgroundColor:convertHexToDecimalRGBA(@"D9", @"F4", @"FF", 1.0f)];
    else [_vwCustomCellBackground setBackgroundColor:[UIColor whiteColor]];
    
    NSNumber *selected = [NSNumber numberWithBool:btn.selected];
    [_currentFavoriteDictionary setObject:selected forKey:@"DeleteChecked"];
    
    
    if ([_refreshDeleteButtonTarget respondsToSelector:_refreshDeleteButtonAction])
        objc_msgSend(_refreshDeleteButtonTarget, _refreshDeleteButtonAction, self);
    //[_refreshDeleteButtonTarget performSelector:_refreshDeleteButtonAction withObject:self];
    
}

- (void) onCheckCell:(id)sender
{
    [self performSelector:@selector(onCheck:) withObject:_btnCheck];
}

- (void) renderInCell :(BOOL)isEdting
{
    // 기존 인셀 클리어
    for (UIView *subview in _vwCustomCell.subviews)
    {
        [subview removeFromSuperview];
    }
    
    int category = [[_currentFavoriteDictionary objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"] ? 1 : 0;
    int iconType = [[_currentFavoriteDictionary objectForKeyGC:@"ICONTYPE"] intValue];
    
    float edgeLeftPoint = 0.0f;
    if (_btnCheck.isHidden == NO) edgeLeftPoint = 10.0f + 25.0f;
    
    // 아이콘
    UIImage *iconImage = getFavoritImage(iconType);
    
    switch (category)
    {
            // 장소/주소 카테고리
        case 0:
        {
            // 아이콘
            UIImageView *imgvwIcon = [[UIImageView alloc] initWithImage:iconImage];
            [imgvwIcon setFrame:CGRectMake(edgeLeftPoint+9, 11 , iconImage.size.width, iconImage.size.height)];
            [_vwCustomCell addSubview:imgvwIcon];
            
            NSString *title1 = [_currentFavoriteDictionary objectForKeyGC:@"NAME"];
            NSString *title2 = [_currentFavoriteDictionary objectForKeyGC:@"CLASSIFY"];
            
            if ([title2 length] > 0)
            {
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+41, 11, 458/2, 16)];
                [lblTitle setFont:[UIFont systemFontOfSize:15]];
                [lblTitle setLineBreakMode:NSLineBreakByTruncatingTail];
                [lblTitle setBackgroundColor:[UIColor clearColor]];
                [lblTitle setText:title1];
                //rectLabel.size = [lblStart.text sizeWithFont:lblStart.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblStart.lineBreakMode];
                //[lblStart setFrame:rectLabel];
                [_vwCustomCell addSubview:lblTitle];
                
                UILabel *lblTitle2 = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+41, 33, 458/2, 13)];
                [lblTitle2 setFont:[UIFont systemFontOfSize:13]];
                [lblTitle2 setLineBreakMode:NSLineBreakByTruncatingTail];
                [lblTitle2 setBackgroundColor:[UIColor clearColor]];
                [lblTitle2 setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
                [lblTitle2 setText:title2];
                //rectLabel.size = [lblStart.text sizeWithFont:lblStart.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblStart.lineBreakMode];
                //[lblStart setFrame:rectLabel];
                [_vwCustomCell addSubview:lblTitle2];
                
            }
            else
            {
                UILabel *lblTitle = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+41, 21, 458/2, 15)];
                [lblTitle setFont:[UIFont systemFontOfSize:15]];
                [lblTitle setLineBreakMode:NSLineBreakByTruncatingTail];
                [lblTitle setBackgroundColor:[UIColor clearColor]];
                [lblTitle setText:title1];
                //rectLabel.size = [lblStart.text sizeWithFont:lblStart.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblStart.lineBreakMode];
                //[lblStart setFrame:rectLabel];
                [_vwCustomCell addSubview:lblTitle];
                
            }
            
            break;
        }
            
            // 경로 카테고리 셀 렌더링
        case 1:
        {
            // 아이콘
            UIImageView *imgvwIcon = [[UIImageView alloc] initWithImage:iconImage];
            [imgvwIcon setFrame:CGRectMake(edgeLeftPoint+9, 11, iconImage.size.width, iconImage.size.height)];
            [_vwCustomCell addSubview:imgvwIcon];
            
            
            float labelTopPoint = 11.0f;
            float labelDescTopPoint = 14.0f;
            
            CGRect rectLabel = CGRectZero;
            
            // 출발지
            rectLabel = CGRectMake(edgeLeftPoint+41, labelTopPoint, 30, 15);
            UILabel *lblStart = [[UILabel alloc] initWithFrame:rectLabel];
            [lblStart setFont:[UIFont systemFontOfSize:15]];
            [lblStart setLineBreakMode:NSLineBreakByClipping];
            [lblStart setBackgroundColor:[UIColor clearColor]];
            [lblStart setText:@"출발"];
            rectLabel.size = [lblStart.text sizeWithFont:lblStart.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblStart.lineBreakMode];
            [lblStart setFrame:rectLabel];
            [_vwCustomCell addSubview:lblStart];
            
            UILabel *lblStartDesc = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+78, labelDescTopPoint, 192-edgeLeftPoint, 13)];
            [lblStartDesc setFont:[UIFont systemFontOfSize:13]];
            [lblStartDesc setBackgroundColor:[UIColor clearColor]];
            [lblStartDesc setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
            [lblStartDesc setText:[NSString stringWithFormat:@"%@", [_currentFavoriteDictionary objectForKeyGC:@"START_NAME"]]];
            [_vwCustomCell addSubview:lblStartDesc];
            
            
            // 경유지 존재시
            if ([[_currentFavoriteDictionary objectForKeyGC:@"Coord3x"] doubleValue] > 0 && [[_currentFavoriteDictionary objectForKeyGC:@"Coord3y"] doubleValue] > 0)
            {
                labelTopPoint += 20;
                labelDescTopPoint += 20;
                rectLabel = CGRectMake(edgeLeftPoint+41, labelTopPoint, 30, 15);
                UILabel *lblVisit = [[UILabel alloc] initWithFrame:rectLabel];
                [lblVisit setFont:[UIFont systemFontOfSize:15]];
                [lblVisit setLineBreakMode:NSLineBreakByClipping];
                [lblVisit setBackgroundColor:[UIColor clearColor]];
                [lblVisit setText:@"경유"];
                rectLabel.size = [lblVisit.text sizeWithFont:lblVisit.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblVisit.lineBreakMode];
                [lblVisit setFrame:rectLabel];
                [_vwCustomCell addSubview:lblVisit];
                
                UILabel *lblVisitDesc = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+78, labelDescTopPoint, 192-edgeLeftPoint, 13)];
                [lblVisitDesc setFont:[UIFont systemFontOfSize:13]];
                [lblVisitDesc setBackgroundColor:[UIColor clearColor]];
                [lblVisitDesc setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
                [lblVisitDesc setText:[NSString stringWithFormat:@"%@", [_currentFavoriteDictionary objectForKeyGC:@"VISIT_NAME"]]];
                [_vwCustomCell addSubview:lblVisitDesc];
                
            }
            
            // 도착
            labelTopPoint += 20;
            labelDescTopPoint += 20;
            rectLabel = CGRectMake(edgeLeftPoint+41, labelTopPoint, 30, 15);
            UILabel *lblDest = [[UILabel alloc] initWithFrame:rectLabel];
            [lblDest setFont:[UIFont systemFontOfSize:15]];
            [lblDest setLineBreakMode:NSLineBreakByClipping];
            [lblDest setBackgroundColor:[UIColor clearColor]];
            [lblDest setText:@"도착"];
            rectLabel.size = [lblDest.text sizeWithFont:lblDest.font constrainedToSize:CGSizeMake(FLT_MAX, 15) lineBreakMode:lblDest.lineBreakMode];
            [lblDest setFrame:rectLabel];
            [_vwCustomCell addSubview:lblDest];
            
            UILabel *lblDestDesc = [[UILabel alloc] initWithFrame:CGRectMake(edgeLeftPoint+78, labelDescTopPoint, 192-edgeLeftPoint, 13)];
            [lblDestDesc setFont:[UIFont systemFontOfSize:13]];
            [lblDestDesc setBackgroundColor:[UIColor clearColor]];
            [lblDestDesc setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
            [lblDestDesc setText:[NSString stringWithFormat:@"%@", [_currentFavoriteDictionary objectForKeyGC:@"STOP_NAME"]]];
            [_vwCustomCell addSubview:lblDestDesc];
            
            
            
            break;
        }
            default:
            break;
            
    }
    
}

@end

@interface RecentSearchViewController ()

@end

@implementation RecentSearchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
- (void) viewDidAppear:(BOOL)animated
{
    //[_editBtn setEnabled: [[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] > 0 ];
    //[_recentTableView reloadData];
}
- (void)viewWillAppear:(BOOL)animated
{
    
    if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0)
    {
        [_recentTableView setHidden:YES];
        
        _nullView = [[UIView alloc] init];
        
        [_nullView setFrame:CGRectMake(0, 37 + OM_STARTY, 320, self.view.frame.size.height - (37 + OM_STARTY))];
        
        [_nullView setBackgroundColor:convertHexToDecimalRGBA(@"F2", @"F2", @"F2", 1.0f)];
        _nullLbl = [[UILabel alloc] init];
        [_nullLbl setText:@"저장된 목록이 없습니다."];
        [_nullLbl setBackgroundColor:[UIColor clearColor]];
        [_nullLbl setTextAlignment:NSTextAlignmentCenter];
        [_nullLbl setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
        [_nullLbl setFont:[UIFont systemFontOfSize:15]];
        [_nullLbl setFrame:CGRectMake(0, 202, 320, 15)];
        
        [_nullView addSubview:_nullLbl];
        
        [self.view addSubview:_nullView];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self initer];
}
- (void) initer
{
    // 즐겨찾기 컨테이너 초기화
    [_vwFavoriteContainer setFrame:CGRectMake(0, OM_STARTY + 37,
                                                     [[UIScreen mainScreen] bounds].size.width,
                                                     self.view.frame.size.height - (OM_STARTY + 37))];
    [_vwFavoriteContainer setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [_vwFavoriteContainer setBackgroundColor:[UIColor redColor]];
    
    _editView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 57)];
    
    UIImageView *editBg = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bottom_bg.png"]];
    [editBg setFrame:CGRectMake(0, 0, 320, 57)];
    [_editView addSubview:editBg];
    
    _allSelectBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_allSelectBtn setImage:[UIImage imageNamed:@"bottom_btn.png"] forState:UIControlStateNormal];
    [_allSelectBtn setFrame:CGRectMake(7, 11, 151, 37)];
    [_allSelectBtn addTarget:self action:@selector(allSelecetBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:_allSelectBtn];
    
    _allSelectLabel = [[UILabel alloc] initWithFrame:CGRectMake(15, 23, 135, 14)];
    [_allSelectLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_allSelectLabel setBackgroundColor:[UIColor clearColor]];
    [_allSelectLabel setTextAlignment:NSTextAlignmentCenter];
    [_allSelectLabel setText:@"전체선택"];
    [_editView addSubview:_allSelectLabel];
    
    _deleteBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [_deleteBtn setImage:[UIImage imageNamed:@"bottom_btn.png"] forState:UIControlStateNormal];
    [_deleteBtn setFrame:CGRectMake(162, 11, 151, 37)];
    [_deleteBtn addTarget:self action:@selector(deleteBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [_editView addSubview:_deleteBtn];
    
    _deleteLabel = [[UILabel alloc] initWithFrame:CGRectMake(170, 23, 135, 14)];
    [_deleteLabel setFont:[UIFont boldSystemFontOfSize:14]];
    [_deleteLabel setBackgroundColor:[UIColor clearColor]];
    [_deleteLabel setTextAlignment:NSTextAlignmentCenter];
    [_deleteLabel setText:@"삭제 (0)"];
    [_editView addSubview:_deleteLabel];
    
    [_recentTableView setFrame:CGRectMake(0, 0, 320, _vwFavoriteContainer.frame.size.height)];
    
    
}
#pragma mark -
#pragma mark - 테이블뷰
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
    
    if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
    {
        if( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
        {
            return 78;
        }
        
    }
    
    return 58;
}
- (NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    return [[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *CellIdentifier = @"CellIdentifier";
    
    // 세퍼레이터 설정
    tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    tableView.separatorColor = [UIColor colorWithRed:220.0/255.0 green:220.0/255.0 blue:220.0/255.0 alpha:1];
    
    NSMutableDictionary *dic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
    
    NSString *identifier = nil;
    if ( [[dic objectForKeyGC:@"DeleteChecked"] boolValue] )
        identifier = @"DeleteCell";
    else
        identifier = @"NormalCell";
    
    RecentCells *cell = [[RecentCells alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifier];
    //[cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    if( [identifier isEqualToString:@"NormalCell"] )
    {
        UIImageView *selectedBackgroundView = [[UIImageView alloc] init];
        [selectedBackgroundView setBackgroundColor:convertHexToDecimalRGBA(@"d9", @"f4", @"ff", 1)];
        cell.selectedBackgroundView = selectedBackgroundView;
        
        
//        // 설정에서 들어왔을 경우 하이라이트 해제
//        OMNavigationController *nc = [OMNavigationController sharedNavigationController];
//        
//        UIViewController *vc = [nc.viewControllers objectAtIndexGC:nc.viewControllers.count-2];
//        //if ( [vc isKindOfClass:[SettingViewController2 class]] ) [cell  setSelectionStyle:UITableViewCellSelectionStyleNone];
//        
//        if ( [vc isKindOfClass:[SettingViewController class]] ) [cell  setSelectionStyle:UITableViewCellSelectionStyleNone];
    }
    
    // 콜백등록 (삭제 체크)
    [cell addTargetActionRefreshDeleteButton:self :@selector(onRefreshDeleteButtonText:)];
    
    // 즐겨찾기 정보 설정
    [cell setFavoriteDictionary:dic];
    
    return cell;

    
    ///////////---------------////////////////////
    recentCell2 *ccell = (recentCell2 *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    
    if( ccell == nil )
    {
        NSBundle *nbd = [NSBundle mainBundle];
        NSArray *nib = [nbd loadNibNamed:@"recentCell2" owner:self options:nil];
        for (id oneObject in nib) {
            if([oneObject isKindOfClass:[recentCell2 class]])
                ccell = (recentCell2 *)oneObject;
        }
    }
    
    
    
    NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
    //
    int iconType = [[rdic objectForKeyGC:@"ICONTYPE"] intValue];
    
    UIImage *iconImage = nil;
    if ( iconType == Favorite_IconType_BusStop )
        iconImage = [UIImage imageNamed:@"list_b_marker_busstop.png"];
    else if ( iconType == Favorite_IconType_CCTV )
        iconImage = [UIImage imageNamed:@"list_b_marker_cctv.png"];
    else if ( iconType == Favorite_IconType_Course )
        iconImage = [UIImage imageNamed:@"list_b_marker_course.png"];
    else if ( iconType == Favorite_IconType_None )
        iconImage = [UIImage imageNamed:@"list_b_marker.png"];
    else if ( iconType == Favorite_IconType_POI )
        iconImage = [UIImage imageNamed:@"list_b_marker_poi.png"];
    else if ( iconType == Favorite_IconType_Subway )
        iconImage = [UIImage imageNamed:@"list_b_marker_subway.png"];
    else
        iconImage = [UIImage imageNamed:[NSString stringWithFormat:@"info_icon_%02d", iconType]];
    
    ccell.poiImage.image = iconImage;
    
    CGRect iconRect = ccell.poiImage.frame;
    
    iconRect.size = iconImage.size;
    iconRect.origin = CGPointMake(9, 12);
    
    [ccell.poiImage setFrame:iconRect];
    //
    if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"TR_BUSNO"])
    {
        [ccell.poiImage setFrame:CGRectMake(6, 12, 29, 18)];
    }
    
    if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
    {
        
        [ccell.placeName setHidden:YES];
        [ccell.classification setHidden:YES];
        
        [ccell.startLbl setHidden:NO];
        
        [ccell.destLbl setHidden:NO];
        
        [ccell.startContent setHidden:NO];
        
        [ccell.destContent setHidden:NO];
        
        ccell.startContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"START_NAME"]];
        
        ccell.destContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"STOP_NAME"]];
        
        [ccell.destLbl setFrame:CGRectMake(41, 31, 28, 15)];
        [ccell.destContent setFrame:CGRectMake(78, 32, 192, 13)];
        
        
        
        // 경유지 있나 판단
        if( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
        {
            [ccell.visitLbl setHidden:NO];
            [ccell.visitContent setHidden:NO];
            ccell.visitContent.text = [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"VISIT_NAME"]];
            
            [ccell.destLbl setFrame:CGRectMake(41, 51, 28, 15)];
            [ccell.destContent setFrame:CGRectMake(78, 52, 192, 13)];
            
            [ccell.radioBtn setImage:[UIImage imageNamed:@"search_edit_list_pressed_01.png"] forState:UIControlStateSelected];
        }
        
        
    }
    else
    {
        NSString *subName = [rdic objectForKeyGC:@"SUBNAME"];
        NSLog(@"subName : %@", subName);
        
        if(subName == nil)
        {
            ccell.placeName.text = [rdic objectForKeyGC:@"NAME"];
        }
        else
        {
            ccell.placeName.text = [NSString stringWithFormat:@"%@%@", [rdic objectForKeyGC:@"NAME"], [rdic objectForKeyGC:@"SUBNAME"]];
        }
        
        NSString *classify = stringValueOfDictionary(rdic, @"CLASSIFY");
        //[rdic objectForKeyGC:@"CLASSIFY"];
        
        if([classify isEqualToString:@""])
        {
            [ccell.placeName setFrame:CGRectMake(41, 21, 229, 15)];
            [ccell.classification setHidden:YES];
        }
        else
        {
            
            
            ccell.classification.text = classify;
            
        }
        
        
        //ccell.classification.text = [rdic objectForKeyGC:@"CLASSIFY"];
        [ccell.radioBtn setHidden:YES];
        
    }
    
    if(tableView.isEditing)
    {
        
        [self cellDrawEdit:ccell tableView:tableView cellForRowAtIndexPath:indexPath];
        
        
    }
    
    [ccell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return ccell;
    
    
}
- (void) onRefreshDeleteButtonText:(id)sender
{
    int selectedCount = 0;
    for (NSDictionary *dic in [[OllehMapStatus sharedOllehMapStatus] getRecentSearchList])
    {
        if ( [[dic objectForKeyGC:@"DeleteChecked"] boolValue] )
        {
            selectedCount++;
        }
    }
    
    [_deleteLabel setText:[NSString stringWithFormat:@"삭제 (%d)", selectedCount]];
    
    if(selectedCount > 0)
    {
        [_deleteLabel setTextColor:[UIColor blackColor]];
    }
    else
    {
        [_deleteLabel setTextColor:convertHexToDecimalRGBA(@"9c", @"9c", @"9c", 1.0)];
    }
    
    if (selectedCount == [OllehMapStatus sharedOllehMapStatus].getRecentSearchCount)
    {
        [_allSelectBtn setSelected:YES];
        [_allSelectLabel setText:@"전체해제"];
    }
    else
    {
        [_allSelectLabel setText:@"전체선택"];
        [_allSelectBtn setSelected:NO];
    }
}

// 편집 테이블 그리기
- (void)cellDrawEdit:(recentCell2 *)ccell tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
    
    [ccell.poiImage setFrame:CGRectMake(44, 11, 23, 34)];
    
    if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"TR_BUSNO"])
    {
        [ccell.poiImage setFrame:CGRectMake(41, 12, 29, 18)];
    }
    
    
    
    // 넓이바꿈
    [ccell.placeName setFrame:CGRectMake(76, 11, 235, 15)];
    [ccell.classification setFrame:CGRectMake(76, 33, 235, 13)];
    [ccell.radioBtn setHidden:NO];
    
    
    
    NSString *classify = [rdic objectForKeyGC:@"CLASSIFY"];
    
    if([classify isEqualToString:@""])
    {
        [ccell.placeName setFrame:CGRectMake(76, 21, 235, 15)];
        [ccell.classification setHidden:YES];
    }
    else
    {
        
        
        ccell.classification.text = classify;
        
    }
    
    
    //ccell.startLbl   41 / 78   // 31
    //ccell.startContent 233
    CGRect rect;
    
    rect = ccell.startLbl.frame;
    rect.origin.x = 76;
    ccell.startLbl.frame = rect;
    
    rect = ccell.startContent.frame;
    rect.origin.x = ccell.startLbl.frame.origin.x + 31;
    rect.size.width = 233-31;
    ccell.startContent.frame = rect;
    
    rect = ccell.visitLbl.frame;
    rect.origin.x = 76;
    ccell.visitLbl.frame = rect;
    
    rect = ccell.visitContent.frame;
    rect.origin.x = ccell.visitLbl.frame.origin.x + 31;
    rect.size.width = 233-31;
    ccell.visitContent.frame = rect;
    
    rect = ccell.destLbl.frame;
    rect.origin.x = 76;
    ccell.destLbl.frame = rect;
    
    rect = ccell.destContent.frame;
    rect.origin.x = ccell.destLbl.frame.origin.x + 31;
    rect.size.width = 233-31;
    ccell.destContent.frame = rect;
    
    
    
    
    
    
    
    
    NSMutableArray *list = [[OllehMapStatus sharedOllehMapStatus] getRecentSearchList];
    
    NSMutableDictionary *dic = [list objectAtIndexGC:indexPath.row];
    
    if([[dic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"] && ![[dic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""])
    {
        [ccell.radioBtn setFrame:CGRectMake(0, 0, 320, 78)];
        [ccell.radioBtn setImage:[UIImage imageNamed:@"search_edit_list_default_01.png"] forState:UIControlStateNormal];
    }
    
    NSNumber *checkDelete = [dic objectForKeyGC:@"CheckDelete"];
    
    [ccell.radioBtn setSelected:[checkDelete boolValue]];
    
    [ccell.radioBtn setTag:indexPath.row];
    
    
    
    [ccell.radioBtn addTarget:self action:@selector(editCellSelected:) forControlEvents:UIControlEventTouchUpInside];
    
}
// 테이블선택
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    	
    // MIK.geun :: 20121116 // 설정에서 즐겨찾기 진입한 경우 렌더링방식이 달라짐
    // 설정에서 들어온 즐겨찾기는 결과화면 지도로 이동하지 않는다.
    //OMNavigationController *nc = [OMNavigationController sharedNavigationController];
    //UIViewController *vc = [nc.viewControllers objectAtIndexGC:nc.viewControllers.count-2];
    // 설정화면 즐겨찾기 여부
    //BOOL isSettingRecent = [vc isKindOfClass:[SettingViewController2 class]];
    
    //BOOL isSettingRecent = [vc isKindOfClass:[SettingViewController class]];
    
    [_recentTableView deselectRowAtIndexPath:indexPath animated:NO];
    
    // 최근검색 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/local_search/recent_POI"];
    NSDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:indexPath.row];
    
    
    NSLog(@"%d, rdic : %@", (int)indexPath.row, rdic);
    if([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"TR_BUSNO"])
    {
        
        NSLog(@"버스다, %@", [rdic objectForKeyGC:@"ID"]);
        [_recentTableView deselectRowAtIndexPath:indexPath animated:NO];
        
        [[ServerConnector sharedServerConnection] requestBusNumberInfo:self action:@selector(didFinishRequestBusNumDetail:) laneId:[rdic objectForKeyGC:@"ID"]];
        
    }
    else if ([[rdic objectForKeyGC:@"TYPE"] isEqualToString:@"ROUTE"])
    {
        // 길찾기 데이터 채우기
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        // 출발지
        [oms.searchResultRouteStart reset];
        [oms.searchResultRouteStart setUsed:YES];
        [oms.searchResultRouteStart setIsCurrentLocation:NO];
        [oms.searchResultRouteStart setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"START_NAME"]]];
        [oms.searchResultRouteStart setStrLocationAddress:@""];
        [oms.searchResultRouteStart setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"START_X"] doubleValue] , [[rdic objectForKeyGC:@"START_Y"] doubleValue] ) ];
        // 경유지
        [oms.searchResultRouteVisit reset];
        if ( ![[rdic objectForKeyGC:@"VISIT_NAME"] isEqualToString:@""] )
        {
            [oms.searchResultRouteVisit setUsed:YES];
            [oms.searchResultRouteVisit setIsCurrentLocation:NO];
            [oms.searchResultRouteVisit setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"VISIT_NAME"]]];
            [oms.searchResultRouteVisit setStrLocationAddress:@""];
            [oms.searchResultRouteVisit setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"VISIT_X"] doubleValue] , [[rdic objectForKeyGC:@"VISIT_Y"] doubleValue] ) ];
        }
        // 도착지
        [oms.searchResultRouteDest reset];
        [oms.searchResultRouteDest setUsed:YES];
        [oms.searchResultRouteDest setIsCurrentLocation:NO];
        [oms.searchResultRouteDest setStrLocationName: [NSString stringWithFormat:@"%@", [rdic objectForKeyGC:@"STOP_NAME"]]];
        [oms.searchResultRouteDest setStrLocationAddress:@""];
        [oms.searchResultRouteDest setCoordLocationPoint:CoordMake( [[rdic objectForKeyGC:@"STOP_X"] doubleValue] , [[rdic objectForKeyGC:@"STOP_Y"] doubleValue] ) ];
        
        // 길찾기 검색전 기존 검색 데이터 클리어
        [[OllehMapStatus sharedOllehMapStatus].searchRouteData reset];
        
        // 길찾기 시도
        [[SearchRouteExecuter sharedSearchRouteExecuter] searchRoute_Car:SearchRoute_Car_SearchType_RealTime];
        
    }
    else
    {
        
        
        
        NSString *name = [rdic objectForKeyGC:@"NAME"];
        NSString *add = [rdic objectForKeyGC:@"ADDR"];
        //NSString *classify = [rdic objectForKeyGC:@"CLASSIFY"];
        NSNumber *xx = [rdic objectForKeyGC:@"X"];
        NSNumber *yy = [rdic objectForKeyGC:@"Y"];
        NSString *type = [rdic objectForKeyGC:@"TYPE"];
        NSString *detailid = [rdic objectForKeyGC:@"ID"];
        NSString *tel = stringValueOfDictionary(rdic, @"TEL");
        NSString *free = stringValueOfDictionary(rdic, @"FREE");
        //[rdic objectForKeyGC:@"FREE"];
        NSString *subName = stringValueOfDictionary(rdic, @"SUBNAME");
        NSString *newAddName = stringValueOfDictionary(rdic, @"NEWADDRESS");
        
        NSString *oldOrNew = stringValueOfDictionary(rdic, @"OLDORNEW");
        
        NSString *shapeType = stringValueOfDictionary(rdic, @"SHAPE_TYPE");
        NSString *fcNm = stringValueOfDictionary(rdic, @"FCNM");
        NSString *idBgm = stringValueOfDictionary(rdic, @"ID_BGM");
        NSString *rdcd = stringValueOfDictionary(rdic, @"RD_CD");
        
        //if(!free)
        //free = [NSString stringWithFormat:@""];
        
        
        double x = [xx doubleValue];
        double y = [yy doubleValue];

        [_recentTableView deselectRowAtIndexPath:indexPath animated:YES];
        
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        [oms.searchResult reset]; // 검색결과 리셋
        [oms.searchResult setUsed:YES];
        [oms.searchResult setIsCurrentLocation:NO];
        [oms.searchResult setStrLocationName:[NSString stringWithFormat:@"%@%@", name, subName]];
        [oms.searchResult setStrLocationRoadName:rdcd];
        [oms.searchResult setStrShape:shapeType];
        [oms.searchResult setStrShapeFcNm:fcNm];
        [oms.searchResult setStrShapeIdBgm:idBgm];
        
        if([type isEqualToString:@"ADDR"])
        {
            [oms.searchResult setStrLocationAddress:name];
            [oms.searchResult setStrLocationSubAddress:newAddName];
            [oms.searchResult setStrLocationOldOrNew:oldOrNew];
        }
        else
        {
            [oms.searchResult setStrLocationAddress:add];
            [oms.searchResult setStrLocationSubAddress:newAddName];
            [oms.searchResult setStrLocationOldOrNew:oldOrNew];
        }
        
        [oms.searchResult setStrType:type];
        [oms.searchResult setStrID:detailid];
        [oms.searchResult setStrTel:tel];
        //[oms.searchResult setStrSTheme:free];
        
        [oms.searchResult setCoordLocationPoint:CoordMake(x, y)];
        
        [oms.searchResult setStrSTheme:free];
        [oms.searchLocalDictionary setObject:free forKey:@"LastExtendFreeCall"];
        
        //        if ( !isSettingRecent )
        //        {
        //            MainViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
        //            main.nMapRenderType = MapRenderType_SearchResult_SinglePOI;
        //            main.nMapRenderSinglePOICategory = MainMap_SinglePOI_Type_Recent;
        //            [[OMNavigationController sharedNavigationController] pushViewController:main animated:YES];
        //        }
        
        
        if(![rdcd isEqualToString:@""])
        {
            [[ServerConnector sharedServerConnection] requestRoadNameSearch:self action:@selector(SearchFinishedRoadNameInfo:) roadCode:rdcd];
        }
        else if([shapeType isEqualToString:@""] || [fcNm isEqualToString:@""] || [idBgm isEqualToString:@""])
        {
//            MainViewController *main = [self.storyboard instantiateViewControllerWithIdentifier:@"MainView"];
//            main.nMapRenderType = MapRenderType_SearchResult_SinglePOI;
//            main.nMapRenderSinglePOICategory = MainMap_SinglePOI_Type_Recent;
//            [[OMNavigationController sharedNavigationController] pushViewController:main animated:YES];
            
            // 클래스메서드 적용
            [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:YES];
            
            //                [[OMNavigationController sharedNavigationController] popToRootViewControllerAnimated:NO];
            //                MainViewController *mmvc = (MainViewController*)[[OMNavigationController sharedNavigationController].viewControllers lastObject];
            //
            //                [mmvc toggleMyLocationMode:MapLocationMode_None];
            //                [mmvc pinRecentPOIOverlay:YES];
            //                NSArray *allOverlays = [MapContainer sharedMapContainer_Main].kmap.getOverlays;
            //                for (Overlay *overlay in allOverlays)
            //                {
            //                    if ( [overlay isKindOfClass:[OMImageOverlayRecent class]] )
            //                    {
            //                        [((OMImageOverlayRecent*)overlay).additionalInfo setObject:[NSNumber numberWithBool:YES] forKey:@"LongtapClose"];
            //                        break;
            //                    }
            //                }
        }
        
        else
        {
            [[ServerConnector sharedServerConnection] requestPolygonSearch:self action:@selector(SearchfinishedPolygonInfo:) table:fcNm loadKey:idBgm];
        }
        
        
    }
}
- (void) SearchfinishedPolygonInfo:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        if([(NSMutableDictionary *)[[OllehMapStatus sharedOllehMapStatus].linePolygonDictionary objectForKeyGC:@"LinePolygon"] count] == 0)
        {
            [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:YES];
        }
        else
        {
            [MainViewController markingLinePolygonPOI];
        }
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}
- (void) SearchFinishedRoadNameInfo:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        if([(NSMutableDictionary *)[[OllehMapStatus sharedOllehMapStatus].roadNameDictionary objectForKeyGC:@"RoadCode"] count] == 0)
        {
            [MainViewController markingSinglePOI_RenderType:MapRenderType_SearchResult_SinglePOI category:MainMap_SinglePOI_Type_Recent animated:YES];
        }
        else
        {
            [MainViewController markingRoadCodeSearch];
        }
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_SearchFailedWithException", @"")];
    }
}

//
- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
// 에딧하는 동안 앞에 딜리트 인서트버튼
- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

#pragma mark -
#pragma mark - 액션들
- (IBAction)popBtnClick:(id)sender
{
    if(_recentTableView.isEditing)
    {
        
        [[OllehMapStatus sharedOllehMapStatus] completeRecenSearchEdting:NO];
        
        [_editBtn setImage:[UIImage imageNamed:@"title_bt_edit.png"] forState:UIControlStateNormal];
        [_prevBtn setImage:[UIImage imageNamed:@"title_bt_before.png"] forState:UIControlStateNormal];
        
        
        [_editView removeFromSuperview];
        //[_btnView removeFromSuperview];
        
        [_recentTableView setFrame:CGRectMake(0, 0, 320, _vwFavoriteContainer.frame.size.height)];
        [_recentTableView setEditing:NO animated:NO];
        [_recentTableView reloadData];
    }
    else
    {
        [[OMNavigationController sharedNavigationController] popViewControllerAnimated:NO];
    }
    
}

- (IBAction)editBtnClick:(id)sender
{
    
    if([_recentTableView isEditing])
    {
        [[OllehMapStatus sharedOllehMapStatus] completeRecenSearchEdting:YES];
        [_editBtn setEnabled: [[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] > 0 ];
        
        [_prevBtn setImage:[UIImage imageNamed:@"title_bt_before.png"] forState:UIControlStateNormal];
        
        [_editBtn setImage:[UIImage imageNamed:@"title_bt_edit.png"] forState:UIControlStateNormal];
        
        [_editView removeFromSuperview];
        //[_btnView removeFromSuperview];
        
        [_recentTableView setFrame:CGRectMake(0, 0, 320, _vwFavoriteContainer.frame.size.height)];
        [_recentTableView setEditing:NO animated:NO];
        [_recentTableView reloadData];
        
        if([[OllehMapStatus sharedOllehMapStatus] getRecentSearchCount] == 0)
        {
            [_recentTableView setHidden:YES];
            
            _nullView = [[UIView alloc] init];
            
            [_nullView setFrame:CGRectMake(0, OM_STARTY + 37, 320, self.view.frame.size.height - (OM_STARTY + 37))];
            
            [_nullView setBackgroundColor:convertHexToDecimalRGBA(@"F2", @"F2", @"F2", 1.0f)];
            _nullLbl = [[UILabel alloc] init];
            [_nullLbl setText:@"저장된 목록이 없습니다."];
            [_nullLbl setBackgroundColor:[UIColor clearColor]];
            [_nullLbl setTextAlignment:NSTextAlignmentCenter];
            [_nullLbl setTextColor:convertHexToDecimalRGBA(@"8B", @"8B", @"8B", 1.0f)];
            [_nullLbl setFont:[UIFont systemFontOfSize:15]];
            [_nullLbl setFrame:CGRectMake(0, 202, 320, 15)];
            
            [_nullView addSubview:_nullLbl];
            
            [self.view addSubview:_nullView];
        }
        
    }
    
    else
    {
        [_prevBtn setImage:[UIImage imageNamed:@"title_bt_cancel.png"] forState:UIControlStateNormal];
        
        [_editBtn setImage:[UIImage imageNamed:@"title_btn_finish.png"] forState:UIControlStateNormal];
        
        [self editViewReset];
        
        [_editView setFrame:CGRectMake(0, self.view.frame.size.height - 57, 320, 57)];
        [self.view addSubview:_editView];
        
        [_recentTableView setFrame:CGRectMake(0, 0, 320, _vwFavoriteContainer.frame.size.height - 57)];
        [_recentTableView setEditing:YES animated:NO];
        [_recentTableView reloadData];
        
    }
}
- (void) editViewReset
{
    // 전체 삭제체크
    for (NSMutableDictionary *dic in [[OllehMapStatus sharedOllehMapStatus] getRecentSearchList])
    {
        [dic setObject:[NSNumber numberWithBool:NO] forKey:@"DeleteChecked"];
    }
    
    [self onRefreshDeleteButtonText:nil];
    
    // 카테고리 테이블 렌더링
    //[self renderCategoryTable];

    
}
#pragma mark -
#pragma mark - 편집 시 액션
// 편집시 셀 선택
- (void) editCellSelected:(id)sender
{
    
    UIButton *rBtn = (UIButton *)sender;
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int index = (int)[(UIButton *)rBtn tag];
    
    
    
    NSMutableDictionary *rdic = [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] objectAtIndexGC:index];
    
    NSLog(@"%d 번 행...%@", index, rdic);
    
    [rBtn setSelected:!rBtn.selected];
    
    [rdic setObject:[NSNumber numberWithBool:rBtn.selected] forKey:@"CheckDelete"];
    
    int checkCount = 0;
    
    for (NSDictionary *dic in oms.getRecentSearchList)
    {
        if([[dic objectForKeyGC:@"CheckDelete"] boolValue])
        {
            checkCount++;
            
        }
        
    }
    
    [_deleteLabel setText:[NSString stringWithFormat:@"삭제 (%d)", checkCount]];
    
    if(checkCount == oms.getRecentSearchCount)
    {
        [_allSelectLabel setText:@"전체해제"];
    }
    else
    {
        [_allSelectLabel setText:@"전체선택"];
    }
    
}
- (void) renderCategoryTable
{
    
    // 즐겨찾기 컨테이너 클리어
    for (UIView *subview in _vwFavoriteContainer.subviews)
    {
        [subview removeFromSuperview];
    }
    
    
    // 즐겨찾기 테이블 뷰 사이즈 조절 (일반/편집모드)
    CGRect rectFavoriteList = _recentTableView.frame;
    int tableHeight = self.view.frame.size.height;
    if (_recentTableView.isEditing)
    {
        // 전체높이-네비게이션높이-카테고리높이-하단버튼그룹높이
        rectFavoriteList.size.height = tableHeight-57-(OM_STARTY + 37);
    }
    else
    {   // 전체높이-네비게이션높이-카테고리높이
        rectFavoriteList.size.height = tableHeight-(37 + OM_STARTY);
    }
    [_recentTableView setFrame:rectFavoriteList];
    
    // 즐겨찾기 테이블뷰 삽입
    [_vwFavoriteContainer addSubview:_recentTableView];
    [_recentTableView reloadData];
    
    [self onRefreshDeleteButtonText:nil];
}

- (void)allSelecetBtnClick:(id)sender
{
    
    // 삭제체크 (전체체크된 경우 YES가 리턴됨)
    BOOL chekced = !_allSelectBtn.selected;
    
    // 전체 삭제체크
    for (NSMutableDictionary *dic in [[OllehMapStatus sharedOllehMapStatus] getRecentSearchList])
    {
        [dic setObject:[NSNumber numberWithBool:chekced] forKey:@"DeleteChecked"];
    }
    
    [self onRefreshDeleteButtonText:nil];

    // 카테고리 테이블 렌더링
    [self renderCategoryTable];
    // 하단 삭제 컨트롤 렌더링
    //[self renderBottomDeletController];
    
    return;
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    int preCount = 0;
    
    for (NSMutableDictionary *dic in oms.getRecentSearchList)
    {
        if([[dic objectForKeyGC:@"CheckDelete"] boolValue])
            preCount++;
    }
    
    BOOL isSelectedAll = NO;
    
    if(preCount == oms.getRecentSearchCount)
        isSelectedAll = YES;
    
    for (NSMutableDictionary *dic in oms.getRecentSearchList)
    {
        [dic setObject:[NSNumber numberWithBool:!isSelectedAll] forKey:@"CheckDelete"];
    }
    
    [_deleteLabel setText:[NSString stringWithFormat:@"삭제 (%d)", oms.getRecentSearchCount]];
    
    [_recentTableView reloadData];
    
    if(isSelectedAll == NO)
    {
        [_allSelectLabel setText:@"전체해제"];
        
    }
    else
    {
        [_allSelectLabel setText:@"전체선택"];
        [_deleteLabel setText:[NSString stringWithFormat:@"삭제 (0)"]];
    }
}

- (void)deleteBtnClick:(id)sender
{
    // 제거대상 수집
    NSMutableArray *deleteList = [NSMutableArray array];
    for (NSMutableDictionary *delDic in [[OllehMapStatus sharedOllehMapStatus] getRecentSearchList])
    {
        if ( [[delDic objectForKeyGC:@"DeleteChecked"] boolValue] )
            [deleteList addObject:delDic];
    }
    
    // 제거
    for (NSMutableDictionary *delDic in deleteList)
    {
        [[[OllehMapStatus sharedOllehMapStatus] getRecentSearchList] removeObject:delDic];
    }
    
    [self renderCategoryTable];
    
    return;
    
    
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //UIButton *rBtn = (UIButton *)sender;
    
    [oms removeRecentSearchOnCheckDelete];
    
    [_deleteLabel setText:@"삭제 (0)"];
    
    [_recentTableView reloadData];
}
- (void)didFinishRequestBusNumDetail:(id)request
{
    //int state = 0;
    //[[OllehMapStatus sharedOllehMapStatus] setBisOrGW:state];
    
    BusLineViewController *bndvc = [self.storyboard instantiateViewControllerWithIdentifier:@"BusLineView"];
    
    [[OMNavigationController sharedNavigationController] pushViewController:bndvc animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
