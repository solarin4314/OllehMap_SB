//
//  ViewController.m
//  ollehSpeechSample
//
//  Created by 소프트 지뉴 on 12. 8. 11..
//  Copyright (c) 2012 지뉴소프트. All rights reserved.
//

#import "ViewController.h"

#import "VoiceAssistController.h"

#import "CSemParser.h"

@implementation ViewController

@synthesize SeachButton;

@synthesize serverIP;
@synthesize serverPort;
@synthesize Certification;
@synthesize mediaType;

@synthesize recogList;
@synthesize shadeView;


@synthesize popOverView;
@synthesize popOverLabel;
@synthesize popOverImgView;
@synthesize popOverSpinner;
@synthesize popOverRestartBtn;
@synthesize popOverCancelBtn;
@synthesize waveFormView;

@synthesize recogResultNone; // 인식은 성공하였으나 결과가 없을경우 TRUE
@synthesize silentInput;     // 인식은 시도 하였으나 정해진 시간 안에 음성 입력이 없었을 경우 TRUE

@synthesize bFail;           //FAIL
@synthesize bStartRecog;     //STarted Recog
@synthesize bFailRecog;      //Failed Recog
@synthesize bSuccRecog;      //Succeeded Recog


BOOL isFirstReadyOK = YES;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    //From VoiceAssist Code
    
    //음성 인식 결과 배열 초기화 
    recogResult = [[NSMutableArray alloc] init];
    
    //BNF parser 초기화
    mpBnfParser = [[CSemParser alloc] init];
    
    //음성 인식 service controller로 부터 서비스 상태 통지를 받기 위해 감시기를 등록한다.
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ConnectCannot:) name:UIVoiceAssistConnectCannotNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(ReadyOK:) name:UIVoiceAssistReadyOKNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SessionTimeout:) name:UIVoiceAssistSessionTimeoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(StartRecognize:) name:UIVoiceAssistStartRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(FailedRecognize:) name:UIVoiceAssistFailedRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(SucessRecognize:) name:UIVoiceAssistSucessRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Failure:) name:UIVoiceAssistFailureNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(Disconnect:) name:UIVoiceAssistDisconnectNotification object:nil];
    
    self.recogList.backgroundColor = [UIColor clearColor];    //olleh Navi
    self.recogList.separatorColor = [UIColor darkGrayColor];
    
    self.serverIP = @"211.219.28.187";
    
    [self.view addSubview:self.shadeView];
    [self.view addSubview:self.popOverView];
    //--> 팝업창 모두다 불투명 하게 
    
    //PopOverView
    [self.view addSubview:self.shadeView];
    [self.view addSubview:self.popOverView];
    
    self.shadeView.alpha = 0.5;
    self.popOverView.alpha = 1.0;
    self.popOverView.layer.cornerRadius = 10;
    self.popOverView.layer.masksToBounds = YES;
    
    self.popOverView.center = CGPointMake(160, 240);
    [self.popOverSpinner startAnimating];
    self.popOverSpinner.hidden = NO;
    
    self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
    self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
    self.shadeView.hidden = YES;
    self.popOverView.hidden = YES;
    
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    //파형 그리기 관련
    avrCtrl = [avrController sharedAVRController];  
    aqLevelArr = (AudioQueueLevelMeterState*)malloc(sizeof(AudioQueueLevelMeterState));
    
    self.waveFormView.alpha = 0.65;
    
    self.waveFormView.layer.masksToBounds = YES;
    //// 파형 크기 설정: 
    self.waveFormView.magFactor = 4;    //0~4까지 인덱스(최소~최대) 
    
    isFirstReadyOK = YES;
    
    waveLevel = [[NSMutableArray alloc] init];
    
    isCanceled = NO;
    
}

