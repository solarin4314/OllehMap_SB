//
//  ViewController.h
//  ollehSpeechSample
//
//  Created by 소프트 지뉴 on 12. 8. 11..
//  Copyright (c) 2012 지뉴소프트. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>

#import "avrController.h"
#import "WaveFormView.h"

//음성인식 결과 파싱 파서
@class CSemParser;

@interface ViewController : UIViewController <UITableViewDelegate,UITableViewDataSource>
{
    
    CSemParser*					mpBnfParser; //BNF parser
    
    //VoiceAssistCore 에 넘겨줄 파라미터 
    NSString* serverIP;
    NSInteger serverPort;
    NSString* Certification;
    NSInteger mediaType;
    
    NSMutableArray * recogResult;   // 음성 인식 결과 담는 배열 
    
    UITableView *recogList;     //인식결과 보이는 뷰: 피커뷰 대신 사용
    
    //PopOver View
    UIView *popOverView;
    UILabel *popOverLabel;
    UIImageView *popOverImgView;
    UIActivityIndicatorView *popOverSpinner;
    UIButton *popOverRestartBtn;
    UIButton *popOverCancelBtn;
    
    //Shadow View
    UIView      *shadeView;
    
    //파형 그리기
    avrController *avrCtrl;
    AudioQueueRef aqBufRef;
    AudioQueueLevelMeterState* aqLevelArr;
    WaveFormView* waveFormView;
    NSTimer* aqBufCheckTimer;
    NSMutableArray* waveLevel;  //
    
    IBOutlet UIButton       *SeachButton;       // 마이크 버튼
    
    BOOL isCanceled;    //취소 버튼 누르는 경우 설정 
    
    BOOL recogResultNone;   // 인식은 성공하였으나 결과가 없을경우 TRUE
    BOOL silentInput;       // 인식은 시도 하였으나 정해진 시간 안에 음성 입력이 없었을 경우 TRUE
    
    BOOL bFail;             // Failure         통지를 받았을때 TRUE
    BOOL bStartRecog;       // StartRecognize  통지를 받았을때 TRUE
    BOOL bFailRecog;        // FailedRecognize 통지를 받았을때 TRUE
    BOOL bSuccRecog;        // SucessRecognize 통지를 받았을때 TRUE
}

@property (nonatomic,retain) NSString* serverIP;
@property  NSInteger  serverPort;
@property (nonatomic,retain) NSString* Certification;
@property  NSInteger mediaType;

@property BOOL recogResultNone; // 인식은 성공하였으나 결과가 없을경우 TRUE
@property BOOL silentInput;     // 인식은 시도 하였으나 정해진 시간 안에 음성 입력이 없었을 경우 TRUE

@property BOOL bFail;           // Failure         통지를 받았을때 TRUE
@property BOOL bStartRecog;     // StartRecognize  통지를 받았을때 TRUE
@property BOOL bFailRecog;      // FailedRecognize 통지를 받았을때 TRUE
@property BOOL bSuccRecog;      // SucessRecognize 통지를 받았을때 TRUE

//----------------------------------------------------------------------------
//PopOver View
//----------------------------------------------------------------------------
@property (nonatomic, retain) IBOutlet UIView *shadeView;

@property (nonatomic, retain) IBOutlet UIView *popOverView;
@property (nonatomic, retain) IBOutlet UILabel *popOverLabel;
@property (nonatomic, retain) IBOutlet UIImageView *popOverImgView;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *popOverSpinner;
@property (nonatomic, retain) IBOutlet UIButton *popOverRestartBtn;
@property (nonatomic, retain) IBOutlet UIButton *popOverCancelBtn;
@property (nonatomic, retain) IBOutlet WaveFormView *waveFormView;

- (IBAction)onRestart:(id)sender;
- (IBAction)onCancel:(id)sender;

//----------------------------------------------------------------------------
//ASR View
//----------------------------------------------------------------------------
@property (nonatomic, retain) IBOutlet UITableView *recogList;
@property (nonatomic, retain) IBOutlet UIButton     *SeachButton;

-(IBAction)SeachButtonPressed:(id)sender;      // 확인 버튼 터치시...
@end
