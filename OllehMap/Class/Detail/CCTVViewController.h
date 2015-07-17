//
//  CCTVViewController.h
//  OllehMap
//
//  Created by 이제민 on 13. 10. 7..
//  Copyright (c) 2013년 이제민. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import <AudioToolbox/AudioQueue.h>
#import <AudioToolbox/AudioSession.h>
#import <AVFoundation/AVAudioSession.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVAudioRecorder.h>
#import "OllehMapStatus.h"
#import "DbHelper.h"
#import "FavoriteViewController.h"
#import "NSString+AESCrypt.h"

@interface CCTVViewController : UIViewController<AVAudioSessionDelegate,AVAudioPlayerDelegate>
{
    NSMutableDictionary *_info;
    MPMoviePlayerViewController *_player;
}
@property (nonatomic, strong) MPMoviePlayerViewController *player;

- (void) showCCTV :(NSDictionary*)info;

@end