-(IBAction)SeachButtonPressed:(id)sender
{
    NSLog(@"%s",__FUNCTION__);
    
    //self.serverIP       = @"211.219.28.187";
    self.serverIP       = @"221.148.122.241";
    self.serverPort     = SESSION_PORT;
    //self.Certification  = @"1315413157";
    self.Certification  = @"6624543210";
    self.mediaType      = ASR ;
    
    [recogResult removeAllObjects];
    
    //오디오 관련 초기화 코드 추가: Begin
    //audio(mic&speaker) controller를 초기화 한다.    
    NSError * error = nil;
    if([[avrController sharedAVRController] AudioSessionInitialization:&error] == NO)
    {
        //일단 현재의 에러 정보를 display한다.
        UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[[UIDevice currentDevice] systemVersion] message:[error description] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
        [alert show];
        [alert release];
        
        //실패했지만 다시한번 초기화를 시도해 본다.
        if([[avrController sharedAVRController] AudioSessionInitialization:&error] == NO)
        {
            //device 초기화에 실패할 경우 application 재시작 경고를 알려준다.
            //한번 초기화 실패시 device reset이 불가능하므로 application 종료시 background로 가지 않고 강제로 종료하도록 *.plist에 
            //Application does not run in background 항목을 YES로 한다.
            
            UIAlertView * alert = [[UIAlertView alloc] initWithTitle:[[UIDevice currentDevice] systemVersion] message:[error description] delegate:nil cancelButtonTitle:@"확인" otherButtonTitles: nil];
            [alert show];
            [alert release];
        }        
    }
    else
    {
        //audio device open-delay를 줄이기 위해 caching function을 미리 한번 구동한다.
        //--> 주석 처리하면 상단 바는 사라짐: 대신 마이크 초기화 늦을 가능성
        
        //[avr Cache:YES];
        //[avr Cache:NO];
        
        //network-delay를 줄이기 위해 caching function을 구동시킨다.        
    }
    //오디오 관련 초기화 코드 추가: End
    
    isCanceled = NO;
    
    self.recogResultNone = NO;
    self.silentInput = NO;
    
    self.bFail = NO;
    self.bStartRecog = NO;
    self.bFailRecog = NO;
    self.bSuccRecog = NO;

    //파형 뷰
    [self.waveFormView clear];
    [waveLevel removeAllObjects];
    
    
    //초기화시  일반 파형 플래그 설정
    self.waveFormView.isFinalWave = NO;
    
    if(aqBufCheckTimer != nil) 
    {
        [aqBufCheckTimer invalidate];
        aqBufCheckTimer = nil;
    }
    
    //그리는 속도 좀더 빠르게 수정함 --> 타이머가 라이브러리 런루프와 간섭해서 속도가 느려질 가능성 존재함
    //별도 스레드로 빼기...
    aqBufCheckTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(onAQBufChkTimer:) userInfo:self repeats:YES];
    
    
    [recogResult removeAllObjects];
    
    self.popOverLabel.text = @"준비중입니다";
    
    self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
    self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    
    
    //6140: TEST 시작시 스탑하도록 루틴 추가: 여러번 녹음시 생기는 문제 관련 
    [[VoiceAssistController sharedVoiceAssist] Stop:sender];
    
    //음성 인식 컨트롤러에 인자들을 넘긴다.
    NSInteger nRet;
    nRet = [[VoiceAssistController sharedVoiceAssist] SetParameter:self.serverIP port:self.serverPort Certification:self.Certification reqcontype:self.mediaType];
    NSLog(@"@@@@@ SetParameter serverIP[%@] serverPort[%i] Certification[%@] mediaType[%i]",
          self.serverIP, self.serverPort, self.Certification, self.mediaType);
    
    if (nRet) {
        //음성 인식 시작 함수를 호출하며 인자로 주소록을 넘긴다.
        [[VoiceAssistController sharedVoiceAssist] Start:nil];
        
    } else if((nRet == -1 ) || (nRet == -2 )) {
        // IP or Certification Fail 
        self.popOverRestartBtn.hidden = NO; 
        self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
        self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);  
        
        self.shadeView.hidden = NO;
        self.popOverView.hidden = NO;
        
        self.SeachButton.enabled = NO;
        
        //접속 불가시 타이머 있다면 해제하기 
        if(aqBufCheckTimer != nil) 
        {
            //        [self retain];
            //        ++selfRetainCnt;
            [aqBufCheckTimer invalidate];
            aqBufCheckTimer = nil;
            NSLog(@"[Disconnect]:aqBufCheckTimer invalidated!");
        }

    }
    
    //모달 뷰 컨트롤러 대신 뷰를 추가함...
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
}

