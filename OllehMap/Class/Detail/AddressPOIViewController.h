//
//  AddressPOIViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 7..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import "CommonPOIDetailViewController.h"
#import "MainViewController.h"

@interface AddressPOIViewController : CommonPOIDetailViewController
{
    DetailScrollView *_scrollView;
    
    UIButton *_mapBtn;
    int _viewStartY;
    int _nullSizeY;
    Coord _poiCrd;
    
    NSString *_poiZibunAddress;
    NSString *_poiRoadAddress;
    NSString *_poiHangAddress;
    
    NSString *_oldOrNew;
}

#pragma mark -
#pragma mark @property
@property (strong, nonatomic) IBOutlet DetailScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIButton *mapBtn;
@property (nonatomic, assign) Coord poiCrd;
@property (nonatomic, strong) NSString *poiZibunAddress;
@property (nonatomic, strong) NSString *poiRoadAddress;
@property (nonatomic, strong) NSString *poiHangAddress;

@property (nonatomic, strong) NSString *oldOrNew;
@property (nonatomic, strong) NSString *rdCd;
@property (nonatomic, assign) BOOL mapToDetail;

#pragma mark -
#pragma mark IBAction
- (IBAction)popBtnClick:(id)sender;
- (IBAction)mapBtnClick:(id)sender;
@end
