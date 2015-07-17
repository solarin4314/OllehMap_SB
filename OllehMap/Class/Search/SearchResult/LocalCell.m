//
//  LocalCell.m
//  OllehMap
//
//  Created by 이 제민 on 12. 8. 6..
//  Copyright (c) 2012년 jmlee@miksystem.com. All rights reserved.
//

#import "LocalCell.h"

@implementation LocalCell

@synthesize cellBgView = _cellBgView;
@synthesize localName = _localName;
@synthesize localAddress = _localAddress;
@synthesize localFreeCall = _localFreeCall;
@synthesize localLeftBar = _localLeftBar;
@synthesize localDistance = _localDistance;
@synthesize localRightBar = _localRightBar;
@synthesize localUj = _localUj;
@synthesize localSinglePOI = _localSinglePOI;
@synthesize localStrImg = _localStrImg;
@synthesize localImg = _localImg;
@synthesize localBtnView = _localBtnView;
@synthesize localStart = _localStart;
@synthesize localDest = _localDest;
@synthesize localVisit = _localVisit;
@synthesize localShare = _localShare;
@synthesize localDetail = _localDetail;

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)dealloc
{
    
    [_cellBgView release];
    [_localName release];
    [_localAddress release];
    [_localFreeCall release];
    [_localLeftBar release];
    [_localDistance release];
    [_localRightBar release];
    [_localUj release];
    [_localSinglePOI release];
    [_localBtnView release];
    [_localStart release];
    [_localDest release];
    [_localVisit release];
    [_localShare release];
    [_localDetail release];
    [_localStrImg release];
    [_localImg release];
    [super dealloc];
}

- (IBAction)localStartClick:(id)sender
{
    if([(UIButton *)sender tag] < 200)
    {
    // 출발지통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/search_result/start"];
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    MapContainer *mc = [MapContainer sharedMapContainer_Main];
    oms.currentMapLocationMode = MapLocationMode_None;
    
    NSString *place = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
    double x = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellX"] doubleValue];
    double y = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellY"] doubleValue];
    NSLog(@"%@, %f, %f", place, x, y);
    [oms.searchResultRouteStart reset];
    [oms.searchResultRouteStart setUsed:YES];
    [oms.searchResultRouteStart setIsCurrentLocation:NO];
    [oms.searchResultRouteStart setStrLocationName:place];
    [oms.searchResultRouteStart setCoordLocationPoint:CoordMake(x, y)];
    
    [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
    [mc.kmap setCenterCoordinate:oms.searchResultRouteStart.coordLocationPoint];
    }
}

- (IBAction)localDestClick:(id)sender
{
    if([(UIButton *)sender tag] < 300)
    {
    // 도착지 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/search_result/dest"];
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    MapContainer *mc = [MapContainer sharedMapContainer_Main];
    oms.currentMapLocationMode = MapLocationMode_None;
    NSString *place = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
    double x = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellX"] doubleValue];
    double y = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellY"] doubleValue];
    NSLog(@"%@, %f, %f", place, x, y);
    [oms.searchResultRouteDest reset];
    [oms.searchResultRouteDest setUsed:YES];
    [oms.searchResultRouteDest setIsCurrentLocation:NO];
    [oms.searchResultRouteDest setStrLocationName:place];
    [oms.searchResultRouteDest setCoordLocationPoint:CoordMake(x, y)];
    
    [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
    [mc.kmap setCenterCoordinate:oms.searchResultRouteDest.coordLocationPoint];
    }
}

- (IBAction)localVisitClick:(id)sender
{
    if([(UIButton *)sender tag] < 400)
    {
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    MapContainer *mc = [MapContainer sharedMapContainer_Main];
    oms.currentMapLocationMode = MapLocationMode_None;
    NSString *place = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
    double x = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellX"] doubleValue];
    double y = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellY"] doubleValue];
    NSLog(@"%@, %f, %f", place, x, y);
    [oms.searchResultRouteVisit reset];
    [oms.searchResultRouteVisit setUsed:YES];
    [oms.searchResultRouteVisit setIsCurrentLocation:NO];
    [oms.searchResultRouteVisit setStrLocationName:place];
    [oms.searchResultRouteVisit setCoordLocationPoint:CoordMake(x, y)];
    
    [[SearchRouteDialogViewController sharedSearchRouteDialog] showSearchRouteDialog];
    
    [mc.kmap setCenterCoordinate:oms.searchResultRouteVisit.coordLocationPoint];
    }
}

- (IBAction)localShareClick:(id)sender
{
    // 위치공유 선택 통계
    [[OllehMapStatus sharedOllehMapStatus] trackPageView:@"/search_result/share"];
    
    //MapContainer *mc = [MapContainer sharedMapContainer_Main];
    OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
    
    //NSString *place = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
    NSString *poiId = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellDidCode"];
    NSString *orgDbId = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellId"];
    
    double x = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellX"] doubleValue];
    double y = [[oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellY"] doubleValue];
    NSString *Addadd = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellTelAddress"];
    NSString *poiType = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellType"];
    
    NSString *themeCoder = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellTheme"];
    
    if([poiType isEqualToString:@"TR"])
    {
        if([themeCoder rangeOfString:@"0406"].length > 0)
        {
            poiType = @"TR";
            poiId = orgDbId;
        }
        else if ([themeCoder rangeOfString:@"0407"].length > 0)
        {
            poiType = @"TR_BUS";
            poiId = orgDbId;
        }
        else
            poiType = @"MP";
    }
    
    if(!Addadd)
        Addadd = @"";
    // 새로운 url공유
    NSString *order = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendOrder"];
    [[ServerConnector sharedServerConnection] requestSearchURL:self action:@selector(finishShareBtnClick:) PX:(int)x PY:(int)y Query:oms.keyword SearchType:@"place" order:order];
    
    //[[ServerConnector sharedServerConnection] requestShortenURL:self action:@selector(finishShareBtnClick:) PX:(int)x PY:(int)y Level:mc.kmap.zoomLevel MapType:mc.kmap.mapType Name:place PID:poiId Addr:Addadd Tel:nil Type:poiType ID:orgDbId];
}
// 위치공유버튼클릭
- (void) finishShareBtnClick:(id)request
{
    if([request finishCode] == OMSRFinishCode_Completed)
    {
        OllehMapStatus *oms = [OllehMapStatus sharedOllehMapStatus];
        
        
        NSString *name = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellName"];
        NSString *tel = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellTel"];
        NSString *addr = [oms.searchLocalDictionary objectForKeyGC:@"LastExtendCellTelAddress"];
        
        if(tel == nil)
            tel = @"";
        
        if(addr == nil)
            addr = @"";
        
        [oms.shareDictionary setObject:name forKey:@"NAME"];
        
        [oms.shareDictionary setObject:addr forKey:@"ADDR"];
        [oms.shareDictionary setObject:tel forKey:@"TEL"];
        
        NSLog(@"단축URL : %@", [oms.shareDictionary objectForKeyGC:@"ShortURL"]);
        
        //[self.view addSubview:[ShareViewController instVC].view];
        
        [ShareViewController sharePopUpView:self.superview.superview.superview];
    }
    else if([[OllehMapStatus sharedOllehMapStatus] getNetworkStatus] == OMReachabilityStatus_disconnected)
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_NetworkException", @"")];
    }
    else
    {
        [OMMessageBox showAlertMessage:@"" :NSLocalizedString(@"Msg_ShortURL_NotResponse", @"")];
    }
}
@end