- (void)viewDidUnload
{
    //From VoiceAssist Code..
    
    //BNF parser 해제
    [mpBnfParser release];
    mpBnfParser = nil;
    
    //음성인식 결과 배열 해제
    [recogResult release];
    recogResult = nil;
    
    [serverIP release];
    serverIP = nil;
    
    //음성 인식 service controller로 부터 서비스 상태 통지 감시기를 해제한다.  
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistConnectCannotNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistReadyOKNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistSessionTimeoutNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistStartRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistFailedRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistSucessRecognizeNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistFailureNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistDisconnectNotification object:nil];
    
    self.SeachButton   = nil;
    
    [self setPopOverView:nil];
    [self setPopOverLabel:nil];
    [self setPopOverImgView:nil];
    [self setPopOverSpinner:nil];
    [self setPopOverRestartBtn:nil];
    [self setPopOverCancelBtn:nil];
    [self setWaveFormView:nil];
    
    [self setShadeView:nil];
    
    [self setRecogList:nil];
    
    
    NSLog(@"%s,App Crash TEST BEGIN",__FUNCTION__);
    if(aqBufCheckTimer) 
    {
        [aqBufCheckTimer invalidate];
        aqBufCheckTimer = nil;
    }
    
    //6140: 앱죽는 것 테스트 -> 여기서도 aqLevelArr 해제하는 것 추가.2011.9.7
    if (aqLevelArr) {
        free(aqLevelArr);
        aqLevelArr = NULL;
    }
    NSLog(@"%s,App Crash TEST END",__FUNCTION__);
    
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)dealloc
{
    
    //앱 크래시 테스트용 BEGIN: viewDidUnload 에 있던것     
    //음성 인식 service controller로 부터 서비스 상태 통지 감시기를 해제한다.  
    try
    {
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistConnectCannotNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistReadyOKNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistSessionTimeoutNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistStartRecognizeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistFailedRecognizeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistSucessRecognizeNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistFailureNotification object:nil];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIVoiceAssistDisconnectNotification object:nil];
        
        
        if(aqBufCheckTimer) 
        {
            NSLog(@"%s: dealloc -> aqBufCheckTimer is not nil. invalidation begin",__FUNCTION__);
            [aqBufCheckTimer invalidate];
            aqBufCheckTimer = nil;
        }
        
        
        
        //6140: 앱죽는 것 테스트 -> 여기서도 aqLevelArr 해제하는 것 추가.2011.9.7
        if (aqLevelArr) {
            NSLog(@"%s: dealloc -> aqLevelArr is not nil. free begin",__FUNCTION__);
            free(aqLevelArr);
            aqLevelArr = NULL;
        }
        if (mpBnfParser != nil)   [mpBnfParser release];        //BNF parser 해제
        if (recogResult != nil) [recogResult release];          //음성인식 결과 배열 해제
        
        if (serverIP != nil) [serverIP release];
        
        [self setShadeView:nil];
        [self setRecogList:nil];
        
        [self setPopOverView:nil];
        [self setPopOverLabel:nil];
        [self setPopOverImgView:nil];
        [self setPopOverSpinner:nil];
        [self setPopOverRestartBtn:nil];
        [self setPopOverCancelBtn:nil];
        [self setWaveFormView:nil];
        
        [self setSeachButton:nil];
        
        if (waveLevel != nil) [waveLevel release];
        
        isFirstReadyOK = YES;
        
    }
    catch (...)
    {
        NSLog(@"ViewController dealloc exception");
    }
    
    [SeachButton release];
    
    [super dealloc];
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    // 가로보기 고정
    //return (interfaceOrientation >= UIInterfaceOrientationPortraitUpsideDown);
    // 세로보기 고정
    return (interfaceOrientation <= UIInterfaceOrientationPortraitUpsideDown);
    
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [recogResult count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *recogCellIdentifier = @"recogCell";  //인식 결과 
    
    UITableViewCell *recogCell = [tableView dequeueReusableCellWithIdentifier:recogCellIdentifier];
    if (recogCell == nil) 
    {
        recogCell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:recogCellIdentifier] autorelease];
    }
    // Configure the cell...
    //[cell.textLabel setFont:[UIFont systemFontOfSize:[UIFont smallSystemFontSize]]];
    [recogCell.textLabel setText:[recogResult objectAtIndex:[indexPath row]]];
    recogCell.accessoryType = UITableViewCellAccessoryNone;
    [recogCell.textLabel setTextColor:[UIColor whiteColor]];
    
    return recogCell;
}


#pragma mark - PopOverView

- (IBAction)onRestart:(id)sender {
    //음성 입력화면 으로 전환
    
    //parameter는 의미없음.
    [[VoiceAssistController sharedVoiceAssist] Stop:sender];
    
    self.popOverLabel.text = @"검색어를 말씀하세요";
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    
    [self SeachButtonPressed:sender];
}

- (IBAction)onCancel:(id)sender {
    //parameter는 의미없음.
    [[VoiceAssistController sharedVoiceAssist] Stop:sender];
    
    /*
     if(aqBufCheckTimer != nil) 
     {
     //        [self retain];
     //        ++selfRetainCnt;
     
     [aqBufCheckTimer invalidate];
     aqBufCheckTimer = nil;
     }
     */
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    
    self.shadeView.hidden = YES;
    self.popOverView.hidden = YES;
    
    
    self.SeachButton.enabled = YES;
    
    
    isCanceled = YES;
    
    //[self dismissModalViewControllerAnimated:YES];
}

#pragma mark - VoiceAssistNotification
//========================================================//
// 아래 Notification함수들은 VoiceAssistController로 부터 
// 상태 변화에 알맞게 UI로 올려주는 notification 함수들이다.
// 아래 Notification 함수안에는 절대 Block 함수나 loop 함수를 구현해서는 안된다.
//========================================================//

// 서버에 접속이 불가능하여 발생되는 Notification함수이다.
// UIVoiceAssistConnectCannotNotification
-(void)ConnectCannot:(NSNotification*) event
{    
    NSLog(@"GUI-ConnectCannot:%@",[event userInfo]);   
    
    NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    NSString* errLog = [NSString stringWithFormat:@"네트워크 에러[%d]",[state intValue]];
    NSLog(@"GUI-ConnectCannet:%@", errLog);
    
    self.popOverLabel.text = errLog;
    
    //(네트웍 불통시 컨트롤 활성화):제거 ->  팝업 추가 
    self.popOverRestartBtn.hidden = NO; 
    self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
    self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);  
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
    
    self.SeachButton.enabled = NO;
    
    //접속 불가시 타이머 있다면 해제하기 
    if(aqBufCheckTimer != nil) 
    {
        //        [self retain];
        //        ++selfRetainCnt;
        [aqBufCheckTimer invalidate];
        aqBufCheckTimer = nil;
        NSLog(@"[Disconnect]:aqBufCheckTimer invalidated!");
    }
    
}


/*
 서버와의 접속이 종료될 경우 발생되는 Notification 함수이다.
 (주의) 이 함수는 서버 접속이 완료된 이후 어떤 이유에서든 서버와의 접속이 끊어지게 되면 호출되는 Notification함수이다.
 예를 들어, 아래 UX를 위해 정의된 Failure/SessionTimeout/... 통지 이후 Disconnect 통지 함수도 발생된다.
 물론, 아래 정의된 통지 함수가 호출됨 없이 Disconnect 통지 함수만 발생될 수 있다. 
 이 경우 event parameter의 status값이 FALSE로 구성되므로 구분할 수 있다.
 ---> 해제시 정상인식결과인 경우외에는 모두 팝오버 뷰 유지하도록 수정 
 
 enum STATUS_VALUE{
 UNKNOWN_STATUS = noErr,    //0
 CANT_CONNECT_STATUS,   //1
 READY_STATUS,  //2
 TIMEOUT_STATUS,    //3
 START_RECOG_STATUS,//4
 FAIL_RECOG_STATUS,//5
 OK_RECOG_STATUS,//6
 FAILURE_STATUS,//7
 NONE_DATA_STATUS,//8
 PLAY_FIN_STATUS//9
 };
 
 */
-(void)Disconnect:(NSNotification*)event
{
    NSLog(@"GUI-Disconnect:%@",[event userInfo]);
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    self.popOverImgView.image = [UIImage imageNamed:@"popOverMicImg.png"];
    
    
    NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    if(![state intValue])   //그냥 서버 연결 종료인 경우(정상): 기타 노티없이 종료의 경우 -> 팝오버 유지
    {
        
        //인식중 취소 버튼 누른 경우에는 그냥 패스 
        if(isCanceled == NO)
        {
            self.popOverRestartBtn.hidden = NO; 
            self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
            self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);  
            
            self.shadeView.hidden = NO;
            self.popOverView.hidden = NO;
            
            self.SeachButton.enabled = NO;    
            
            //이 곳에 연결종료 노티 전에 호출되는 노티 코드를 검사해서 개별 메시지 출력하도록 
            NSString* errLog = 
            [NSString stringWithFormat:@"서버 연결 종료[%d]",[state intValue]];
            
            //self.logLabel.text = errLog;
            self.popOverLabel.text = errLog;    
        }
        else
        {
            self.popOverRestartBtn.hidden = YES; 
            self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
            
            self.shadeView.hidden = YES;
            self.popOverView.hidden = YES;
            
            NSString* errLog = 
            [NSString stringWithFormat:@"대기[%d]",[state intValue]];
            NSLog(@"[Disconnect]:ERR==%@", errLog);
            
            self.popOverLabel.text = @"대기";
        }
        
        
    }
    else    //기타 종료 인 경우(오류): 오류코드 존재시 처리, 오류 없는 경우 결과없음,묵음 처리 
    {
        
        //인식 성공 && 결과 없음  || 묵음입력의 경우: 팝업 창 유지
        if(self.recogResultNone || self.silentInput)
        {
            NSString* errLog;
            if(self.recogResultNone)    //인식 성공 && 결과 없음
            {
                errLog = [NSString stringWithFormat:@"검색결과 없음[%d]",[state intValue]];
                
                self.popOverLabel.text = @"검색결과 없음";
                }
            else    //묵음입력
            {
                errLog = [NSString stringWithFormat:@"음성입력 없음[%d]",[state intValue]];
                
                self.popOverLabel.text = @"음성입력 없음";
                }
            
            self.popOverRestartBtn.hidden = NO;
            self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
            self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);
            
            self.shadeView.hidden = NO;
            self.popOverView.hidden = NO;
            self.SeachButton.enabled = NO;
            
        }
        else    //기타: 팝업 제거->인식성공 && 결과 있는 경우만 팝업제거.단 state 값이 6이 아니면 유지
        {
            //OK_RECOG_STATUS,//6
            NSLog(@"Disconnect:기타종료->인식성공 && 결과 있는 경우 or 비정상종료:state=%d",[state intValue]);
            if ([state intValue] == 6) //상태값 이 6 (OK_RECOG_STATUS)인경우에만 팝업제거
            {
                self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
                self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치
                
                self.shadeView.hidden = YES;
                self.popOverView.hidden = YES;
                
                self.SeachButton.enabled = YES;
                
                NSString* errLog;
                errLog = [NSString stringWithFormat:@"대기[%d]",[state intValue]];
                
                self.popOverLabel.text = @"대기";
            }
            else //오류
            {
                //인식중 취소 버튼 누른 경우에는 그냥 패스
                if(isCanceled == NO)
                {
                    self.popOverRestartBtn.hidden = NO;
                    self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
                    self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);
                    
                    self.shadeView.hidden = NO;
                    self.popOverView.hidden = NO;
                    
                    self.SeachButton.enabled = NO;
                    
                    //여기에 이전에 호출된 상태 코드 검사해서...
                    NSString* errLog;
                    if (self.bFail) //FAIL Stat
                    {
                        errLog =
                        [NSString stringWithFormat:@"서버 에러[%d]",[state intValue]];
                    }
                    else
                    {
                        if (self.bStartRecog)
                        {
                            if (self.bFailRecog) //인식 실패 에러
                            {
                                errLog =
                                [NSString stringWithFormat:@"서버 에러[%d]",[state intValue]];
                            }
                            else //인식성공 && 에러
                            {
                                errLog = 
                                [NSString stringWithFormat:@"서버 에러[%d]",[state intValue]];
                                
                            }
                        } 
                        else //Start Recog Stat Err
                        {
                            errLog = 
                            [NSString stringWithFormat:@"네트워크 에러[%d]",[state intValue]];
                        }
                        
                    }
                    
                    self.bFailRecog = NO;    
                    self.bSuccRecog = NO;    
                    
                    self.popOverLabel.text = errLog; 
                }
                
            }
            
        }
    }
    
    
    
    if (aqLevelArr) {
        free(aqLevelArr);
        aqLevelArr = NULL;
    }
    
    
    
    //연결 종료시 오디오 큐 버퍼에 널 할당: 안해 주면 초기 한번만 동작함
    aqBufRef = NULL;    
    NSLog(@"[Disconnect]:aqBufRef Nullify!");
    
    
    
    //타이머 해제를 인식 시작하면 종료로 변경? -> 오류로 종료하는 경우에는 타이머 해제 ?
    if(aqBufCheckTimer != nil) 
    {
        //        [self retain];
        //        ++selfRetainCnt;
        [aqBufCheckTimer invalidate];
        aqBufCheckTimer = nil;
        NSLog(@"[Disconnect]:aqBufCheckTimer invalidated!");
    }
    
    
    //파형 클래스에 최종 파형 배열 전달 & 파형 그리기 메시지 전달: 최종 전체 파형 그리기 용도 
    
    //@synchronized(self)
    {       
        //마지막 파형 플래그 설정
        self.waveFormView.isFinalWave = YES;
        
        //[self.waveFormView clear];
        self.waveFormView.waveForm  = waveLevel;
        
        [self.waveFormView setNeedsDisplay];
        
        NSLog(@"[Disconnect]:Final waveLevel Tx to WaveForm! ==> waveLevel count: %d",[waveLevel count]);
        
    }
    
    
    //연결 종료되면 파형 저장하던 배열 waveLevel 의 원소 제거: 리소스 ->현재는 녹음 시작시에만 제거해줌
    
    //[waveLevel removeAllObjects];   
    //[self.waveFormView.waveForm removeAllObjects];
    NSLog(@"[Disconnect]:waveLevel removeAllObjects!");
    
    /* // SCSHIN-JUST MOMENT    
     //연결 종료후 일반 파형 플래그 설정
     //self.waveFormView.isFinalWave = NO;
     searchImg.hidden = NO;
     searchTextField.enabled = YES;
     */    
}

/*
 서버에 접속이 완료되어 음성 인식을 위한 녹음을 시작할 수 있다는 의미의 Notification함수이다.
 */
-(void)ReadyOK:(NSNotification*)event
{
    NSLog(@"GUI-ReadyOK:%@",[event userInfo]);
    
    self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
    self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    self.popOverImgView.image = [UIImage imageNamed:@"popOverMicImg.png"];
    
    /* // SCSHIN-JUST MOMENT  
     self.shortCutBtn.enabled = NO;
     
     self.logLabel.text = @"서버 연결됨";
     */
    self.popOverLabel.text = @"검색어를 말씀하세요";    
    
    //파형 그리기 관련
    if(aqBufRef == NULL)
    {
        aqBufRef =[[avrController sharedAVRController] Queue];
    }
    if (aqLevelArr) {
        free(aqLevelArr);
        aqLevelArr = NULL;
    }
    aqLevelArr = (AudioQueueLevelMeterState*)malloc(sizeof(AudioQueueLevelMeterState));
    memset(aqLevelArr, 0x00, sizeof(AudioQueueLevelMeterState));
    
    
    
    UInt32 val = 1;
    OSStatus sts;
    sts = AudioQueueSetProperty(aqBufRef, kAudioQueueProperty_EnableLevelMetering, &val, sizeof(UInt32));
    NSLog(@"sts[EnableLevelMetering] = %ld",sts);
    
    
    
    CAStreamBasicDescription queueFormat;
    UInt32 data_sz = sizeof(queueFormat);
    sts = AudioQueueGetProperty(aqBufRef, kAudioQueueProperty_StreamDescription, &queueFormat, &data_sz);
    NSLog(@"sts[StreamDescription] = %ld",sts);    
    NSLog(@"[ReadyOK] ch =  %lu", queueFormat.NumberChannels());
    
}

/*
 서버측과 약속된 시간이 초과하면 서비스 세션 타임아웃 통지를 받는 함수이다.
 (이 통지 함수 이후 Disconnect 통지도 호출된다.) --> 묵음..
 */
-(void)SessionTimeout:(NSNotification*)event
{    
    NSLog(@"GUI-SessionTimeout:%@",[event userInfo]);
    
    self.silentInput = YES;
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    self.popOverImgView.image = [UIImage imageNamed:@"popOverMicImg.png"];
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
    
    /* // SCSHIN-JUST MOMENT    
     self.silentInput = YES;        
     
     self.shortCutBtn.enabled = NO;
     */
    
    
    NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    NSString* errLog = [NSString stringWithFormat:@"네트워크 에러[%d]",[state intValue]];
    NSLog(@"GUI-SessionTimeout Err:%@", errLog);
    
    /* // SCSHIN-JUST MOMENT    
     self.logLabel.text = errLog;
     self.popOverLabel.text = errLog;
     */    
}

/*
 서버측과 약속된 에러가 발생시 서비스 Failure 통지를 받는 함수이다.
 (이 통지 함수 이후 Disconnect 통지도 호출된다.)
 --> 팝오버 화면 유지하도록 수정 
 */
-(void)Failure:(NSNotification*)event
{
    NSLog(@"GUI-Failure:%@",[event userInfo]);
    
    self.bFail = YES;
    
    self.popOverRestartBtn.hidden = NO; 
    self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
    self.popOverCancelBtn.center = CGPointMake(125+57, 137+18);  
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    self.popOverImgView.image = [UIImage imageNamed:@"popOverMicImg.png"];
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
    
    
    self.SeachButton.enabled = NO;    
    
    //NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    if (state == nil) {
        state = (NSNumber*)[[event userInfo] objectForKey:@"nResult"];
    }
    NSString* errLog = 
    [NSString stringWithFormat:@"서버 에러[%d]",[state intValue]];
    NSLog(@"GUI-Failure:%@ errCode=%d",[event userInfo],[state intValue]);
    
    self.popOverLabel.text = errLog;
    
    
}

/* 
 서버측에서 음성 수신이 완료되고 음성 인식을 시작하게 되면 StartRecognizer 통지를 받는 함수이다.
 (이 통지 함수 이후 상황에 따라 Disconnect 통지도 호출된다.)
 */
-(void)StartRecognize:(NSNotification*)event
{
    NSLog(@"GUI-StartRecognize:%@",[event userInfo]);
    
    self.bStartRecog = YES;
    
    self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
    self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
    
    
    [self.popOverSpinner startAnimating];
    self.popOverSpinner.hidden = NO;
    //self.popOverImgView.image = [UIImage imageNamed:@"soundWave01.png"];
    self.popOverImgView.animationImages = [NSArray arrayWithObjects:[UIImage imageNamed:@"soundWave01.png"],[UIImage imageNamed:@"soundWave02.png"], nil];
    //self.popOverImgView.animationRepeatCount = 0;
    self.popOverImgView.animationDuration = 0.7;
    [self.popOverImgView startAnimating];
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO; 
    
    NSLog(@"GUI-StartRecognize:%@",[event userInfo]);
    
    self.popOverLabel.text = @"음성인식중";
    
    //타이머 해제를 인식 시작하면 종료로 변경? 
    if(aqBufCheckTimer != nil) 
    {
        [aqBufCheckTimer invalidate];
        aqBufCheckTimer = nil;
        NSLog(@"[StartRecognize]:aqBufCheckTimer invalidated!");
    }
    
    //음성 인식 시작하면 파형 클래스에 최종 파형 배열 전달 & 파형 그리기 메시지 전달: 최종 전체 파형 그리기 용도 
    
    //@synchronized(self)
    {       
        //마지막 파형 플래그 설정
        self.waveFormView.isFinalWave = YES;
        NSLog(@"[StartRecognize]:Final waveLevel Tx to WaveForm! ==> waveLevel count: %d",[waveLevel count]);
    }
}

/*
 서버측에서 음성 수신이 완료되고 음성 인식이 실패하게 되면 FailedRecognize 통지를 받는 함수이다.
 (이 통지 함수 이후 Disconnect 통지도 호출된다.)
 --> 인식 실패후에도 팝오버 화면 유지
 */
-(void)FailedRecognize:(NSNotification*)event
{
    NSLog(@"GUI-FailedRecognize:%@",[event userInfo]);
    
    self.bFailRecog = YES;
    
    self.popOverRestartBtn.hidden = NO; 
    self.popOverRestartBtn.center = CGPointMake(6+57, 137+18);
    self.popOverCancelBtn.center = CGPointMake(125+57, 137+18); 
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    [self.popOverImgView stopAnimating];
    self.popOverImgView.image = [UIImage imageNamed:@"popOverMicImg.png"];
    
    self.shadeView.hidden = NO;
    self.popOverView.hidden = NO;
    
    self.SeachButton.enabled = NO;    
    
    
    NSNumber * state = (NSNumber*)[[event userInfo] objectForKey:@"status"];
    NSString* errLog = 
    [NSString stringWithFormat:@"서버 에러[%d]",[state intValue]];
    NSLog(@"GUI-FailedRecognize:%@",[event userInfo]);
    
    self.popOverLabel.text = errLog;
    
}

/*
 서버측에서 음성 수신이 완료되고 음성 인식이 완료 되면 SucessRecognize 통지를 받는 함수이다.
 (이 통지 함수 이후 Disconnect 통지도 호출된다.)
 
 이 함수는 parameter로 인식 결과를 담고 있는 오브젝트와 인식 결과를 어떻게 분석해야 하는지를 알려주는 몇가지 parameter가 함께 넘어온다.
 */
-(void)SucessRecognize:(NSNotification*)event
{
    //NSLog(@"GUI-SucessRecognize:%@",[event userInfo]);
    NSLog(@"GUI-SucessRecognize:");
    
    self.bSuccRecog = YES;
    
    NSString* strResult;
    
    self.popOverRestartBtn.hidden = YES; //결과 없음,묵음 화면에서만 보임
    self.popOverCancelBtn.center = CGPointMake(120.0, 134+18);  //초기 취소 버튼은 중앙에 위치 
    
    [self.popOverImgView stopAnimating];
    
    [self.popOverSpinner stopAnimating];
    self.popOverSpinner.hidden = YES;
    self.shadeView.hidden = YES;
    self.popOverView.hidden = YES;
    
    
    //인식 결과를 담고 있는 오브젝트
    NSData * data = [[event userInfo] objectForKey:@"szResult"];    // 음성 다중 결과값
    
    
    if(data != nil)
    {
        //결과 데이터 존재시 : 종료
        NSLog(@"%@",[NSString stringWithCString:(const char*)[data bytes] encoding:NSASCIIStringEncoding]);
        //BNF parsing
        int rst = [mpBnfParser ParseHvoiceRes2:(const char*)[data bytes] DataSize:[data length]];
        int cnt = mpBnfParser.xmlResultData.count;
        NSLog(@"BNF - %d:%d:%@",rst, cnt, mpBnfParser.xmlResultData);
        
        NSMutableArray* aResults = mpBnfParser.xmlResultData;
        if(![aResults count]){
            self.popOverLabel.text = @"검색결과가 없습니다";
            self.recogResultNone = YES;
            
            NSLog(@"검색결과가 없습니다");
            return;
        }
        
        for(int i = 0 ; i < [aResults count] ; i++)
        {
            strResult = [[[NSString alloc] init] autorelease];
            NSLog(@"strResult = %@ \n", strResult);
            
            NSMutableArray* aNBest = [aResults objectAtIndex:i];
            
            NSDictionary* dic = [aNBest objectAtIndex:0];
            //NSLog(@"===========333%@",dic);
            NSString* str = [[NSString alloc] init];
            
            int count = [[dic objectForKey:RESULT_XML_KEY_PRE[KEY_COUNT]] integerValue];
            int j = 0;
            
            /* ============================================
             연속어의 경우 한개의 NBest에 여러 단어를 포함 하고 있다.
             
             EX> 발화자      ==> "강남역 아웃백 이요"
             인식 1NBest ==> "강남역 아웃백 요"
             2NBest ==> "강남역 아웃백 "
             3NBest ==> "강남역 아웃백 이요"
             서비스 별로 사용 유/무가 결정 된다.
             ============================================*/
            for(j = 0 ; j < count ; j++)
            {
                NSString* strCurKeys  = [NSString  stringWithFormat:@"%@_%02i",	RESULT_XML_KEY_PRE[KEY_WORD], j + 1];
                
                if( j > 0 ) {
                    strResult = [str stringByAppendingFormat:@"%@ %@", strResult, [dic objectForKey:strCurKeys]];
                } else {
                    strResult= [str stringByAppendingFormat:@"%@", [dic objectForKey:strCurKeys]];
                }	
                [str release];
                
                NSLog(@"333partial:%@", strResult); //네비쪽 음성검색 결과
                
            }
            
            NSLog(@"333%@", strResult);
            
            [recogResult addObject:strResult];
            
        }
        
    } else {
        //결과 데이터 없음
        self.recogResultNone = YES;
        NSLog(@"result BNF NULL");
    }
    
    //table을 갱신한다.-> 인식 결과를 먼저 출력하고 잠시 후 외부연동 결과 출력하기
    [self.recogList reloadData];
    
    NSLog(@"[SuccessRecognize]:[recogResult count] = %d",[recogResult count]);
    
    self.shadeView.hidden = YES;
    self.popOverView.hidden = YES;
    
}

#pragma mark - Timer
//타이머에서 오디오큐 버퍼에 접근해서 데이터 얻어오기 함
-(void)onAQBufChkTimer:(NSTimer*)timer
{    
    //6140: 오디오 버퍼에 접근
    if(aqBufRef == NULL)
    {
        aqBufRef =[[avrController sharedAVRController] Queue];
        
    }    
    
    if(aqBufRef != NULL)
    {
        //UInt32 propertySize;
        UInt32 ioDataSize = sizeof(AudioQueueLevelMeterState);
        OSStatus tmpSts;
        
        if (aqLevelArr != NULL) 
        {
            //            NSLog(@"onAQBufChkTimer: aqLevelArr != NULL,waveLevel != 0.0");
            
            memset(aqLevelArr, 0x00, sizeof(aqLevelArr));
            
            tmpSts = AudioQueueGetProperty (aqBufRef,kAudioQueueProperty_CurrentLevelMeter,
                                            aqLevelArr,&ioDataSize);
            NSLog(@"AQ[STATUS: CurrentLevelMeter] = %ld",tmpSts);
            NSLog(@"AQ[kAudioQueueProperty_CurrentLevelMeter].ioDataSize = %lu",ioDataSize);
            NSLog(@"AQ[kAudioQueueProperty_CurrentLevelMeter].aqLevelArr[0].mAveragePower = %lf",aqLevelArr[0].mAveragePower);
            
            [waveLevel addObject:[NSNumber numberWithFloat:aqLevelArr[0].mAveragePower]];
            
        }
        else
        {
            NSLog(@"onAQBufChkTimer: aqLevelArr == NULL,waveLevel = 0.0");
            [waveLevel addObject:[NSNumber numberWithFloat:0.0]];
            
        }
        
        self.waveFormView.waveForm  = waveLevel;
    }
    else
    {
        NSLog(@"aqBufRef is NULL");
    }
    
    [self.waveFormView setNeedsDisplay];
    
}


//스레드 에서 오디오큐 버퍼에 접근해서 데이터 얻어오기 함
-(void)onAQBufChkHandler:(id)data
{    
    @synchronized(self)
    {
        NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
        
        while (1) 
        {
            if (isCanceled) {
                return;
            }
            
            //6140: 오디오 버퍼에 접근
            if(aqBufRef == NULL)
            {
                aqBufRef =[[avrController sharedAVRController] Queue];
                
                OSStatus osStat;
                
                CAStreamBasicDescription queueFormat;
                UInt32 data_sz = sizeof(queueFormat);
                osStat = AudioQueueGetProperty(aqBufRef, kAudioQueueProperty_StreamDescription, &queueFormat, &data_sz);
                NSLog(@"osStat[StreamDescription]: %ld",osStat);
                NSLog(@"[onAQBufChkTimer] ch =  %lu",queueFormat.NumberChannels());
            }    
            
            if(aqBufRef != NULL)
            {
                //UInt32 propertySize;
                UInt32 ioDataSize = sizeof(AudioQueueLevelMeterState);
                OSStatus tmpSts;
                
                if (aqLevelArr != NULL) 
                {
                    memset(aqLevelArr, 0x00, sizeof(aqLevelArr));
                    
                    tmpSts = AudioQueueGetProperty (aqBufRef,kAudioQueueProperty_CurrentLevelMeter,
                                                    aqLevelArr,&ioDataSize);
                    NSLog(@"AQ[kAudioQueueProperty_CurrentLevelMeter].aqLevelArr[0].mAveragePower = %lf",aqLevelArr[0].mAveragePower);
                    
                    [waveLevel addObject:[NSNumber numberWithFloat:aqLevelArr[0].mAveragePower]];
                    
                }
                else
                {
                    [waveLevel addObject:[NSNumber numberWithFloat:0.0]];
                    
                }
                
                self.waveFormView.waveForm  = waveLevel;
            }
            else
            {
                NSLog(@"aqBufRef is NULL");
            }
            
            //waveform 리프레시
            [self performSelectorOnMainThread:@selector(refreshWaveForm) withObject:nil waitUntilDone:NO];
        }
        [pool drain];
    }
}


-(void)refreshWaveForm
{
    [self.waveFormView setNeedsDisplay];
}


-(void)opQueueHandler:(id)data
{
    NSAutoreleasePool* pool = [[NSAutoreleasePool alloc] init];
    
    aqBufCheckTimer = [NSTimer scheduledTimerWithTimeInterval:0.005 target:self selector:@selector(onAQBufChkTimer:) userInfo:self repeats:YES];
    
    [pool drain];
}

@end
